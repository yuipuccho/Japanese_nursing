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

/**
 * テスト設定画面VC
 */
class TestSettingsViewController: UIViewController {

    // MARK: - Outlets

    /// 円形進捗バーのView
    @IBOutlet private weak var chartView: PieChartView!
    /// パーセンテージLabel
    @IBOutlet private weak var percentageLabel: UILabel!
    /// すべてButton
    @IBOutlet private weak var allButton: UIButton!
    /// すべてView
    @IBOutlet weak var allView: UIView!
    /// すべてLabel
    @IBOutlet private weak var allLabel: UILabel!
    /// すべての数Label
    @IBOutlet private weak var allCountLabel: UILabel!
    /// 苦手Button
    @IBOutlet private weak var mistakeButton: UIButton!
    /// 苦手View
    @IBOutlet weak var mistakeView: UIView!
    /// 苦手Label
    @IBOutlet private weak var mistakeLabel: UILabel!
    /// 苦手の数Label
    @IBOutlet private weak var mistakeCountLabel: UILabel!
    /// 未出題Button
    @IBOutlet private weak var untestedButton: UIButton!
    /// 未出題View
    @IBOutlet weak var untestedView: UIView!
    /// 未出題Label
    @IBOutlet private weak var untestedLabel: UILabel!
    /// 未出題の数Label
    @IBOutlet private weak var untestedCountLabel: UILabel!
    /// プラスButton
    @IBOutlet private weak var plusButton: UIButton!
    /// マイナスButton
    @IBOutlet private weak var minusButton: UIButton!
    /// スタートButton
    @IBOutlet private weak var startButton: UIButton!

    // MARK: - Properties

    /// 出題範囲タイプ
    private enum QuestionRangeType {
        case all
        case mistake
        case untested
    }

    /// 選択中の出題範囲
    private var selectingQuestionRange: [QuestionRangeType] = []

    private var disposeBag = DisposeBag()

    // MARK: - LyfeCycles

    override func viewDidLoad() {
        super.viewDidLoad()

        setupChartView()
        subscribe()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupChartView()
    }

}

// MARK: - Functions

extension TestSettingsViewController {

    private func subscribe() {
        // すべてボタンタップ
        allButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.updateSelectingQuestionRange(tappedType: .all)
        }).disposed(by: disposeBag)

        // 苦手ボタンタップ
        mistakeButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.updateSelectingQuestionRange(tappedType: .mistake)
        }).disposed(by: disposeBag)

        // 未出題ボタンタップ
        untestedButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.updateSelectingQuestionRange(tappedType: .untested)
        }).disposed(by: disposeBag)

        // プラスボタンタップ

        // マイナスボタンタップ

        // スタートボタンタップ

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

        case .mistake, .untested:

            if !selectingQuestionRange.contains(tappedType) {
                // タップされた項目を活性化する場合
                // 選択中の出題範囲から.allを削除し、タップされた項目を追加する
                selectingQuestionRange.remove(value: .all)
                selectingQuestionRange.append(tappedType)

                // すべてを非活性化
                updateActivateButton(type: .all, shouldActivate: false)
                // タップされた項目を活性化
                updateActivateButton(type: tappedType, shouldActivate: true)

            } else {
                // タップされた項目を非活性にする場合
                // タップされた項目を選択中の出題範囲から削除する
                selectingQuestionRange.remove(value: tappedType)
                // タップされた項目を非活性化
                updateActivateButton(type: tappedType, shouldActivate: false)

                // 選択中の出題範囲が1つもなくなった場合は、すべてを活性化する
                if selectingQuestionRange.count <= 0 {
                    updateSelectingQuestionRange(tappedType: .all)
                }
            }
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
            view?.backgroundColor = R.color.mainBlue()
            label?.textColor = UIColor.white
            countLabel?.textColor = UIColor.white
        } else {
            view?.backgroundColor = UIColor.white
            label?.textColor = R.color.mainBlue()
            countLabel?.textColor = R.color.mainBlue()
        }
    }

    /// 円形進捗バーの表示設定
    private func setupChartView() {
        // グラフに表示するデータ(仮)
        let dataEntries = [
            PieChartDataEntry(value: 40),
            PieChartDataEntry(value: 30),
            PieChartDataEntry(value: 30)
        ]

        // データをセットする
        let dataSet = PieChartDataSet(entries: dataEntries)
        dataSet.setColors(R.color.mainBlue()!, R.color.mistake()!, R.color.untested()!)  // グラフの色
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

// 配列から値を指定して削除できるように拡張

extension Array where Element: Equatable {

    mutating func remove(value: Element) {
        if let i = self.firstIndex(of: value) {
            self.remove(at: i)
        }
    }

}
