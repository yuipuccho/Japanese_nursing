//
//  UnitMastersEntity.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/29.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import Foundation

/**
 * 単元一覧Entity
 */
public struct UnitMastersEntity: Codable {

    public let unit_masters: [UnitMastersBodyEntity]
    public let total_count: Int

}

public struct UnitMastersBodyEntity: Codable {

    public let id: Int
    public let japanese: String
    public let vietnamese: String
    public let created_at: Date
    public let updated_at: Date
    public let word_count: Int
    public let memorized_word_count: Int

}
