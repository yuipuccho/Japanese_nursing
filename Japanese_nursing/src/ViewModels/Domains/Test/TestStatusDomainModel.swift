//
//  TestStatusDomainModel.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/29.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import Foundation

/**
 * テスト状況のDomainModel
 */
struct TestStatusDomainModel {

    var allWordCount: Int
    var correctWordCount: Int
    var mistakeWordCount: Int
    var unquestionedWordCount: Int

    init(entity: TestStatusEntity) {
        allWordCount = entity.all_word_count
        correctWordCount = entity.correct_word_count
        mistakeWordCount = entity.mistake_word_count
        unquestionedWordCount = entity.unquestioned_word_count
    }

}
