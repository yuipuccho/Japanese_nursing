//
//  GetTestWords.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/12/02.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import APIKit
import Foundation

/**
 * テスト単語取得API Request.
 */
public struct GetTestWordsRequest: JapaneseNursingRequest {

    /// 認証トークン
    private var authToken: String
    /// 出題範囲(0: すべて、1: 苦手、 2: 未出題)
    private var questionRange: Int
    /// 出題数
    private var limit: Int

    /// init and set query parameters.
    public init(authToken: String, questionRange: Int, limit: Int) {
        self.authToken = authToken
        self.questionRange = questionRange
        self.limit = limit
    }

    // MARK: APIKit.Request
    public typealias Response = GetTestWordsResponse

    public var method: HTTPMethod {
        return .get
    }

    public var path: String {
        return makePath(path: "/test_words/")
    }

    /// The actual parameters.
    public var parameters: Any? {
        var params = parametersWithToken
        params["auth_token"] = authToken
        params["question_range"] = questionRange
        params["limit"] = limit
        return params
    }

}

/**
 * 学習単語取得API Response
 */
public struct GetTestWordsResponse: JapaneseNursingResponse {

    public typealias Entity = TestWordsEntity

    public let result: Bool

    public let message: String

    public let object: Entity?

    public let error_code: Int?

}
