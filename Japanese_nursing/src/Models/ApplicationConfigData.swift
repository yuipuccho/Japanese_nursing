//
//  ApplicationConfigData.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/28.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import Foundation

class ApplicationConfigData {

    private init() {}

    private static let ud = UserDefaults.standard

    /// ユーザID
    static var userID: Int {
        get { return self.ud.integer(forKey: "userID")}
        set { self.ud.set(newValue, forKey: "userID")}
    }

    /// authToken
    static var authToken: String {
        get { return self.ud.string(forKey: "authToken") ?? "" }
        set { self.ud.set(newValue, forKey: "authToken")}
    }

    /// role
    static var role: String {
        get { return self.ud.string(forKey: "role") ?? "" }
        set { self.ud.set(newValue, forKey: "role")}
    }

    /// ニックネーム
    static var userName: String {
        get { return self.ud.string(forKey: "userName") ?? "" }
        set { self.ud.set(newValue, forKey: "userName")}
    }

    /// email
    static var email: String {
        get { return self.ud.string(forKey: "email") ?? "" }
        set { self.ud.set(newValue, forKey: "email")}
    }

    /// 最初の単元一覧を表示したか
    static var hasShowedUnitList: Bool {
        get { return self.ud.bool(forKey: "hasShowedUnitList")}
        set { self.ud.set(newValue, forKey: "hasShowedUnitList")}
    }

    // 未送信の学習履歴
    /// 覚えた単語
    static var rememberIdsArray: [String] {
        get { return self.ud.stringArray(forKey: "rememberIdsArray") ?? [] }
        set { self.ud.set(newValue, forKey: "rememberIdsArray")}
    }
    /// 覚えていない単語
    static var notRememberIdsArray: [String] {
        get { return self.ud.stringArray(forKey: "notRememberIdsArray") ?? [] }
        set { self.ud.set(newValue, forKey: "notRememberIdsArray")}
    }

}
