//
//  GetActivities.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/30.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import APIKit
import Foundation

/**
 * アクティビティ取得API Request.
 */
public struct GetActivitiesRequest: JapaneseNursingRequest {

    /// 認証トークン
    private var authToken: String

    /// init and set query parameters.
    public init(authToken: String) {
        self.authToken = authToken
    }

    // MARK: APIKit.Request
    public typealias Response = GetActivitiesResponse

    public var method: HTTPMethod {
        return .get
    }

    public var path: String {
        return makePath(path: "/activity/")
    }

    /// The actual parameters.
    public var parameters: Any? {
        var params = parametersWithToken
        params["auth_token"] = authToken
        return params
    }

}

/**
 * 学習単語取得API Response
 */
public struct GetActivitiesResponse: JapaneseNursingResponse {

    public typealias Entity = ActivityEntity

    public let result: Bool

    public let message: String

    public let object: Entity?

    public let error_code: Int?

}
