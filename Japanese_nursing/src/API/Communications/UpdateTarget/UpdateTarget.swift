//
//  UpdateTarget.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/30.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import APIKit
import Foundation

/**
 * 目標更新API Request.
 */
public struct PutTargetsRequest: JapaneseNursingRequest {

    /// 認証トークン
    private var authToken: String
    /// 目標学習数
    private var targetLearningCount: Int?
    /// 目標テスト数
    private var targetTestingCount: Int?

    /// init and set query parameters.
    public init(authToken: String, targetLearningCount: Int?, targetTestingCount: Int?) {
        self.authToken = authToken
        self.targetLearningCount = targetLearningCount
        self.targetTestingCount = targetTestingCount
    }

    // MARK: APIKit.Request
    public typealias Response = PutTargetsResponse

    public var method: HTTPMethod {
        return .put
    }

    public var path: String {
        return makePath(path: "/user_learning_targets/")
    }

    /// The actual parameters.
    public var parameters: Any? {
        var params = parametersWithToken
        params["auth_token"] = authToken
        params["target_learning_count"] = targetLearningCount
        params["target_testing_count"] = targetTestingCount
        return params
    }

}

/**
 * 目標更新API Response
 */
public struct PutTargetsResponse: JapaneseNursingResponse {

    public typealias Entity = [String: String]  // Entityなし

    public let result: Bool

    public let message: String

    public let object: Entity?

    public let error_code: Int?

}
