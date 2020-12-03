//
//  TestSettingsViewController.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/05.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import UIKit
import Charts
import RxSwift
import RxCocoa
import PKHUD

/**
 * テスト設定画面VC
 */
class TestSettingsViewController: UIViewController {

    private lazy var viewModel: TestSettingsViewModel = TestSettingsViewModel()

    // MARK: - Outlets

    /// 円形進捗バーのView
    @IBOutlet private weak var chartView: PieChartView!
    /// パーセンテージLabel
    @IBOutlet private weak var percentageLabel: UILabel!
    /// すべてButton
    @IBOutlet private weak var allButton: UIButton!
    /// すべてView
    @IBOutlet private weak var allView: UIView!
    /// すべてLabel
    @IBOutlet private weak var allLabel: UILabel!
    /// すべての数Label
    @IBOutlet private weak var allCountLabel: UILabel!
    /// 苦手Button
    @IBOutlet private weak var mistakeButton: UIButton!
    /// 苦手View
    @IBOutlet private weak var mistakeView: UIView!
    /// 苦手Label
    @IBOutlet private weak var mistakeLabel: UILabel!
    /// 苦手の数Label
    @IBOutlet private weak var mistakeCountLabel: UILabel!
    /// 未出題Button
    @IBOutlet private weak var untestedButton: UIButton!
    /// 未出題View
    @IBOutlet private weak var untestedView: UIView!
    /// 未出題Label
    @IBOutlet private weak var untestedLabel: UILabel!
    /// 未出題の数Label
    @IBOutlet private weak var untestedCountLabel: UILabel!
    /// 出題数Label
    @IBOutlet private weak var questionsCountLabel: UILabel!
    /// プラスButton
    @IBOutlet private weak var plusButton: UIButton!
    /// マイナスButton
    @IBOutlet private weak var minusButton: UIButton!
    /// スタートButton
    @IBOutlet private weak var startButton: UIButton!

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

    /// 出題範囲タイプ
    enum QuestionRangeType: Int {
        case all
        case mistake
        case untested
    }

    /// 選択中の出題範囲
    private var selectingQuestionRange: [QuestionRangeType] = [.all]

    /// 選択中の出題範囲
    private var selectingQuestionsCount: Int = 10

    /// すべての単語数
    private var allCount = 0
    /// 苦手の単語数
    private var mistakeCount = 0
    /// 未出題の単語数
    private var untestedCount = 0
    /// 正解数
    private var perfectCount = 0

    private var disposeBag = DisposeBag()

    private lazy var emptyView: EmptyView = {
        let v = R.nib.emptyView.firstView(owner: nil)!
        v.backgroundColor = R.color.test()
        v.retryAction = { [weak self] in
            self?.fetch(animate: true)
        }
        v.page = .tab
        v.status = .none
        view.addSubview(v)
        view.allSafePin(subView: v, top: 45)
        return v
    }()

    /// ステータスを取得済か
    private var isGettedStatus: Bool = false

    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: true)

        subscribe()
        fetch(animate: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 更新されていないテスト履歴がある場合は更新する
        if !ApplicationConfigData.correctIdsArray.isEmpty || !ApplicationConfigData.mistakeIdsArray.isEmpty {
            postTestHistories()
        }

        chartAnimation()
    }

}

// MARK: - Functions

extension TestSettingsViewController {

    private func setupUI() {
        // 出題可能数を表示
        allCountLabel.text = "(" + String(allCount) + ")"
        mistakeCountLabel.text = "(" + String(mistakeCount) + ")"
        untestedCountLabel.text = "(" + String(untestedCount) + ")"

        // 未出題の数が0の場合は、未出題のボタンを非表示にする
        if untestedCount == 0 {
            untestedView.isHidden = true
        }

    }

