//
//  JapaneseNursingAPI.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/14.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import APIKit
import Foundation
import RxSwift
import SwiftDate
import SwiftyJSON
import XCGLogger

// MARK: - logger定義
/// 器として用意しており、実際は本体側で用意したインスタンスを保持させる
public var log = XCGLogger.default

// MARK: - 書式指定子
/// キャスティングで用いる日付フォーマット指定子
///
let CastingDateTimeFormat = DateToStringStyles.custom("yyyy/MM/dd HH:mm:ss")

// MARK: - Error定義
/// API層で発生するError型式
///
public enum APIError: Error {
    /// ページング処理を行おうとしたが、ページ番号等の情報が無い
    case noPageNumber
    /// Entity領域が見付からない
    case entityNotExist
    /// statusが200~300以外
    case statusError(info: ResponseErrorInfo?)
    /// status200でもresultがfalse
    case illegal(response: ResponseErrorInfo)
    /// decoding error
    case decodingError
}

// MARK: - 認証トークン
/// Auth Tokenの保持者を示すプロトコル定義
///
public protocol AuthTokenHolder {

    var currentToken: String { get }

}

/// APIの基本機能実装部
/// - note: APIで必要とする共有機能はここに集める
///
public struct API {

    /// API version number. (for RoR)
    public enum Version: String {
        case v1
        case v2
        case v3
        case v4
        case v5
    }

    /// scheme指定
    /// - note: 取り敢えず、Read/Write許可
    /// - note: 後で何かしらのガードは入れるかも
    static var scheme: String = {
        if Constants.DEBUG {
            return "http"
        } else {
            // TODO: 後で追記
            return ""
        }
    }()

    /// 接続先ホスト指定
    /// - note: 取り敢えず、Read/Write許可
    /// - note: 後で何かしらのガードは入れるかも
    public static var host: String = {
        if Constants.DEBUG {
            return "localhost:3000"
        } else {
            // TODO: 後で追記
            return ""
        }
    }()

    /// APIパスの生成処理
    /// - parameter version: バージョン指定子
    /// - returns: バージョン指定を元にしたAPIパス
    ///
    static func makePath(version: Version) -> String {
        return "/api/\(version)"
    }

    /// Auth Tokenの保持しているオブジェクトへの参照
    /// - note: ちょっと適当だけど、Auth取得したらここに設定する
    public static var tokenHolder: AuthTokenHolder?
}

// MARK: - APIKit.Requstの雛形定義
/**
 * request protocol for APIKit.
 */
public protocol JapaneseNursingRequest: Request {

    /// API version number.
    /// - note: 実装先でバージョンを再指定可能
    var version: API.Version { get }

    /// API parsing date format.
    /// - note: APIの基本となるDateFromatではない場合に任意のFormatを指定可能
    ///   - default : "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    var dateFormat: String { get }

}

// MARK: デフォルト実装
extension JapaneseNursingRequest {

    /// バージョン指定のデフォルト値
    public var version: API.Version {
        return API.Version.v1
    }

    /// The base URL.
    public var baseURL: URL {
        var compo = URLComponents()
        compo.scheme = API.scheme
        compo.host = API.host
//        if let url = compo.url {
//            print(url)
//            return url
//        }
        return URL(string: "http://localhost:3000")!
//        return URL(strin: "")
        assertionFailure()
        return URL(string: "")!
    }

    /// Create and return RxSwift Observable object.
    public func asObservable() -> Observable<Response> {
        return Session.rx_sendRequest(self)
    }

    /// Generate API path string.
    /// - note: APIパスの生成処理
    ///
    func makePath(path: String) -> String {
        return API.makePath(version: self.version) + path
    }

    /// auth付きパラメータ作成用
    /// - note: authを必要とするAPI呼び出しでは、parametersでこれを用いる
    ///
    var parametersWithToken: [String: Any] {
        if let token = API.tokenHolder?.currentToken {
            return [
                "auth_token": token
            ]
        } else {
            return [:]
        }
    }
}

// MARK: - Logging処理(共通)
extension JapaneseNursingRequest {

    private func loggingRequest(_ request: URLRequest) {
        // HTTP Method
        guard let method = request.httpMethod else {
            log.warning("missing http method: \(request.description)")
            return
        }
        // Request URL
        guard let url = request.url?.absoluteString else {
            log.warning("missing url: \(request.description)")
            return
        }

        log.info("\(method) \(url)")
    }

    private func loggingResponse(_ response: HTTPURLResponse, body object: Any) {
        // HTTP Status Code
        let statusCode = response.statusCode
        // HTTP Status
        let status = HTTPURLResponse.localizedString(forStatusCode: statusCode)
        // Response URL
        guard let url = response.url?.absoluteString else {
            log.warning("missing url: \(response.description)")
            return
        }
        // Response Body
        if let data = object as? Data {
            if let dataString = String(data: data, encoding: String.Encoding.utf8) {
                log.info("[\(statusCode), \(status)] \(url)\n\(dataString)")
            } else {
                log.info("[\(statusCode), \(status)] \(url) size: \(data.count)")
            }
        } else {
            log.info("[\(statusCode), \(status)] \(url) no body.")
        }
    }

}

