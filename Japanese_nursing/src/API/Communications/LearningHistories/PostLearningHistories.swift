//
//  PostLearningHistories.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/12/01.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import APIKit
import Foundation

/**
 * 学習履歴更新API Request.
 */
public struct PostLearningHistoriesRequest: JapaneseNursingRequest {

    /// 認証トークン
    private var authToken: String
    /// 覚えた単語のID配列(stringで1,2,3,4のような形で指定する)
    private var rememberIds: String
    /// 覚えていない単語のID配列(stringで1,2,3,4のような形で指定する)
    private var notRememberIds: String

    /// init and set query parameters.
    public init(authToken: String, rememberIds: String, notRememberIds: String) {
        self.authToken = authToken
        self.rememberIds = rememberIds
        self.notRememberIds = notRememberIds
    }

    // MARK: APIKit.Request
    public typealias Response = PostLearningHistoriesResponse

    public var method: HTTPMethod {
        return .post
    }

    public var path: String {
        return makePath(path: "/learning_histories/")
    }

    /// The actual parameters.
    public var parameters: Any? {
        var params = parametersWithToken
        params["auth_token"] = authToken
        params["remember_ids"] = rememberIds
        params["not_remember_ids"] = notRememberIds
        return params
    }

}

/**
 * ユーザ情報更新API Response
 */
public struct PostLearningHistoriesResponse: JapaneseNursingResponse {

    public typealias Entity = [String: String]  // Entityなし

    public let result: Bool

    public let message: String

    public let object: Entity?

    public let error_code: Int?

}