    private func subscribe() {
        // すべてボタンタップ
        allButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.lightFeedBack.impactOccurred()
            self?.updateSelectingQuestionRange(tappedType: .all)
        }).disposed(by: disposeBag)

        // 苦手ボタンタップ
        mistakeButton.rx.tap.subscribe(onNext: { [weak self] in
            // 苦手数が0の場合はアラートを表示してreturn
            if self?.mistakeCount == 0 {
                self?.notificationFeedBack.notificationOccurred(.error)
                HUD.flash(.label("苦手な単語はありません"), delay: 0.5)
                return
            }
            self?.lightFeedBack.impactOccurred()
            self?.updateSelectingQuestionRange(tappedType: .mistake)
        }).disposed(by: disposeBag)

        // 未出題ボタンタップ
        untestedButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.lightFeedBack.impactOccurred()
            self?.updateSelectingQuestionRange(tappedType: .untested)
        }).disposed(by: disposeBag)

        // プラスボタンタップ
        plusButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.lightFeedBack.impactOccurred()
            self?.updateQuestionsCount(shouldPlus: true)
        }).disposed(by: disposeBag)

        // マイナスボタンタップ
        minusButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.lightFeedBack.impactOccurred()
            self?.updateQuestionsCount(shouldPlus: false)
        }).disposed(by: disposeBag)

        // スタートボタンタップ
        startButton.rx.tap.subscribe(onNext: { [unowned self] in
            lightFeedBack.impactOccurred()
            let vc = TestViewController.makeInstance(questionRange: selectingQuestionRange, limit: selectingQuestionsCount)
            present(vc, animated: true)
        }).disposed(by: disposeBag)

        // loading
        viewModel.loadingDriver
            .map { [unowned self] isLoading in
                if isGettedStatus {
                    return .none
                } else {
                    return .loading
                }
            }
            .drive(onNext: {[weak self] in
                self?.emptyView.status = $0
            }).disposed(by: disposeBag)

    }

    private func fetch(animate: Bool) {
        viewModel.fetch(authToken: ApplicationConfigData.authToken)
            .subscribe(
                onNext: { [unowned self] status in
                    isGettedStatus = true
                    
                    allCount = status.allWordCount
                    mistakeCount = status.mistakeWordCount
                    untestedCount = status.unquestionedWordCount
                    perfectCount = status.correctWordCount
                    setupUI()
                    setupChartView()
                    if animate {
                        chartAnimation()
                    }
                },
                onError: { [unowned self] in
                    log.error($0.descriptionOfType)
                    self.emptyView.status = .errorAndRetry($0.descriptionOfType)
                }).disposed(by: disposeBag)
    }

    /// テスト履歴を更新
    private func postTestHistories() {

        viewModel.postTestHistories()
            .subscribe(
                onNext: { [unowned self] _ in
                    // テスト履歴の更新に成功した場合、UserDefaultsを初期化する
                    ApplicationConfigData.correctIdsArray = []
                    ApplicationConfigData.mistakeIdsArray = []

                    // テスト状況を更新
                    fetch(animate: false)
                }
            ).disposed(by: disposeBag)
    }

    /// 出題範囲ボタンがタップされたときの処理
    private func updateSelectingQuestionRange(tappedType: QuestionRangeType) {
        switch tappedType {
        case .all:
            // 選択中の出題範囲を全てリセットしてから、.allを追加する
            selectingQuestionRange.removeAll()
            selectingQuestionRange.append(.all)

            // すべてを活性化
            updateActivateButton(type: .all, shouldActivate: true)
            // すべて以外を非活性化
            updateActivateButton(type: .mistake, shouldActivate: false)
            updateActivateButton(type: .untested, shouldActivate: false)

        // TODO: API対応しだい変更
        case .mistake:
            // 選択中の出題範囲を全てリセットしてから、.mistakeを追加する
            selectingQuestionRange.removeAll()
            selectingQuestionRange.append(.mistake)

            // 苦手を活性化
            updateActivateButton(type: .mistake, shouldActivate: true)
            // 苦手以外を非活性化
            updateActivateButton(type: .all, shouldActivate: false)
            updateActivateButton(type: .untested, shouldActivate: false)

        case .untested:
            // 選択中の出題範囲を全てリセットしてから、.untestedを追加する
            selectingQuestionRange.removeAll()
            selectingQuestionRange.append(.untested)

            // 未出題を活性化
            updateActivateButton(type: .untested, shouldActivate: true)
            // 未出題以外を非活性化
            updateActivateButton(type: .all, shouldActivate: false)
            updateActivateButton(type: .mistake, shouldActivate: false)

            // TODO: - いったんコメントアウト
//        case .mistake, .untested:
//
//            if !selectingQuestionRange.contains(tappedType) {
//                // タップされた項目を活性化する場合
//                // 選択中の出題範囲から.allを削除し、タップされた項目を追加する
//                selectingQuestionRange.remove(value: .all)
//                selectingQuestionRange.append(tappedType)
//
//                // すべてを非活性化
//                updateActivateButton(type: .all, shouldActivate: false)
//                // タップされた項目を活性化
//                updateActivateButton(type: tappedType, shouldActivate: true)
//
//            } else {
//                // タップされた項目を非活性にする場合
//                // タップされた項目を選択中の出題範囲から削除する
//                selectingQuestionRange.remove(value: tappedType)
//                // タップされた項目を非活性化
//                updateActivateButton(type: tappedType, shouldActivate: false)
//
//                // 選択中の出題範囲が1つもなくなった場合は、すべてを活性化する
//                if selectingQuestionRange.count <= 0 {
//                    updateSelectingQuestionRange(tappedType: .all)
//                }
//            }
        }
        // 最大出題範囲数が、設定中の出題数を下回る場合は、出題数ラベルを更新する
        let maxQuestionsCount = calculateMaxQuestionsCount()
        if maxQuestionsCount <= selectingQuestionsCount {
            selectingQuestionsCount = maxQuestionsCount
            questionsCountLabel.text = String(selectingQuestionsCount)
        }
    }

    /// 出題範囲ボタンの活性 / 非活性を更新する
    private func updateActivateButton(type: QuestionRangeType, shouldActivate: Bool) {
        var view = allView
        var label = allLabel
        var countLabel = allCountLabel

        switch type {
        case .all:
            view = allView
            label = allLabel
            countLabel = allCountLabel
        case .mistake:
            view = mistakeView
            label = mistakeLabel
            countLabel = mistakeCountLabel
        case .untested:
            view = untestedView
            label = untestedLabel
            countLabel = untestedCountLabel
        }

        if shouldActivate {
            view?.backgroundColor = UIColor.white
            label?.textColor = R.color.test()
            countLabel?.textColor = R.color.test()
        } else {
            view?.backgroundColor = R.color.test()
            label?.textColor = UIColor.white
            countLabel?.textColor = UIColor.white
        }
    }

    /**
     * 出題数を更新する
     * - Note: プラスがタップされた場合、一番近い10の倍数まで増やす(33→40, 50→60),
     *  マイナスがタップされた場合、一番近い10の倍数まで減らす(33→30, 50→40)
     */
    private func updateQuestionsCount(shouldPlus: Bool) {
        if shouldPlus {
            // 最大出題数を求める
            let maxQuestionsCount = calculateMaxQuestionsCount()
            // 端数を切り捨てる
            let count = Int(floor(Double(selectingQuestionsCount / 10))) * 10

            if (count + 10) <= maxQuestionsCount {
                selectingQuestionsCount = count + 10
                questionsCountLabel.text = String(selectingQuestionsCount)
            } else {
                selectingQuestionsCount = maxQuestionsCount
                questionsCountLabel.text = String(selectingQuestionsCount)
            }

        } else {
            // 端数がある場合は、切り捨ててから+10する
            var count = 0
            if selectingQuestionsCount % 10 != 0 {
                count = Int(ceil(Double(selectingQuestionsCount / 10))) * 10 + 10
            } else {
                count = selectingQuestionsCount
            }

            if (count - 10) >= 10 {
                selectingQuestionsCount = count - 10
                questionsCountLabel.text = String(selectingQuestionsCount)
            } else {
                // 何もしない
                return
            }
        }
    }

    /// 最大出題数を求める
    private func calculateMaxQuestionsCount() -> Int {
        var maxQuestionsCount = 0
        for i in selectingQuestionRange {
            switch i {
            case .all:
                maxQuestionsCount += allCount
            case .mistake:
                maxQuestionsCount += mistakeCount
            case .untested:
                maxQuestionsCount += untestedCount
            }
        }
        return maxQuestionsCount
    }

}

