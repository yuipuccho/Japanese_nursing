//
//  TestStatusEntity.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/29.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import Foundation

/**
 * テスト状況Entity
 */
public struct TestStatusEntity: Codable {

//    public let unit_masters: [TestStatusBodyEntity]
//    public let total_count: Int
    public let all_word_count: Int
    public let correct_word_count: Int
    public let mistake_word_count: Int
    public let unquestioned_word_count: Int

}

//public struct TestStatusBodyEntity: Codable {
//
//    public let id: Int
//    public let japanese: String
//    public let vietnamese: String
//    public let created_at: Date
//    public let updated_at: Date
//    public let word_count: Int
//    public let memorized_word_count: Int
//
//}
