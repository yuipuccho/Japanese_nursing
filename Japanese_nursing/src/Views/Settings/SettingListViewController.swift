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
class SettingListViewController: UIViewController {

    // MARK: - Outlets

    /// 閉じるボタン
//    @IBOutlet private weak var closeButton: UIBarButtonItem!

    /// ユーザ名の変更
    @IBOutlet private weak var userNameSettingButton: UIButton!
    /// 目標学習数の変更
    @IBOutlet private weak var studyTargetSettingButton: UIButton!
    /// 目標テスト数の変更
    @IBOutlet private weak var testTargetSettingButton: UIButton!
    /// 利用規約
    @IBOutlet private weak var termOfServiceButton: UIButton!
    /// プライバシーポリシー
    @IBOutlet private weak var privacyPolicyButton: UIButton!

    // MARK: - Properties

    private var disposeBag = DisposeBag()

    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        subscribe()
    }

    // MARK: - Functions
    private func subscribe() {
//        // 閉じるボタンタップ
//        closeButton.rx.tap.subscribe(onNext: { [weak self] in
//            self?.dismiss(animated: true)
//        }).disposed(by: disposeBag)

        // ユーザー名の変更タップ
        userNameSettingButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.dismiss(animated: true)
        }).disposed(by: disposeBag)

        // 目標学習数タップ
        studyTargetSettingButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.dismiss(animated: true)
        }).disposed(by: disposeBag)

        // 目標テストタップ
        testTargetSettingButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.dismiss(animated: true)
        }).disposed(by: disposeBag)

        // 利用規約タップ
        termOfServiceButton.rx.tap.subscribe(onNext: { [weak self] in
            let url = "https://yuipuccho.github.io/Japanese_nursing_terms_of_service/"
            let vc = WebViewController.makeInstance(url: url, titleText: "利用規約")
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)

        // プライバシーポリシータップ
        privacyPolicyButton.rx.tap.subscribe(onNext: { [weak self] in
            let url = "https://yuipuccho.github.io/Japanese_nursing_privacy_policy/"
            let vc = WebViewController.makeInstance(url: url, titleText: "プライバシーポリシー")
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
    }

//        // tableViewCellタップイベント
//        tableView.rx.itemSelected.subscribe(onNext: { [unowned self] indexPath in
//            guard let cell = self.tableView.cellForRow(at: indexPath) else { return }
//
//            switch cell {
//            // ユーザ名の変更
//            case self.userNameSettingCell:
//                break
//
//            // 目標学習数の変更
//            case self.studyTargetSettingCell:
////                let vc = TargetSettingViewController.makeInstance(targetType: .study)
////                navigationController?.pushViewController(vc, animated: true)
//                break
//
//            // 目標テスト数の変更
//            case self.testTargetSettingCell:
//                break
//
////            // お問い合わせ
////            case self.questionAndAnswerCell:
////                break
//
//            // 利用規約
//            case self.termOfServiceCell:
//                let url = "https://yuipuccho.github.io/Japanese_nursing_terms_of_service/"
//                let vc = WebViewController.makeInstance(url: url, titleText: "利用規約")
//                navigationController?.pushViewController(vc, animated: true)
//
//            // プライバシーポリシー
//            case self.privacyPolicyCell:
//                let url = "https://yuipuccho.github.io/Japanese_nursing_privacy_policy/"
//                let vc = WebViewController.makeInstance(url: url, titleText: "プライバシーポリシー")
//                navigationController?.pushViewController(vc, animated: true)
//
//            default:
//                break
//            }
//            self.tableView.deselectRow(at: indexPath, animated: true)
//
//        }).disposed(by: disposeBag)
//    }

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