extension TestSettingsViewController {

    /// 円形進捗バーの表示設定
    private func setupChartView() {

        // グラフに表示するデータ
        let dataEntries = [
            PieChartDataEntry(value: Double(perfectCount * 100 / allCount)),
            PieChartDataEntry(value: Double(mistakeCount * 100 / allCount)),
            PieChartDataEntry(value: Double(untestedCount * 100 / allCount))
        ]

        // データをセットする
        let dataSet = PieChartDataSet(entries: dataEntries)
        dataSet.setColors(UIColor.white, R.color.untested()!, R.color.testWeakDark()!)  // グラフの色
        dataSet.drawValuesEnabled = false  // グラフ上のデータ値を非表示にする
        self.chartView.data = PieChartData(dataSet: dataSet)

        chartView.holeRadiusPercent = 0.85  // 中心の穴の大きさ
        chartView.holeColor = UIColor.clear  // 中心の穴の色

        chartView.highlightPerTapEnabled = false  // グラフがタップされたときのハイライトを無効化
        chartView.chartDescription?.enabled = false  // グラフの説明を非表示
        chartView.drawEntryLabelsEnabled = false  // グラフ上のデータラベルを非表示
        chartView.legend.enabled = false  // グラフの注釈を非表示
        chartView.rotationEnabled = false // グラフが動くのを無効化

        view.addSubview(self.chartView)

        if allCount == 0 {
            // 念の為
            percentageLabel.text = "0%"
        } else {
            percentageLabel.text = String(perfectCount * 100 / allCount) + "%"
        }
    }

    private func chartAnimation() {
        chartView.animate(xAxisDuration: 1.2, yAxisDuration: 0.8) // アニメーション

        /// 進捗ラベルの表示にもアニメーションをつける
        percentageLabel.alpha = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            UIView.animate(withDuration: 0.6) { [weak self] in
                self?.percentageLabel.alpha = 1
            }
        }
    }

}
