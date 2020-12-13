//
//  TargetStatusDomainModel.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/30.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import Foundation

/**
 * 目標達成状況のDomainModel
 */
struct TargetStatusDomainModel {

    var targetTestingCount: Int
    var todayTestedCount: Int
    var targetLearningCount: Int
    var todayLearnedCount: Int

    init(entity: TargetStatusEntity) {
        targetTestingCount = entity.target_testing_count
        todayTestedCount = entity.today_tested_count
        targetLearningCount = entity.target_learning_count
        todayLearnedCount = entity.today_learned_count
    }

}
