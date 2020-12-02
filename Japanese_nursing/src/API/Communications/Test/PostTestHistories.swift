//
//  PostTestHistories.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/12/02.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import APIKit
import Foundation

/**
 * テスト履歴更新API Request.
 */
public struct PostTestHistoriesRequest: JapaneseNursingRequest {

    /// 認証トークン
    private var authToken: String
    /// 正解した単語のID配列(stringで1,2,3,4のような形で指定する)
    private var correctIds: String
    /// 間違えた単語のID配列(stringで1,2,3,4のような形で指定する)
    private var mistakeIds: String

    /// init and set query parameters.
    public init(authToken: String, correctIds: String, mistakeIds: String) {
        self.authToken = authToken
        self.correctIds = correctIds
        self.mistakeIds = mistakeIds
    }

    // MARK: APIKit.Request
    public typealias Response = PostTestHistoriesResponse

    public var method: HTTPMethod {
        return .post
    }

    public var path: String {
        return makePath(path: "/test_histories/")
    }

    /// The actual parameters.
    public var parameters: Any? {
        var params = parametersWithToken
        params["auth_token"] = authToken
        params["correct_ids"] = correctIds
        params["mistake_ids"] = mistakeIds
        return params
    }

}

/**
 * テスト履歴更新API Response
 */
public struct PostTestHistoriesResponse: JapaneseNursingResponse {

    public typealias Entity = [String: String]  // Entityなし

    public let result: Bool

    public let message: String

    public let object: Entity?

    public let error_code: Int?

}
