//
//  MyPageViewController.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/09.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import UIKit
import Charts

class MyPageViewController: UIViewController {

    // MARK: - Outlets

    /// 棒グラフ
    @IBOutlet weak var barChartView: BarChartView!
    /// 学習円形進捗バー
    @IBOutlet weak var studyPieChartView: PieChartView!
    /// テスト円形進捗バー
    @IBOutlet weak var testPieChartView: PieChartView!
    @IBOutlet weak var studyImageView: UIImageView!
    @IBOutlet weak var testImageView: UIImageView!
    @IBOutlet weak var studyCurrentCountLabel: UILabel!
    @IBOutlet weak var testCurrentCountLabel: UILabel!

    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBarChartView()
        barChartView.animate(yAxisDuration: 0.5)

        setupPieChartView(pieChartView: studyPieChartView)
        setupPieChartView(pieChartView: testPieChartView)

        view.bringSubviewToFront(studyImageView)
        view.bringSubviewToFront(testImageView)
        view.bringSubviewToFront(studyCurrentCountLabel)
        view.bringSubviewToFront(testCurrentCountLabel)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        barChartView.animate(yAxisDuration: 0.5)
    }

}

// MARK: - Functions

extension MyPageViewController {

    private func setupBarChartView() {
        let rawData: [Int] = [20, 50, 70, 30, 60, 90, 40]
        let entries = rawData.enumerated().map { BarChartDataEntry(x: Double($0.offset), y: Double($0.element)) }
        let dataSet = BarChartDataSet(entries: entries)
        let data = BarChartData(dataSet: dataSet)
        barChartView.data = data

        // X軸のラベルの位置を下に設定
        barChartView.xAxis.labelPosition = .bottom
        // X軸のラベルの色を設定
        barChartView.xAxis.labelTextColor = R.color.weakTextBlue()!
        // X軸の線、グリッドを非表示にする
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.drawAxisLineEnabled = false

        // 右側のY座標軸は非表示にする
        barChartView.rightAxis.enabled = false

        // Y座標の値が0始まりになるように設定
        barChartView.leftAxis.axisMinimum = 0.0
        barChartView.leftAxis.drawZeroLineEnabled = true
        barChartView.leftAxis.zeroLineColor = R.color.weakTextBlue()
        // ラベルの数を設定
        barChartView.leftAxis.labelCount = 5
        // ラベルの色を設定
        barChartView.leftAxis.labelTextColor = R.color.weakTextBlue()!
        // グリッドの色を設定
        barChartView.leftAxis.gridColor = R.color.weakTextBlue()!
        // 軸線は非表示にする
        barChartView.leftAxis.drawAxisLineEnabled = false

        barChartView.legend.enabled = false
        barChartView.doubleTapToZoomEnabled = false
        barChartView.dragEnabled = false
        barChartView.pinchZoomEnabled = false
        barChartView.highlightPerTapEnabled = false    // グラフがタップされたときのハイライトを無効化

        // グラフの上に値を表示しない
        dataSet.drawValuesEnabled = false
        dataSet.colors = [R.color.mainBlue()!]
    }

    /// 円形進捗バーの表示設定
    private func setupPieChartView(pieChartView: PieChartView) {
        // グラフに表示するデータ(仮)
        let dataEntries = [
            PieChartDataEntry(value: Double(20)),
            PieChartDataEntry(value: Double(80))
        ]

        // データをセットする
        let dataSet = PieChartDataSet(entries: dataEntries)
        dataSet.setColors(R.color.mainBlue()!, R.color.untested()!)  // グラフの色
        dataSet.drawValuesEnabled = false  // グラフ上のデータ値を非表示にする
        pieChartView.data = PieChartData(dataSet: dataSet)

        pieChartView.holeRadiusPercent = 0.88  // 中心の穴の大きさ
        pieChartView.holeColor = UIColor.white  // 中心の穴の色

        pieChartView.highlightPerTapEnabled = false  // グラフがタップされたときのハイライトを無効化
        pieChartView.chartDescription?.enabled = false  // グラフの説明を非表示
        pieChartView.drawEntryLabelsEnabled = false  // グラフ上のデータラベルを非表示
        pieChartView.legend.enabled = false  // グラフの注釈を非表示
        pieChartView.rotationEnabled = false // グラフが動くのを無効化

        view.addSubview(pieChartView)
        pieChartView.animate(xAxisDuration: 1.2, yAxisDuration: 0.8) // アニメーション

        /// 進捗ラベルの表示にもアニメーションをつける
//        percentageLabel.alpha = 0
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            UIView.animate(withDuration: 0.6) { [weak self] in
//                self?.percentageLabel.alpha = 1
//            }
//        }

    }

}
