//
//  Error+Extended.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/28.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import APIKit
import Foundation

extension Error {

    // MARK: public
    /// API等で定義している独自Errorに対応したdescription
    public var descriptionOfType: String {
        if let e = self as? APIError {
            return errorDescription(e)
        }

        if let e = self as? JnAPIError {
            return e.description
        }

        guard let err = self as? SessionTaskError else {
            return localizedDescription
        }

        switch err {
        /// Error of `URLSession`.
        case .connectionError(let e):
            return e.localizedDescription

        /// Error while creating `URLRequest` from `Request`.
        case .requestError(let e):
            return e.localizedDescription

        /// Error while creating `Request.Response` from `(Data, URLResponse)`.
        case .responseError(let e as APIError):
            return errorDescription(e)

        default:
            return err.localizedDescription
        }
    }

    // MARK: private
    /// APIErrorのdescription解釈
    /// - Parameters:
    ///   - e: エラー文を返したいエラー
    /// - returns: エラー文の内容
    private func errorDescription(_ e: APIError) -> String {
        switch e {
        case .statusError(let info):
            return info?.message ?? e.localizedDescription
        case .illegal(let response):
            return response.message ?? e.localizedDescription
        default:
            return e.localizedDescription
        }
    }

    /**
     * APIErrorからエラーコードを取得
     * - Parameters:
     *   - error: エラー内容
     * - returns: エラーコード
     */
    private func getErrorCode(error: APIError) -> Int? {
        // エラー内容を場合分け
        switch error {
        case .statusError(info: let info):
            return info?.error_code
        case .illegal(response: let response):
            return response.error_code
        default:
            return nil
        }
    }
}
