//
//  Array+Extended.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/07.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {

    // 配列から値を指定して削除できるように拡張
    mutating func remove(value: Element) {
        if let i = self.firstIndex(of: value) {
            self.remove(at: i)
        }
    }

}
