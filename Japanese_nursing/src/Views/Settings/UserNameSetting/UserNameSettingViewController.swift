//
//  UserNameSettingViewController.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/13.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import UIKit

/**
 * ユーザ名変更VC
 */
class UserNameSettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

// MARK: - MakeInstance

extension UserNameSettingViewController {

    static func makeInstance() -> UIViewController {
        guard let vc = R.storyboard.userNameSettingViewController.userNameSettingViewController() else {
            assertionFailure("Can't make instance 'UserNameSettingViewController'.")
            return UIViewController()
        }
        return vc
    }

    static func makeInstanceInNavigationController() -> UIViewController {
        return UINavigationController(rootViewController: makeInstance())
    }

}
