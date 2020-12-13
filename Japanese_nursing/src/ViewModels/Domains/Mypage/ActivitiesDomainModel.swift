//
//  ActivitiesDomainModel.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/30.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import Foundation

/**
 * アクティビティのDomainModel
 */
struct ActivitiesDomainModel {

    var date: Date
    var learnedCount: Int
    var testedCount: Int

    init(entity: ActivityBodyEntity) {
        date = entity.date
        learnedCount = entity.learned_count
        testedCount = entity.tested_count
    }

}
