//
//  UpdateUserName.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/30.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import APIKit
import Foundation

/**
 * ユーザ情報更新API Request.
 */
public struct PutUserRequest: JapaneseNursingRequest {

    /// 認証トークン
    private var authToken: String
    /// ユーザ名
    private var userName: String
    /// ユーザID
    private var id: Int

    /// init and set query parameters.
    public init(authToken: String, userName: String) {
        self.authToken = authToken
        self.userName = userName
        self.id = ApplicationConfigData.userID
    }

    // MARK: APIKit.Request
    public typealias Response = PutUserResponse

    public var method: HTTPMethod {
        return .put
    }

    public var path: String {
        return makePath(path: "/users/\(id)/")
    }

    /// The actual parameters.
    public var parameters: Any? {
        var params = parametersWithToken
        params["auth_token"] = authToken
        params["user_name"] = userName
        return params
    }

}

/**
 * ユーザ情報更新API Response
 */
public struct PutUserResponse: JapaneseNursingResponse {

    public typealias Entity = [String: String]  // Entityなし

    public let result: Bool

    public let message: String

    public let object: Entity?

    public let error_code: Int?

}
