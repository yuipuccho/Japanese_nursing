//
//  SettingListViewController.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/13.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/**
 * 設定一覧VC
 */
class SettingListViewController: UITableViewController {

    // MARK: - Outlets

    /// 閉じるボタン
    @IBOutlet private weak var closeButton: UIBarButtonItem!

    /// ユーザ名の変更
    @IBOutlet private weak var userNameSettingCell: UITableViewCell!
    /// 目標学習数の変更
    @IBOutlet private weak var studyTargetSettingCell: UITableViewCell!
    /// 目標テスト数の変更
    @IBOutlet private weak var testTargetSettingCell: UITableViewCell!
    /// お問い合わせ
    @IBOutlet private weak var questionAndAnswerCell: UITableViewCell!
    /// 利用規約
    @IBOutlet private weak var termOfServiceCell: UITableViewCell!
    /// プライバシーポリシー
    @IBOutlet private weak var privacyPolicyCell: UITableViewCell!

    // MARK: - Properties

    private var disposeBag = DisposeBag()

    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()

        subscribe()
    }

    // MARK: - Functions
    private func subscribe() {
        // 閉じるボタンタップ
        closeButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.dismiss(animated: true)
        }).disposed(by: disposeBag)

        // tableViewCellタップイベント
        tableView.rx.itemSelected.subscribe(onNext: { [unowned self] indexPath in
            guard let cell = self.tableView.cellForRow(at: indexPath) else { return }

            switch cell {
            // ユーザ名の変更
            case self.userNameSettingCell:
                break

            // 目標学習数の変更
            case self.studyTargetSettingCell:
                let vc = TargetSettingViewController.makeInstance()
                present(vc, animated: true)

            // 目標テスト数の変更
            case self.testTargetSettingCell:
                break

            // お問い合わせ
            case self.questionAndAnswerCell:
                break

            // 利用規約
            case self.termOfServiceCell:
                break

            // プライバシーポリシー
            case self.privacyPolicyCell:
                break

            default:
                break
            }
            self.tableView.deselectRow(at: indexPath, animated: true)
        }).disposed(by: disposeBag)
    }

}

// MARK: - MakeInstance

extension SettingListViewController {

    static func makeInstance() -> UIViewController {
        guard let vc = R.storyboard.setteingListViewController.settingListViewController() else {
            assertionFailure("Can't make instance 'SettingListViewController'.")
            return UIViewController()
        }
        return vc
    }

    static func makeInstanceInNavigationController() -> UIViewController {
        return UINavigationController(rootViewController: makeInstance())
    }

}
