//
//  UserNameSettingViewController.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/13.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import UIKit

import UIKit
import RxSwift
import RxCocoa
import PKHUD
import SCLAlertView


/**
 * ユーザ名変更VC
 */
class UserNameSettingViewController: UIViewController {

    private lazy var viewModel: CreateUserViewModel = CreateUserViewModel()

    // MARK: - Outlets

    /// ニックネーム入力TextField
    @IBOutlet private weak var nameUnderLineTextField: UnderlineTextField!
    /// アラートLabel
    @IBOutlet private weak var nameAlertLabel: UILabel!
    /// 変更Button
    @IBOutlet weak var changeButton: UIButton!

    // MARK: - Properties

    private var disposeBag = DisposeBag()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        nameUnderLineTextField.text = ApplicationConfigData.userName
        subscribe()
    }

    // MARK: - Functions

    private func subscribe() {
        /// ユーザ名入力TextField
        nameUnderLineTextField.rx.text.orEmpty.asDriver().drive(onNext: { [unowned self] _ in
            self.nameUnderLineTextField.setUnderline(R.color.apptop()!)
            self.validate()
        }).disposed(by: self.disposeBag)

        /// 変更Button
        changeButton.rx.tap.subscribe(onNext: { [weak self] in
            if let text = self?.nameUnderLineTextField.text, !text.isEmpty, text.count <= 12 {
                self?.fetch(userName: text)
            } else if let text = self?.nameUnderLineTextField.text, text.isEmpty {
                self?.nameAlertLabel.text = "ニックネームを入力してください"
            } else {
                self?.nameAlertLabel.text = "12文字以内で入力してください"
            }

        }).disposed(by: disposeBag)
    }

    /// バリデーション処理
    private func validate() {
        if let text = nameUnderLineTextField.text, !text.isEmpty, text.count <= 12 {
            changeButton.backgroundColor = R.color.settingGray()
            changeButton.borderColor = UIColor.clear
            changeButton.setTitleColor(UIColor.white, for: .normal)
            nameAlertLabel.text = ""
        } else {
            changeButton.backgroundColor = UIColor.clear
            changeButton.borderColor = R.color.lightGray()!
            changeButton.setTitleColor(R.color.settingGray(), for: .normal)
        }
    }

    private func fetch(isAnonymous: Bool = true, userName: String) {
        HUD.show(.progress)

        viewModel.fetch(isAnonymous: isAnonymous, userName: userName)
            .subscribe(
                onNext: { domain in
                    HUD.flash(.label("変更しました！"), delay: 1.0) { [weak self] _ in
                        if let nc = self?.navigationController {
                            nc.popViewController(animated: true)
                        } else {
                            self?.dismiss(animated: true)
                        }
                    }
                },

                onError: { [weak self] in

                    HUD.hide()

                    // エラーアラートを表示
                    let appearance = SCLAlertView.SCLAppearance(
                        kTitleFont: R.font.notoSansCJKjpSubBold(size: 16)!,
                        kTextFont: R.font.notoSansCJKjpSubMedium(size: 12)!
                    )
                    let alertView = SCLAlertView(appearance: appearance)
                    alertView.addButton("リトライ") { [weak self] in
                        self?.fetch(isAnonymous: isAnonymous, userName: userName)
                    }

                    alertView.showTitle("Error",
                                        subTitle: $0.descriptionOfType,
                                        timeout: nil,
                                        completeText: "閉じる",
                                        style: .error,
                                        colorStyle: 0x8EB2F5,
                                        colorTextButton: nil,
                                        circleIconImage: nil,
                                        animationStyle: .bottomToTop)
                }
            ).disposed(by: disposeBag)
    }

}

// MARK: - MakeInstance

extension UserNameSettingViewController {

    static func makeInstance() -> UIViewController {
        guard let vc = R.storyboard.userNameSettingViewController.userNameSettingViewController() else {
            assertionFailure("Can't make instance 'UserNameSettingViewController'.")
            return UIViewController()
        }
        return vc
    }

    static func makeInstanceInNavigationController() -> UIViewController {
        return UINavigationController(rootViewController: makeInstance())
    }

}
