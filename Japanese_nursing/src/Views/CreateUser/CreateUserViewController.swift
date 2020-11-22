//
//  CreateUserViewController.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/15.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PKHUD
import SCLAlertView

class CreateUserViewController: UIViewController {

    private lazy var viewModel: CreateUserViewModel = CreateUserViewModel()

    // MARK: - Outlets

    /// ユーザ名入力TextField
    @IBOutlet private weak var nameUnderLineTextField: UnderlineTextField!
    /// アラートLabel
    @IBOutlet private weak var nameAlertLabel: UILabel!
    /// スタートButton
    @IBOutlet weak var startButton: UIButton!

    //@IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!

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
                HUD.show(.progress)
                // TODO: 遷移処理を追加
                self?.viewModel.fetch()
                    .subscribe(onNext: { _ in
                        print("popo")
                    })

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

extension CreateUserViewController {

    static func makeInstance() -> UIViewController {
        guard let vc = R.storyboard.createUserViewController.createUserViewController() else {
            assertionFailure("Can't make instance 'CreateUserViewController'.")
            return UIViewController()
        }
        return vc
    }

}
