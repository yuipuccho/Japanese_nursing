//
//  InProgressListViewController.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/07/30.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import UIKit

class InProgressListViewController: UITableViewController {

    var list = ["aaa", "bbb"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "StudyListView", bundle: nil), forCellReuseIdentifier: "customCell")
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! StudyListView
        return cell
    }

//    // MARK: - TableViewDataSource
//    /// DataSource のセットアップ
//    private func setupDataSource() {
//        //let dataSource =
//    }



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
