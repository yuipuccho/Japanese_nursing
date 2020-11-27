//
//  ApplicationConfigData.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/27.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import Foundation

class ApplicationConfigData {

    private init() {}

    private static let ud = UserDefaults.standard

    // ユーザID
    static var userID: Int {
        get { return self.ud.integer(forKey: "userID")}
        set { self.ud.set(newValue, forKey: "userID")}
    }

    // authToken
    static var authToken: String {
        get { return self.ud.string(forKey: "authToken") ?? "" }
        set { self.ud.set(newValue, forKey: "authToken")}
    }

    // role
    static var role: String {
        get { return self.ud.string(forKey: "role") ?? "" }
        set { self.ud.set(newValue, forKey: "role")}
    }

    // ユーザ名
    static var userName: String {
        get { return self.ud.string(forKey: "userName") ?? "" }
        set { self.ud.set(newValue, forKey: "userName")}
    }

    // email
    static var email: String {
        get { return self.ud.string(forKey: "email") ?? "" }
        set { self.ud.set(newValue, forKey: "email")}
    }

}
