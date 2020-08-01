//
//  ViewController.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/06/03.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        //goToTabBar()
    }

    func goToTabBar() {
        let vc = UIStoryboard(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "TabbarController")
        let tab = vc as! TabBarController

        // 学習タブ
        tab.selectedViewController = tab.firstVC

        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }

}
