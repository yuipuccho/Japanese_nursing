//
//  SceneDelegate.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/06/03.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        self.window = window
        window.makeKeyAndVisible()
        let vc = UIStoryboard(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "TabbarController")
        let tab = vc as! TabBarController
        window.rootViewController = tab
    }

}

