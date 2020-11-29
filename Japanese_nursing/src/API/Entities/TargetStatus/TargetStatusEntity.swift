//
//  TargetStatusEntity.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/30.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import Foundation

/**
 * 目標達成状況Entity
 */
public struct TargetStatusEntity: Codable {

    public let target_testing_count: Int
    public let today_tested_count: Int
    public let target_learning_count: Int
    public let today_learned_count: Int

}