// MARK: - APIKit override
extension JapaneseNursingRequest {

    public func intercept(urlRequest: URLRequest) throws -> URLRequest {

        // HTTP要求のLogging
        loggingRequest(urlRequest)

        return urlRequest
    }

    public func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {

        // HTTP応答のLogging
        loggingResponse(urlResponse, body: object)

        // statusCodeごとの処理
        if let event = APIEvent.Event(rawValue: urlResponse.statusCode) {
            APIEvent.eventStream(event: event)
        }

        // エラー情報処理
        guard 200..<300 ~= urlResponse.statusCode else {
            let errorInfo: ResponseErrorInfo?

            do {
                errorInfo = try ResponseErrorInfo.makeInstance(object: object)
            } catch {
                throw APIError.decodingError
            }
            throw APIError.statusError(info: errorInfo)
        }

        if let adjuster = self as? JsonBodyAdjustable {
            // RequestがJsonBodyAdjustableに適合していれば、JSONの調整を行う
            let adjusted = try adjuster.adjustBody(object: object, urlResponse: urlResponse)
            return adjusted
        } else {
            return object
        }
    }
}

extension Request where Response: JapaneseNursingResponse {

    /// The parser object that states `Content-Type` to accept and parses response body.
    public var dataParser: DataParser { return JapaneseNursingDataParser() }

    /// Date parsing format string.
    public var dateFormat: String { return "yyyy-MM-dd'T'HH:mm:ss.SSSZ" }

    /// Build `Response` instance from raw response object.
    public func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let data = object as? Data else {
            throw ResponseError.unexpectedObject(object)
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted({
            let f = DateFormatter()
            f.calendar = Calendar(identifier: .gregorian)
            f.locale = Locale(identifier: "en_US_POSIX")
            f.dateFormat = dateFormat
            return f
            }()
        )
        let response: Response
        do {
            response = try decoder.decode(Response.self, from: data)
        } catch let error {
            print(error.localizedDescription)
            throw error
        }

        if !response.result {
            throw APIError.illegal(
                response: ResponseErrorInfo(
                    result: response.result,
                    message: response.message,
                    error_code: response.error_code
                )
            )
        }

        return response
    }

}

// MARK: - APIKit.Responseの雛形定義
/**
 * API Response protocol.
 */
public protocol JapaneseNursingResponse: Decodable {

    /// Response entity object type
    associatedtype Entity: Decodable

    /// Return result from API when code 200.
    var result: Bool { get }

    /// Message from API.
    var message: String { get }

    /// Error Code from API.
    /// - note: error_code or object
    var error_code: Int? { get }

    /// Result object in response.
    /// - note: error_code or object
    var object: Entity? { get }

}

// MARK: - JSONパース処理
/**
 * Data parser class
 * - note: objectキー追加処理、でもある
 */
final class JapaneseNursingDataParser: DataParser {

    /// Value for `Accept` header field of HTTP request.
    var contentType: String? { return "application/json" }

    /// Return `Any` that expresses structure of response such as JSON and XML.
    /// - Throws: `Error` when parser encountered invalid format data.
    func parse(data: Data) throws -> Any {
        let json = JSON(data)

        var dict = [String: Any]()

        // そもそも、resultキーが取れるか？
        if let result = json["result"].bool {
            if result {
                // resultキーが真値を示したので、
                // result + mesasge以外のキー値をobjectと見なす
                dict["object"]  = json.dictionaryValue.filter { ($0.key != "result" && $0.key != "message") }
            } else {
                // resultキーが偽値なのでerror_codeを取得する
                dict["error_code"] = json["error_code"].intValue
            }
            // result + messageはいつでも存在する
            dict["result"]  = result
            dict["message"] = json["message"].stringValue

        } else { // resultキー自体が見付からない場合！
            // TODO: 結構、破壊的な状態ではなかろうか・・・。
            dict["result"]  = false
            dict["message"] = "Failed parse response."
            dict["object"]  = [:]
        }

        return try JSON(dict).rawData()
    }

}

// MARK: - 拡張intercept
/// 応答JSONを調整するためのプロトコル
///
protocol JsonBodyAdjustable {

    func intercept(json: JSON, urlResponse: HTTPURLResponse) -> JSON
}

extension JsonBodyAdjustable {

    fileprivate func adjustBody(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        guard let mime = urlResponse.mimeType else {
            // MIME設定なしの場合
            return object
        }
        switch mime {
        case "application/json":
            guard let data = object as? Data else {
                // BODYがData型でない場合
                return object
            }
            let json = try JSON(data: data)
            let adjusted = intercept(json: json, urlResponse: urlResponse)
            return try adjusted.rawData()
        default:
            // MIME設定がJSONでない場合
            return object
        }
    }

}
