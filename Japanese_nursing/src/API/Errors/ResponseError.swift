//
//  ResponseError.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/28.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import Foundation
import APIKit

/// APIから情報を吸い出してError化
public struct ResponseErrorInfo: Codable {
    static func makeInstance(object: Any) throws ->  ResponseErrorInfo? {
        guard let data = object as? Data else {
            return nil
        }
        let info = try JSONDecoder().decode(ResponseErrorInfo.self, from: data)
        return info
    }
    public let result: Bool?
    public let message: String?
    public let error_code: Int?
}
