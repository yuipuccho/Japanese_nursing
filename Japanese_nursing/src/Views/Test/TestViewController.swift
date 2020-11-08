//
//  TestViewController.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/08.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import UIKit

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

    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidLayoutSubviews() {
        setupInitialUI()
        updateQuestion()
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

    }

    /// 問題を更新する
    private func updateQuestion() {
        // TODO: 問題ラベルを更新する処理を追加

        // トップViewの色をMainBlueに変更
        topView.backgroundColor = R.color.mainBlue()

        // フィードバックを非表示
        feedbackView.isHidden = true
        firstOptionImageView.isHidden = true
        secondOptionImageView.isHidden = true
        thirdOptionImageView.isHidden = true
        fourthOptionImageView.isHidden = true
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
