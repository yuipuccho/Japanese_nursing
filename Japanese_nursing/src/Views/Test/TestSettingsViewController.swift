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

    @IBOutlet private weak var chartView: PieChartView!


    override func viewDidLoad() {
        super.viewDidLoad()

        super.viewDidLoad()
        // 円グラフの中心に表示するタイトル
        //chartView.centerText = "テストデータ"

        // グラフに表示するデータのタイトルと値
        let dataEntries = [
            PieChartDataEntry(value: 40, label: "A"),
            PieChartDataEntry(value: 35, label: "B"),
            PieChartDataEntry(value: 25, label: "C")
        ]

        let dataSet = PieChartDataSet(entries: dataEntries)

        // 穴を大きく
        chartView.holeRadiusPercent = 0.85

        //穴を透明に
        chartView.holeColor = UIColor.clear

        // グラフの色
        dataSet.setColors(R.color.mainBlue()!, R.color.mistake()!, R.color.untested()!)
        // グラフのデータの値の色
        dataSet.valueTextColor = UIColor.black
        // グラフのデータのタイトルの色
        dataSet.entryLabelColor = UIColor.black

        self.chartView.data = PieChartData(dataSet: dataSet)
        // データを％表示にする
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        formatter.multiplier = 1.0
        self.chartView.data?.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        self.chartView.usePercentValuesEnabled = true

        view.addSubview(self.chartView)


        dataSet.drawValuesEnabled = false  // グラフ上のデータ値を非表示
        chartView.highlightPerTapEnabled = false  // グラフがタップされたときのハイライトをOFF（任意）
        chartView.chartDescription?.enabled = false  // グラフの説明を非表示
        chartView.drawEntryLabelsEnabled = false  // グラフ上のデータラベルを非表示
        chartView.legend.enabled = false  // グラフの注釈を非表示
        chartView.rotationEnabled = false // グラフがぐるぐる動くのを無効化

        //chartView.animate(yAxisDuration: 0.8)  // アニメーション
        chartView.animate(xAxisDuration: 1.4, yAxisDuration: 0.8)

    }
    

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

}
