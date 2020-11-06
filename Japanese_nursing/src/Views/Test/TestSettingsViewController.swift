//
//  TestSettingsViewController.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/05.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import UIKit
import Charts

/**
 * テスト設定画面VC
 */
class TestSettingsViewController: UIViewController {

    // MARK: - Outlets

    /// 円形進捗バーのView
    @IBOutlet private weak var chartView: PieChartView!
    /// パーセンテージLabel
    @IBOutlet private weak var percentageLabel: UILabel!
    

    // MARK: - Properties



    // MARK: - LyfeCycles

    override func viewDidLoad() {
        super.viewDidLoad()

        setupChartView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupChartView()
    }

    // MARK: - Functions

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
