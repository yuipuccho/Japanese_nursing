//
//  TestViewController.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/08.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

/**
 * テスト画面VC
 */
class TestViewController: UIViewController {

    // MARK: - Outlets

    /// トップView
    @IBOutlet private weak var topView: UIView!
    /// 閉じるボタン
    @IBOutlet private weak var closeButton: UIButton!
    /// 進捗ラベル
    @IBOutlet private weak var progressLabel: UILabel!
    /// 問題ラベル
    @IBOutlet private weak var questionLabel: UILabel!
    /// 中央の大きなフィードバックImageView
    @IBOutlet private weak var bigFeedbackImageView: UIImageView!
    /// フィードバックView
    @IBOutlet private weak var feedbackView: UIView!
    /// フィードバックImageView
    @IBOutlet private weak var feedbackImageView: UIImageView!
    /// フィードバックラベル
    @IBOutlet private weak var feedbackLabel: UILabel!

    @IBOutlet private weak var firstOptionView: UIView!
    @IBOutlet private weak var firstOptionButton: UIButton!
    @IBOutlet private weak var firstOptionImageView: UIImageView!
    @IBOutlet private weak var firstOptionLabel: UILabel!

    @IBOutlet private weak var secondOptionView: UIView!
    @IBOutlet private weak var secondOptionButton: UIButton!
    @IBOutlet private weak var secondOptionImageView: UIImageView!
    @IBOutlet private weak var secondOptionLabel: UILabel!

    @IBOutlet private weak var thirdOptionView: UIView!
    @IBOutlet private weak var thirdOptionButton: UIButton!
    @IBOutlet private weak var thirdOptionImageView: UIImageView!
    @IBOutlet private weak var thirdOptionLabel: UILabel!

    @IBOutlet private weak var fourthOptionView: UIView!
    @IBOutlet private weak var fourthOptionButton: UIButton!
    @IBOutlet private weak var fourthOptionImageView: UIImageView!
    @IBOutlet private weak var fourthOptionLabel: UILabel!

    // MARK: - Properties

    /// 選択項目の管理用Enum
    private enum SelectionType {
        case first
        case second
        case third
        case fourth
    }

    /// ボタンステータスの管理用Enum
    private enum ButtonStatus {
        case notSelected // 選択されていない
        case selectedCorrect // 正解をタップした
        case selectedMistake // 不正解をタップした
        case answer // 解答
    }

    private var disposeBag = DisposeBag()

    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()

        subscribe()
        updateQuestion()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        setupInitialUI()
    }

}

// MARK: - Functions

extension TestViewController {

    /// 初期UIを設定する
    private func setupInitialUI() {
        // 選択肢ボタンに角丸をつける
        firstOptionButton.layoutIfNeeded()
        firstOptionView.layer.cornerRadius = firstOptionButton.frame.size.height / 2
        secondOptionButton.layoutIfNeeded()
        secondOptionView.layer.cornerRadius = secondOptionButton.frame.size.height / 2
        thirdOptionButton.layoutIfNeeded()
        thirdOptionView.layer.cornerRadius = thirdOptionButton.frame.size.height / 2
        fourthOptionButton.layoutIfNeeded()
        fourthOptionView.layer.cornerRadius = fourthOptionButton.frame.size.height / 2
    }

