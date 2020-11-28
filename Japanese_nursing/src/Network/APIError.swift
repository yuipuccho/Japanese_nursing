//
//  APIError.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/28.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import Foundation

public enum JnAPIError: Error, CustomStringConvertible {
    case notReachable
    case timeout
    case noResponseValue
    case apiError(SimpleResponse)
    case responseError(NSError, SimpleResponse?)
    /// CodableによるJSONパース失敗
    case jsonError(Error)

    public var description: String {
        switch self {
        case .notReachable:
            return "ネットワークに接続されていません。\n端末の設定をご確認ください。"
        case .timeout:
            return "通信がタイムアウトになりました。\n電波のいい場所で再度お試しいただくようお願いします。"
        case .apiError(let res):
            return res.message
        case .responseError( _, let res):
            if let r = res {
                return r.message
            } else {
                return "ネットワーク環境が不安定です。\n電波のいい場所で再度お試しいただくようお願いします。"
            }
        default:
            return "ネットワーク環境が不安定です。\n電波のいい場所で再度お試しいただくようお願いします。"
        }
    }

    var jsonData: Json? {
        switch self {
        case .apiError(let res):
            return res.jsonData
        case .responseError( _, let res):
            return res?.jsonData
        default:
            return nil
        }
    }
}
