//
//  CreateUser.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/28.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import APIKit
import Foundation

/**
 * ユーザ作成API Request.
 */
public struct PostCreateUserRequest: JapaneseNursingRequest {

    /// 匿名ユーザかどうか
    private var isAnonymous: Bool
    /// ユーザ名
    private var userName: String

    /// init and set query parameters.
    public init(isAnonymous: Bool, userName: String) {
        self.isAnonymous = isAnonymous
        self.userName = userName
    }

    // MARK: APIKit.Request
    public typealias Response = PostCreateUserResponse

    public var method: HTTPMethod {
        return .post
    }

    public var path: String {
        return makePath(path: "/users/")
    }

    /// The actual parameters.
    public var parameters: Any? {
        var params = parametersWithToken
        params["is_anonymous"] = isAnonymous
        params["user_name"] = userName
        return params
    }

}

/**
 * ユーザ作成API Response
 */
public struct PostCreateUserResponse: JapaneseNursingResponse {

    public typealias Entity = CreateUserEntity

    public let result: Bool

    public let message: String

    public let object: Entity?

    public let error_code: Int?

}
