//
//  TestViewController.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/21.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import UIKit
import ColorMatchTabs

class ExampleViewContoller: ColorMatchTabsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.font = UIFont.navigationTitleFont()
        // to hide bottom button remove the following line
        popoverViewController = ExamplePopoverViewController()
        popoverViewController?.modalPresentationStyle = .fullScreen
        popoverViewController?.delegate = self

        colorMatchTabDataSource = self
    }

}

extension ExampleViewContoller: ColorMatchTabsViewControllerDataSource {

    func numberOfItems(inController controller: ColorMatchTabsViewController) -> Int {
        return TabItemsProvider.items.count
    }

    func tabsViewController(_ controller: ColorMatchTabsViewController, viewControllerAt index: Int) -> UIViewController {
        return StubContentViewControllersProvider.viewControllers[index]
    }

    func tabsViewController(_ controller: ColorMatchTabsViewController, titleAt index: Int) -> String {
        return TabItemsProvider.items[index].title
    }

    func tabsViewController(_ controller: ColorMatchTabsViewController, iconAt index: Int) -> UIImage {
        return TabItemsProvider.items[index].normalImage
    }

    func tabsViewController(_ controller: ColorMatchTabsViewController, hightlightedIconAt index: Int) -> UIImage {
        return TabItemsProvider.items[index].highlightedImage
    }

    func tabsViewController(_ controller: ColorMatchTabsViewController, tintColorAt index: Int) -> UIColor {
        return TabItemsProvider.items[index].tintColor
    }

}

extension ExampleViewContoller: PopoverViewControllerDelegate {

    func popoverViewController(_ popoverViewController: PopoverViewController, didSelectItemAt index: Int) {
        selectItem(at: index)
    }

}

extension ExampleViewContoller {

    static func makeInstance() -> UIViewController {
        guard let vc = R.storyboard.ExampleViewContoller.ExampleViewContoller() else {
            assertionFailure("Can't make instance 'SettingListViewController'.")
            return UIViewController()
        }
        return vc
    }
}
