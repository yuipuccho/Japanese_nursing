//
//  StudyTabContainerViewController.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/07/30.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import Foundation
import Tabman
import Pageboy
import UIKit

/**
 * 学習画面(学習中/修了)タブ表示VC
 */

class StudyTabContainerViewController: TabmanViewController {

    // MARK: - viewModel

    lazy var viewModel: StudyTabContainerViewModelProtocol = StudyTabContainerViewModel()

    // MARK: - Properties

    /// タブ高さ
    private let tabHeight: CGFloat = 36

    /// 表示内容一覧
    private enum Content {
        // 学習中
        case inProgress
        // 修了
        case completion
    }

    /// 現在表示している内容
    private var content: Content = .inProgress

    // MARK: - LifeCycle

    override func viewDidLoad() {
        // super内でDelegateがセットされる前に設定する必要がある
        automaticallyAdjustsChildInsets = false
        super.viewDidLoad()

        // セットアップ
        delegate = self
        dataSource = self
        setTabmanBarAppearance()
    }

    // MARK: - Functions

    private func setTabmanBarAppearance() {
        let bar = TMBar.ButtonBar()
        // タブ全体の設定
        bar.layout.transitionStyle = .snap
        bar.layout.interButtonSpacing = 0
        bar.layout.contentMode = .fit
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        bar.backgroundView.style = .flat(color: .white)

        // 下線部の設定
        bar.indicator.tintColor = R.color.mainBlue()
        bar.indicator.weight = .custom(value: 1.0)

        // ボタンの設定
        bar.buttons.customize { ( btns ) in
            btns.tintColor = R.color.weakText()
            btns.selectedTintColor = R.color.planeText()
        }
        addBar(bar, dataSource: self, at: .top)
    }
}

extension StudyTabContainerViewController: PageboyViewControllerDataSource, TMBarDataSource {

    /// タブの表示内容
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        return viewModel.items[index]
    }

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewModel.viewControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewModel.viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }

}
