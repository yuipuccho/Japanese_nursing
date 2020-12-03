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

    private lazy var viewModel: TestViewModel = TestViewModel()

    // MARK: - Outlets

    /// トップView
    @IBOutlet private weak var topImageView: UIImageView!
    /// 閉じるボタン
    @IBOutlet private weak var closeButton: UIButton!
    /// 進捗View
    @IBOutlet private weak var progressView: UIView!
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

    // 触感フィードバック
    private let lightFeedBack: UIImpactFeedbackGenerator = {
        let generator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        return generator
    }()

    private let notificationFeedBack: UINotificationFeedbackGenerator = {
        let generator: UINotificationFeedbackGenerator = UINotificationFeedbackGenerator()
        generator.prepare()
        return generator
    }()

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

    /// 正解のボタン
    private var correctButton: SelectionType = .first

    private var disposeBag = DisposeBag()

    private lazy var emptyView: EmptyView = {
        let v = R.nib.emptyView.firstView(owner: nil)!
        v.backgroundColor = R.color.test()
        v.retryAction = { [weak self] in
            self?.fetch()
        }
        v.page = .tab
        v.status = .none
        view.addSubview(v)
        view.allSafePin(subView: v, top: 45)
        return v
    }()

    /// 出題範囲
    private var questionRange: [TestSettingsViewController.QuestionRangeType] = [.all]
    /// 出題数
    private var limit: Int = 20

    /// 出題する単語のindex
    private var index: Int = 0

    /// 出題する単語の最大index
    private var maxIndex: Int = 0

    /// 正解した単語情報の配列
    private var correctArray: [TestWordsDomainModel] = []
    /// 間違えた単語情報の配列
    private var mistakeArray: [TestWordsDomainModel] = []

    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.isHidden = true  // EmptyView表示時に見えるため
        subscribe()
        fetch()
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
        firstOptionButton.rx.tap.subscribe(onNext: { [unowned self] in
            correctButton == .first ? correct(type: .first) : mistake(type: .first)
        }).disposed(by: disposeBag)

        // 2つ目の選択肢タップ
        secondOptionButton.rx.tap.subscribe(onNext: { [unowned self] in
            correctButton == .second ? correct(type: .second) : mistake(type: .second)
        }).disposed(by: disposeBag)

        // 3つ目の選択肢タップ
        thirdOptionButton.rx.tap.subscribe(onNext: { [unowned self] in
            correctButton == .third ? correct(type: .third) : mistake(type: .third)
        }).disposed(by: disposeBag)

        // 4つ目の選択肢タップ
        fourthOptionButton.rx.tap.subscribe(onNext: { [unowned self] in
            correctButton == .fourth ? correct(type: .fourth) : mistake(type: .fourth)
        }).disposed(by: disposeBag)

        // loading
        viewModel.loadingDriver
            .map { isLoading in
                if isLoading {
                    return .loading
                } else {
                    return .none
                }
            }
            .drive(onNext: {[weak self] in
                self?.emptyView.status = $0
            }).disposed(by: disposeBag)
    }

    private func fetch() {
        viewModel.fetch(questionRange: questionRange[0].rawValue, limit: limit)
            .subscribe(
                onNext: { [unowned self] _ in
                    maxIndex = viewModel.testWords.count - 1
                    progressView.isHidden = false
                    updateQuestion()
                },
                onError: { [unowned self] in
                    log.error($0.descriptionOfType)
                    self.emptyView.status = .errorAndRetry($0.descriptionOfType)
                }).disposed(by: disposeBag)
    }

    /// 問題を更新する
    private func updateQuestion() {
        // 問題ラベル
        questionLabel.text = viewModel.testWords[index].japanese

        // 選択肢の設定
        let correctOption = Int.random(in: 1...4)
        switch correctOption {
        case 1:
            firstOptionLabel.text = viewModel.testWords[index].vietnamese
            secondOptionLabel.text = viewModel.testWords[index].dummyVietnamese1
            thirdOptionLabel.text = viewModel.testWords[index].dummyVietnamese2
            fourthOptionLabel.text = viewModel.testWords[index].dummyVietnamese3
            correctButton = .first
        case 2:
            firstOptionLabel.text = viewModel.testWords[index].dummyVietnamese1
            secondOptionLabel.text = viewModel.testWords[index].vietnamese
            thirdOptionLabel.text = viewModel.testWords[index].dummyVietnamese2
            fourthOptionLabel.text = viewModel.testWords[index].dummyVietnamese3
            correctButton = .second
        case 3:
            firstOptionLabel.text = viewModel.testWords[index].dummyVietnamese1
            secondOptionLabel.text = viewModel.testWords[index].dummyVietnamese2
            thirdOptionLabel.text = viewModel.testWords[index].vietnamese
            fourthOptionLabel.text = viewModel.testWords[index].dummyVietnamese3
            correctButton = .third
        case 4:
            firstOptionLabel.text = viewModel.testWords[index].dummyVietnamese1
            secondOptionLabel.text = viewModel.testWords[index].dummyVietnamese2
            thirdOptionLabel.text = viewModel.testWords[index].dummyVietnamese3
            fourthOptionLabel.text = viewModel.testWords[index].vietnamese
            correctButton = .fourth
        default:
            break
        }

        // 進捗ラベル
        progressLabel.text = String( index + 1 ) + "/" + String( maxIndex + 1 )

        updateView()

    }

    private func updateView() {
        // トップViewの色を青に変更
        topImageView.image = R.image.round_blue()
        progressLabel.textColor = R.color.goodBlue()

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
    private func correct(type: SelectionType) {
        // UserDefaultsに追加する(テスト履歴更新用)
        ApplicationConfigData.correctIdsArray.append(String(viewModel.testWords[index].id))
        // 配列に追加する(テスト結果表示用)
        correctArray.append(viewModel.testWords[index])

        lightFeedBack.impactOccurred()
        bigFeedbackImageView.isHidden = false
        bigFeedbackImageView.image = R.image.big_circle()
        feedbackView.isHidden = false
        feedbackImageView.image = R.image.good_icon()
        feedbackLabel.text = "Good!"

        // 正解ボタンの表示
        updateOptionButton(type: type, status: .selectedCorrect)

        // ボタンタップを無効化する
        buttonTapSetting(isEnabled: false)

        // 0.5秒後に問題を更新し、ボタンタップを有効化する
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in

            if (index + 1) > maxIndex {
                updateView()
                // 次に表示する問題がない場合は、テスト結果画面に遷移する
                let vc = TestResultViewController.makeInstance(correctArray: correctArray, mistakeArray: mistakeArray)
                present(vc, animated: true)

            } else {
                index += 1
                buttonTapSetting(isEnabled: true)
                updateQuestion()
            }
        }
    }

    /// 不正解の処理
    private func mistake(type: SelectionType) {
        // UserDefaultsに追加する(テスト履歴更新用)
        ApplicationConfigData.mistakeIdsArray.append(String(viewModel.testWords[index].id))
        // 配列に追加する(テスト結果表示用)
        mistakeArray.append(viewModel.testWords[index])

        bigFeedbackImageView.isHidden = false
        bigFeedbackImageView.image = R.image.big_cross()
        topImageView.image = R.image.round_pink()
        progressLabel.textColor = R.color.badPink()

        // 不正解ボタンの表示
        updateOptionButton(type: type, status: .selectedMistake)
        // 解答ボタンの表示
        updateOptionButton(type: correctButton, status: .answer)

        // ボタンタップを無効化する
        buttonTapSetting(isEnabled: false)

        // 1.0秒後に問題を更新し、ボタンタップを有効化する
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [unowned self] in
            if (index + 1) > maxIndex {
                updateView()
                // 次に表示する問題がない場合は、テスト結果画面に遷移する
                let vc = TestResultViewController.makeInstance(correctArray: correctArray, mistakeArray: mistakeArray)
                present(vc, animated: true)
            } else {
                index += 1
                buttonTapSetting(isEnabled: true)
                updateQuestion()
            }
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
            view?.borderColor = R.color.lightGray()!
            label?.textColor = R.color.goodBlue()
            imageView?.isHidden = true
        case .selectedCorrect:
            view?.backgroundColor = R.color.goodBlue()
            view?.borderColor = UIColor.clear
            label?.textColor = UIColor.white
            imageView?.isHidden = true
        case .selectedMistake:
            view?.backgroundColor = R.color.weakText()
            view?.borderColor = UIColor.clear
            label?.textColor = UIColor.white
            imageView?.isHidden = false
            imageView?.image = R.image.batu_pink()
        case .answer:
            view?.backgroundColor = UIColor.white
            view?.borderColor = R.color.lightGray()!
            label?.textColor = R.color.goodBlue()
            imageView?.isHidden = false
            imageView?.image = R.image.circle_blue()
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

    static func makeInstance(questionRange: [TestSettingsViewController.QuestionRangeType], limit: Int) -> UIViewController {
        guard let vc = R.storyboard.testViewController.testViewController() else {
            assertionFailure("Can't make instance 'TestViewController'.")
            return UIViewController()
        }
        vc.questionRange = questionRange
        vc.limit = limit
        return vc
    }

}
