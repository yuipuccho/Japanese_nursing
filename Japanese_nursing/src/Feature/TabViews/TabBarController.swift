//
//  TabBarController.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/06/27.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import UIKit

extension UITabBarController {

    /// 各画面のタブ
    enum TabVCIndex: Int {
        case study = 0
        case test = 1
        case myPage = 2
    }
    
}

extension UITabBarController {

    var firstVC: UIViewController? {
        return self.viewControllers?.first
    }
}

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
