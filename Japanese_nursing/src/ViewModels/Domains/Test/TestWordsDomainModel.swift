//
//  TestWordsDomainModel.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/12/02.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import Foundation

/**
 * テスト単語のDomainModel
 */
struct TestWordsDomainModel {

    var id: Int
    var furigana: String?
    var japanese: String
    var vietnamese: String
    var dummyVietnamese1: String
    var dummyVietnamese2: String
    var dummyVietnamese3: String

    init(entity: TestWordsBodyEntity) {
        id = entity.id
        furigana = entity.furigana
        japanese = entity.japanese
        vietnamese = entity.vietnamese
        dummyVietnamese1 = entity.dummy_vietnamese_1
        dummyVietnamese2 = entity.dummy_vietnamese_2
        dummyVietnamese3 = entity.dummy_vietnamese_3
    }

}
