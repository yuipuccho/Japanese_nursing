//
//  CreateUserEntity.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/22.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import Foundation

/**
 * ユーザ作成Entity
 */
public struct CreateUserEntity: Codable {

    public let body: CreateUserBodyEntity

}

public struct CreateUserBodyEntity: Codable {

    public enum Role: String, Codable {
        case anonymous = "anonymous"
        case normal = "normal"
        case admin = "admin"
    }

    public let id: Int?
    public let email: String?
    public let created_at: Date?
    public let updated_at: Date?
    public let auth_token: String?
    public let user_name: String?
    public let role: String?
    public let role_enum: Role?

}
