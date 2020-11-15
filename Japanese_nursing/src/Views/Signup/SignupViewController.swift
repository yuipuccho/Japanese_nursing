//
//  SignupViewController.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/15.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SignupViewController: UIViewController {

    // MARK: - Outlets

    /// ユーザ名入力TextField
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
        /// ユーザ名入力TextField
        nameUnderLineTextField.rx.text.orEmpty.asDriver().drive(onNext: { [unowned self] _ in
            self.nameUnderLineTextField.setUnderline(R.color.weakTextBlue()!)
            self.validate()
        }).disposed(by: self.disposeBag)

        /// スタートButton
        startButton.rx.tap.subscribe(onNext: { [weak self] in
            if let text = self?.nameUnderLineTextField.text, !text.isEmpty, text.count <= 12 {

                // TODO: 遷移処理を追加
            } else if let text = self?.nameUnderLineTextField.text, text.isEmpty {
                self?.nameAlertLabel.text = "ユーザー名を入力してください"
            } else {
                self?.nameAlertLabel.text = "12文字以内で入力してください"
            }

        }).disposed(by: disposeBag)
    }

    private func validate() {
        if let text = nameUnderLineTextField.text, !text.isEmpty, text.count <= 12 {
            startButton.backgroundColor = R.color.mainBlue()
            nameAlertLabel.text = ""
        } else {
            startButton.backgroundColor = R.color.weakText()
        }
    }

}

// MARK: - MakeInstance

extension SignupViewController {

    static func makeInstance() -> UIViewController {
        guard let vc = R.storyboard.signupViewController.signupViewController() else {
            assertionFailure("Can't make instance 'SignupViewController'.")
            return UIViewController()
        }
        return vc
    }

}
