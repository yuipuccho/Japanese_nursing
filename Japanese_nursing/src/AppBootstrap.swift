//
//  AppBootstrap.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/06/27.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import Foundation
import UIKit

struct AppBootstrap {

    fileprivate init () {}

    static func boost() {
        goToMainTabVC()
    }

    static func goToMainTabVC() {
        let vc = UIStoryboard(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "TabbarController")
        let tab = vc as! TabBarController

        // メインウィンドウのrootVCを更新
        AppDelegate.appDelegate?.window?.rootViewController = tab

        // 学習タブ
        tab.selectedViewController = tab.firstVC
    }

}
