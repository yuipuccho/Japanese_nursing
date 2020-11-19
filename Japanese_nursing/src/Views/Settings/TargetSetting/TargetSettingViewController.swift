//
//  StudyTargetSettingViewController.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/19.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import UIKit
import Charts
import RxCocoa
import RxSwift

/**
 * 目標の設定画面VC
 */
class TargetSettingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - Outlets

    /// 円形進捗バー
    @IBOutlet private weak var pieChartView: PieChartView!
    /// 目標タイプアイコン
    @IBOutlet private weak var targetIconImageView: UIImageView!
    /// 目標タイプラベル
    @IBOutlet private weak var targetTypeLabel: UILabel!
    /// 目標数ラベル
    @IBOutlet private weak var targetNumberLabel: UILabel!
    /// 目標数ピッカー
    @IBOutlet private weak var pickerView: UIPickerView!
    /// キャンセルボタン
    @IBOutlet private weak var cancelButton: UIButton!
    /// 保存ボタン
    @IBOutlet private weak var saveButton: UIButton!

    // MARK: - Properties

    private var disposeBag = DisposeBag()

    /// 初期目標値
    var initialTargetNumber: Int = 100

    /// ピッカーで選択した目標値
    var selectedTargetNumber: Int = 30

    private var pickerDataList: [Int] {
        var list: [Int] = []
        var num = 0
        while num < 2000 {
            num += 10
            list.append(num)
        }
        return list
    }

    /// 目標タイプ区別用Enum
    enum TargetTypeEnum {
        /// 学習
        case study
        /// テスト
        case test

        /// 目標文字列
        var targetString: String {
            get {
                switch self {
                case .study:
                    return "LEARN"
                case .test:
                    return "TEST"
                }
            }
        }
    }

    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPieChartView(pieChartView: pieChartView)
        subscribe()

        // Delegate設定
        pickerView.delegate = self
        pickerView.dataSource = self
        setupInitialPickerView()
    }

}

// MARK: - Functions

extension TargetSettingViewController {

    private func subscribe() {
        // キャンセルボタンタップ
        cancelButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.dismiss(animated: true)
        }).disposed(by: disposeBag)

    }

    /// ピッカーの初期値を設定する
    private func setupInitialPickerView() {
        let index = pickerDataList.firstIndex(of: initialTargetNumber) ?? 0
        pickerView.selectRow(index, inComponent: 0, animated: false)
    }

}

extension TargetSettingViewController {

    // UIPickerViewの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // UIPickerViewの行数、リストの数
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return pickerDataList.count
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

            // 表示するラベルを生成する
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
            label.textAlignment = .center
            label.text = String(pickerDataList[row])
            label.font = R.font.notoSansCJKjpSubBold(size: 20)!
            label.textColor = R.color.textBlue()
            return label
        }

    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {

        selectedTargetNumber = pickerDataList[row]
        // ラベルに選択された値を反映する
        targetNumberLabel.text = String(selectedTargetNumber)
    }

}

extension TargetSettingViewController {

    /// 円形進捗バーの表示設定
    private func setupPieChartView(pieChartView: PieChartView) {
        // グラフに表示するデータ(仮)
        let dataEntries = [
            PieChartDataEntry(value: Double(100))
        ]

        // データをセットする
        let dataSet = PieChartDataSet(entries: dataEntries)
        dataSet.setColors(R.color.mainBlueDark()!)  // グラフの色
        dataSet.drawValuesEnabled = false  // グラフ上のデータ値を非表示にする
        pieChartView.data = PieChartData(dataSet: dataSet)

        pieChartView.holeRadiusPercent = 0.88  // 中心の穴の大きさ
        pieChartView.holeColor = UIColor.clear  // 中心の穴の色

        pieChartView.highlightPerTapEnabled = false  // グラフがタップされたときのハイライトを無効化
        pieChartView.chartDescription?.enabled = false  // グラフの説明を非表示
        pieChartView.drawEntryLabelsEnabled = false  // グラフ上のデータラベルを非表示
        pieChartView.legend.enabled = false  // グラフの注釈を非表示
        pieChartView.rotationEnabled = false // グラフが動くのを無効化

        view.addSubview(pieChartView)

        // アニメーションはつけない
    }

}

// MARK: - MakeInstance

extension TargetSettingViewController {

    static func makeInstance() -> UIViewController {
        guard let vc = R.storyboard.targetSettingViewController.targetSettingViewController() else {
            assertionFailure("Can't make instance 'TargetSettingViewController'.")
            return UIViewController()
        }
        return vc
    }

    static func makeInstanceInNavigationController() -> UIViewController {
        return UINavigationController(rootViewController: makeInstance())
    }

}
