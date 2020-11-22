//
//  Constants.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/14.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import Foundation

/**
 * Constants
 */
internal struct Constants {

    /// 開発版モード
    /// - Budle ID: 開発版
    /// - API接続先: 開発環境
    ///
    static var DEBUG: Bool {
        #if DEBUG || PAYMENT
        // DEBUG、PAYMENTが定義されていたら開発モード
        return true
        #else
        return false
        #endif
    }

}
