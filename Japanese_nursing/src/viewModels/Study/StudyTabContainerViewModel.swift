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

/**
* 学習タブ画面ViewModel対応Protocol
*/
class StudyTabContainerViewModel: StudyTabContainerViewModelProtocol {

    /// タブ内のViewController
    let viewControllers: [UIViewController] = [
        InProgressListViewController.makeInstance(),
        CompletionListViewController.makeInstance()
    ]

    /// タブ表示文字列
    var items: [TMBarItem] {
        return _items
    }

    /// itemsの実体
    private lazy var _items: [TMBarItem] = { [unowned self] in
        var tabItems = Array<TMBarItem>(repeating: TMBarItem(title: ""), count: 3)
        tabItems[0] = TMBarItem(title: self.viewControllers[0].title ?? "学習中")
        tabItems[1] = TMBarItem(title: self.viewControllers[1].title ?? "修了")
        return tabItems
    }()

}