    private func subscribe() {
        // 閉じるボタンタップ
        closeButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.dismiss(animated: true)
        }).disposed(by: disposeBag)

        // 1つ目の選択肢タップ
        firstOptionButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.correct() //仮
        }).disposed(by: disposeBag)

        // 2つ目の選択肢タップ
        secondOptionButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.mistake() // 仮
        }).disposed(by: disposeBag)
    }

    /// 問題を更新する
    private func updateQuestion() {
        // TODO: 問題ラベル、選択肢ラベルのテキストを更新する処理を追加

        // トップViewの色をMainBlueに変更
        topView.backgroundColor = R.color.mainBlue()
        progressLabel.textColor = R.color.mainBlue()

        // フィードバックを非表示
        bigFeedbackImageView.isHidden = true
        feedbackView.isHidden = true
        firstOptionImageView.isHidden = true
        secondOptionImageView.isHidden = true
        thirdOptionImageView.isHidden = true
        fourthOptionImageView.isHidden = true

        // ボタンの色を初期化
        updateOptionButton(type: .first, status: .notSelected)
        updateOptionButton(type: .second, status: .notSelected)
        updateOptionButton(type: .third, status: .notSelected)
        updateOptionButton(type: .fourth, status: .notSelected)
    }

    /// 正解の処理
    private func correct() {
        bigFeedbackImageView.isHidden = false
        bigFeedbackImageView.image = R.image.big_circle()
        feedbackView.isHidden = false
        feedbackImageView.image = R.image.good_icon()
        feedbackLabel.text = "Good!"

        // 仮
        // 正解ボタンの表示
        updateOptionButton(type: .first, status: .selectedCorrect)

        // ボタンタップを無効化する
        buttonTapSetting(isEnabled: false)

        // 0.8秒後に問題を更新し、ボタンタップを有効化する
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            self?.buttonTapSetting(isEnabled: true)
            self?.updateQuestion()
        }
    }

    /// 不正解の処理
    private func mistake() {
        bigFeedbackImageView.isHidden = false
        bigFeedbackImageView.image = R.image.big_cross()
        feedbackView.isHidden = false
        feedbackImageView.image = R.image.bad_icon()
        feedbackLabel.text = "Bad..."
        topView.backgroundColor = R.color.mistakePink()
        progressLabel.textColor = R.color.mistakePink()

        // 仮
        // 不正解ボタンの表示
        updateOptionButton(type: .second, status: .selectedMistake)
        // 解答ボタンの表示
        updateOptionButton(type: .first, status: .answer)

        // ボタンタップを無効化する
        buttonTapSetting(isEnabled: false)

        // 1.5秒後に問題を更新し、ボタンタップを有効化する
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.buttonTapSetting(isEnabled: true)
            self?.updateQuestion()
        }
    }

    /// 選択肢ボタンの更新
    private func updateOptionButton(type: SelectionType, status: ButtonStatus) {
        var view = firstOptionView
        var label = firstOptionLabel
        var imageView = firstOptionImageView

        switch type {
        case .first:
            view = firstOptionView
            label = firstOptionLabel
            imageView = firstOptionImageView
        case .second:
            view = secondOptionView
            label = secondOptionLabel
            imageView = secondOptionImageView
        case .third:
            view = thirdOptionView
            label = thirdOptionLabel
            imageView = thirdOptionImageView
        case .fourth:
            view = fourthOptionView
            label = fourthOptionLabel
            imageView = fourthOptionImageView
        }

        switch status {
        case .notSelected:
            view?.backgroundColor = UIColor.white
            label?.textColor = R.color.mainBlue()
            imageView?.isHidden = true
        case .selectedCorrect:
            view?.backgroundColor = R.color.mainBlue()
            label?.textColor = UIColor.white
            imageView?.isHidden = true
        case .selectedMistake:
            view?.backgroundColor = R.color.mistakeGrey()
            label?.textColor = UIColor.white
            imageView?.isHidden = false
            imageView?.image = R.image.mistake_cross()
        case .answer:
            view?.backgroundColor = UIColor.white
            label?.textColor = R.color.mainBlue()
            imageView?.isHidden = false
            imageView?.image = R.image.correct_circle()
        }
    }

    /// ボタンタップの有効 / 無効を切り替える
    private func buttonTapSetting(isEnabled: Bool) {
        firstOptionButton.isEnabled = isEnabled
        secondOptionButton.isEnabled = isEnabled
        thirdOptionButton.isEnabled = isEnabled
        fourthOptionButton.isEnabled = isEnabled
    }

}

// MARK: - MakeInstance

extension TestViewController {

    static func makeInstance() -> UIViewController {
        guard let vc = R.storyboard.testViewController.testViewController() else {
            assertionFailure("Can't make instance 'TestViewController'.")
            return UIViewController()
        }
        return vc
    }

}
