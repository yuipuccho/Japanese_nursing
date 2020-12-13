//
//  TargetStatus.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/30.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import APIKit
import Foundation

/**
 * 目標達成状況取得API Request.
 */
public struct GetTargetStatusRequest: JapaneseNursingRequest {

    /// 認証トークン
    private var authToken: String

    /// init and set query parameters.
    public init(authToken: String) {
        self.authToken = authToken
    }

    // MARK: APIKit.Request
    public typealias Response = GetTargetStatusResponse

    public var method: HTTPMethod {
        return .get
    }

    public var path: String {
        return makePath(path: "/user_learning_targets/")
    }

    /// The actual parameters.
    public var parameters: Any? {
        var params = parametersWithToken
        params["auth_token"] = authToken
        return params
    }

}

/**
 * 目標達成状況取得API Response
 */
public struct GetTargetStatusResponse: JapaneseNursingResponse {

    public typealias Entity = TargetStatusEntity

    public let result: Bool

    public let message: String

    public let object: Entity?

    public let total_count: Int?

    public let error_code: Int?

}
