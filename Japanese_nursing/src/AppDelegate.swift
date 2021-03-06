//
//  AppDelegate.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/06/03.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import UIKit

// MARK: - AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    override init() {
        super.init()
        // firebase init
//        let filePath: String?
//        #if PRODUCTION
//        filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")
//        #else
//        filePath = Bundle.main.path(forResource: "", ofType: "plist")
//        #endif

//        let option = FirebaseOptions(contentsOfFile: filePath!)
//        FirebaseApp.configure(options: option!)
    }

    static var appDelegate: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }

    /// AppDelegate.appDelgate
    static var shared: AppDelegate {
        guard let app = UIApplication.shared.delegate as? AppDelegate else {
            assertionFailure()
            exit(0)
        }
        return app
    }

    var window: UIWindow?

    open var splashWindow: UIWindow?

    // MARK: - AppDelegate functions

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        AppBootstrap.boost()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        //self.splashWindow.open()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        //self.splashWindow.close()
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
