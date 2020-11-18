//
//  StudyTargetSettingViewController.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/19.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import UIKit

/**
 * 目標学習数の設定画面VC
 */
class StudyTargetSettingViewController: UIViewController {

    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

// MARK: - MakeInstance

extension StudyTargetSettingViewController {

    static func makeInstance() -> UIViewController {
        guard let vc = R.storyboard.studyTargetSettingViewController.studyTargetSettingViewController() else {
            assertionFailure("Can't make instance 'StudyTargetSettingViewController'.")
            return UIViewController()
        }
        return vc
    }

    static func makeInstanceInNavigationController() -> UIViewController {
        return UINavigationController(rootViewController: makeInstance())
    }

}
