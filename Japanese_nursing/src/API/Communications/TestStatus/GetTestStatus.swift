//
//  GetTestStatus.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/29.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import APIKit
import Foundation

/**
 * テスト状況取得API Request.
 */
public struct GetTestStatusRequest: JapaneseNursingRequest {

    /// 認証トークン
    private var authToken: String

    /// init and set query parameters.
    public init(authToken: String) {
        self.authToken = authToken
    }

    // MARK: APIKit.Request
    public typealias Response = GetTestStatusResponse

    public var method: HTTPMethod {
        return .get
    }

    public var path: String {
        return makePath(path: "/test_histories/status/")
    }

    /// The actual parameters.
    public var parameters: Any? {
        var params = parametersWithToken
        params["auth_token"] = authToken
        return params
    }

}

/**
 * 単元一覧取得API Response
 */
public struct GetTestStatusResponse: JapaneseNursingResponse {    

    public typealias Entity = TestStatusEntity

    public let result: Bool

    public let message: String

    public let object: Entity?

    public let total_count: Int?

    public let error_code: Int?

}
