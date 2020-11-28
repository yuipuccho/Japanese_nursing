//
//  UnitListViewController.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/07/30.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import UIKit

/**
 * 単元一覧画面VC
 */
class UnitListViewController: UIViewController {

    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: true)

        // 仮
        let vc = CreateUserViewController.makeInstance()
        present(vc, animated: true)

    }

}

// MARK: - TableViewDataSource

extension UnitListViewController: UITableViewDataSource, UITableViewDelegate {

    // TODO: API取得次第変更

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.unitListCell.identifier, for: indexPath) as? UnitListCell else{
            return UITableViewCell()
        }

        cell.cellTappedSubject.subscribe(onNext: { [weak self] in
            let vc = LearningUnitViewController.makeInstance()
            self?.present(vc, animated: true)
        }).disposed(by: cell.disposeBag)

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }

}

// MARK: - MakeInstance

extension UnitListViewController {

    static func makeInstance() -> UIViewController {
        guard let vc = R.storyboard.unitList.unitListViewController() else {
            assertionFailure("Can't make instance 'UnitListViewController'.")
            return UIViewController()
        }
        return vc
    }

}
