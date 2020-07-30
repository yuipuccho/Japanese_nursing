//
//  StudyTabContainerViewModel.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/07/30.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import Tabman
import UIKit

/**
 * 学習タブ画面ViewModel対応Protocol
 */
protocol StudyTabContainerViewModelProtocol {

    /// タブ内のViewController
    var viewControllers: [UIViewController] { get }

    /// タブ表示文字列
    var items: [TMBarItem] { get }

}
