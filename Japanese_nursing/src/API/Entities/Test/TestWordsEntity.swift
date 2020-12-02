//
//  TestWordsEntity.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/12/02.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import Foundation

/**
 * テスト単語Entity
 */
public struct TestWordsEntity: Codable {

    public let tests: [TestWordsBodyEntity]
    public let total_count: Int

}

public struct TestWordsBodyEntity: Codable {

    public let id: Int
    public let furigana: String?
    public let japanese: String
    public let vietnamese: String
    public let dummy_vietnamese_1: String
    public let dummy_vietnamese_2: String
    public let dummy_vietnamese_3: String

}
