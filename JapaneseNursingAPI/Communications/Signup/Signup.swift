//
//  Signup.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/15.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import APIKit
import Foundation

/**
 * ユーザ作成API Request.
 */
public struct PostSignupRequest: JapaneseNursingRequest {

    /// ユーザ名
    private var userName: String

    /// init and set query parameters.
    public init(userName: String) {
        self.userName = userName
    }

    // MARK: APIKit.Request
    public typealias Response = PostSignupResponse

    public var method: HTTPMethod {
        return .post
    }

    public var path: String {
        return makePath(path: "/api/v1/users/")
    }

    /// The actual parameters.
    public var parameters: Any? {
        var params = parametersWithToken
        params["user_name"] = userName
        return params
    }

}

/**
 * ユーザ作成API Response
 */
public struct PostSignupResponse: JapaneseNursingResponse {

    public typealias Entity = [String: String]

    public let result: Bool

    public let message: String

    public let object: Entity?

    public let error_code: Int?

}
