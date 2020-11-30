//
//  ActivityEntity.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/30.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import Foundation

/**
 * アクティビティEntity
 */
public struct ActivityEntity: Codable {

    public let activities: [ActivityBodyEntity]

}

public struct ActivityBodyEntity: Codable {

    public let date: Date
    public let learned_count: Int
    public let tested_count: Int

}
