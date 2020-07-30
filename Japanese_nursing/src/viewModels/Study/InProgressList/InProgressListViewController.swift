//
//  InProgressListViewController.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/07/30.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import UIKit

class InProgressListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - makeInstance

extension InProgressListViewController {

    static func makeInstance() -> UIViewController {
        guard let vc = R.storyboard.inProgressList.instantiateInitialViewController() else {
            assertionFailure("Can't make instance 'ImProgressListViewController'.")
            return UIViewController()
        }
        return vc
    }

}
