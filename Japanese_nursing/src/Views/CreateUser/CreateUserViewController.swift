//
//  CreateUserViewController.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/28.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PKHUD
import SCLAlertView

/**
 * ユーザ作成VC
 */
class CreateUserViewController: UIViewController {

    private lazy var viewModel: CreateUserViewModel = CreateUserViewModel()

    // MARK: - Outlets

    /// ニックネーム入力TextField
    @IBOutlet private weak var nameUnderLineTextField: UnderlineTextField!
    /// アラートLabel
    @IBOutlet private weak var nameAlertLabel: UILabel!
    /// スタートButton
    @IBOutlet weak var startButton: UIButton!

    // MARK: - Properties

    private var disposeBag = DisposeBag()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribe()
    }

    // MARK: - Functions

    private func subscribe() {
        /// ニックネーム入力TextField
        nameUnderLineTextField.rx.text.orEmpty.asDriver().drive(onNext: { [unowned self] _ in
            self.nameUnderLineTextField.setUnderline(R.color.apptop()!)
            self.validate()
        }).disposed(by: self.disposeBag)

        /// スタートButton
        startButton.rx.tap.subscribe(onNext: { [weak self] in
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
            startButton.backgroundColor = R.color.apptop()
            startButton.borderColor = UIColor.clear
            startButton.setTitleColor(UIColor.white, for: .normal)
            nameAlertLabel.text = ""
        } else {
            startButton.backgroundColor = UIColor.clear
            startButton.borderColor = R.color.lightGray()!
            startButton.setTitleColor(R.color.apptop(), for: .normal)
        }
    }

    private func fetch(isAnonymous: Bool = true, userName: String) {
        HUD.show(.progress)

        viewModel.fetch(isAnonymous: isAnonymous, userName: userName)
            .subscribe(
                onNext: { domain in
                    HUD.flash(.label("登録しました！"), delay: 1.0) { [weak self] _ in
                        self?.dismiss(animated: true)
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

extension CreateUserViewController {

    static func makeInstance() -> UIViewController {
        guard let vc = R.storyboard.createUserViewController.createUserViewController() else {
            assertionFailure("Can't make instance 'CreateUserViewController'.")
            return UIViewController()
        }
        return vc
    }

}
