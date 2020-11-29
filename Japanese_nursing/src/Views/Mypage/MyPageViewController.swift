//
//  MyPageViewController.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/09.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import UIKit
import Charts
import RxCocoa
import RxSwift

class MyPageViewController: UIViewController {

    private lazy var viewModel: MypageViewModel = MypageViewModel()

    // MARK: - Outlets

    /// 棒グラフ
    @IBOutlet private weak var barChartView: BarChartView!
    /// 学習円形進捗バー
    @IBOutlet private weak var studyPieChartView: PieChartView!
    /// テスト円形進捗バー
    @IBOutlet private weak var testPieChartView: PieChartView!
    /// 学習イメージ
    @IBOutlet private weak var studyImageView: UIImageView!
    /// テストイメージ
    @IBOutlet private weak var testImageView: UIImageView!
    /// 現在の学習済単語数
    @IBOutlet private weak var studyCurrentCountLabel: UILabel!
    /// 現在のテスト済単語数
    @IBOutlet private weak var testCurrentCountLabel: UILabel!
    /// 学習目標ラベル
    @IBOutlet private weak var studyTargetLabel: UILabel!
    /// テスト目標ラベル
    @IBOutlet private weak var testTargetLabel: UILabel!
    /// 学習円形進捗バーボタン
    @IBOutlet private weak var studyPieChartButton: UIButton!
    /// テスト円形進捗バーボタン
    @IBOutlet private weak var testPieChartButton: UIButton!
    /// 設定ボタン
    @IBOutlet private weak var settingButton: UIButton!

    // MARK: - Properties

    private var disposeBag = DisposeBag()

    private lazy var emptyView: EmptyView = {
        let v = R.nib.emptyView.firstView(owner: nil)!
        v.backgroundColor = R.color.test()
        v.retryAction = { [weak self] in
            self?.fetch()
        }
        v.page = .learn
        v.status = .none
        view.addSubview(v)
        view.allSafePin(subView: v)
        return v
    }()

    private var targetTestingCount = 0
    private var todayTestedCount = 0
    private var targetLearningCount = 0
    private var todayLearnedCount = 0

    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: true)

        setupBarChartView()
        fetch()

        subscribe()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupBarChartView()
        pieChartAnimation()
    }

}

// MARK: - Functions

extension MyPageViewController {

    private func subscribe() {
        // 学習円形進捗バーボタンタップ
        studyPieChartButton.rx.tap.subscribe(onNext: { [weak self] in
            let vc = TargetSettingViewController.makeInstance(targetType: .study)
            self?.present(vc, animated: true)
        }).disposed(by: disposeBag)

        // テスト円形進捗バーボタンタップ
        testPieChartButton.rx.tap.subscribe(onNext: { [weak self] in
            let vc = TargetSettingViewController.makeInstance(targetType: .test)
            self?.present(vc, animated: true)
        }).disposed(by: disposeBag)

        // 設定ボタンタップ
        settingButton.rx.tap.subscribe(onNext: { [weak self] in
            let vc = SettingListViewController.makeInstanceInNavigationController()
            self?.present(vc, animated: true)
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
        viewModel.fetch(authToken: ApplicationConfigData.authToken)
            .subscribe(
                onNext: { [unowned self] status in
                    targetLearningCount = status.targetLearningCount
                    todayLearnedCount = status.todayLearnedCount
                    targetTestingCount = status.targetTestingCount
                    todayTestedCount = status.todayTestedCount
                    setupPieChartView(pieChartView: studyPieChartView)
                    setupPieChartView(pieChartView: testPieChartView)
                    bringIconToFront()
                    pieChartAnimation()
                    setupUI()
                },
                onError: { [unowned self] in
                    log.error($0.descriptionOfType)
                    self.emptyView.status = .errorAndRetry($0.descriptionOfType)
                }).disposed(by: disposeBag)
    }

    private func setupUI() {
        studyTargetLabel.text = "LEARN " + String(targetLearningCount) + " WORDS"
        testTargetLabel.text = "TEST " + String(targetTestingCount) + " WORDS"
        studyCurrentCountLabel.text = String(todayLearnedCount)
        testCurrentCountLabel.text = String(todayTestedCount)
    }

}

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
        barChartView.xAxis.labelTextColor = R.color.graphTextBrown()!
        // X軸の線、グリッドを非表示にする
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.drawAxisLineEnabled = false

        // 右側のY座標軸は非表示にする
        barChartView.rightAxis.enabled = false

        // Y座標の値が0始まりになるように設定
        barChartView.leftAxis.axisMinimum = 0.0
        barChartView.leftAxis.drawZeroLineEnabled = true
        barChartView.leftAxis.zeroLineColor = R.color.graphTextBrown()
        // ラベルの数を設定
        barChartView.leftAxis.labelCount = 5
        // ラベルの色を設定
        barChartView.leftAxis.labelTextColor = R.color.graphTextBrown()!
        // グリッドの色を設定
        barChartView.leftAxis.gridColor = R.color.graphTextBrown()!
        // 軸線は非表示にする
        barChartView.leftAxis.drawAxisLineEnabled = false

        barChartView.legend.enabled = false
        barChartView.doubleTapToZoomEnabled = false
        barChartView.dragEnabled = false
        barChartView.pinchZoomEnabled = false
        barChartView.highlightPerTapEnabled = false    // グラフがタップされたときのハイライトを無効化

        // グラフの上に値を表示しない
        dataSet.drawValuesEnabled = false
        dataSet.colors = [R.color.graphBlue()!,
                          R.color.graphYellow()!,
                          R.color.mypage()!,
                          R.color.graphGreen()!,
                          R.color.graphYellow()!,
                          R.color.mypage()!,
                          R.color.graphGreen()!
        ]

        barChartView.animate(yAxisDuration: 0.8)
    }

    /// 円形進捗バーの表示設定
    private func setupPieChartView(pieChartView: PieChartView) {

        // グラフに表示するデータ
        var dataEntries = [
            PieChartDataEntry(value: Double(0)),
            PieChartDataEntry(value: Double(0))
        ]

        if pieChartView == studyPieChartView {
            let achivementRate = Double(todayLearnedCount * 100 / targetLearningCount)
            let notAchivementRate = 100 - achivementRate
            dataEntries = [
                PieChartDataEntry(value: Double(achivementRate)),
                PieChartDataEntry(value: Double(notAchivementRate))
            ]
        } else {
            let achivementRate = Double(todayTestedCount * 100 / targetTestingCount)
            let notAchivementRate = 100 - achivementRate
            dataEntries = [
                PieChartDataEntry(value: Double(achivementRate)),
                PieChartDataEntry(value: Double(notAchivementRate))
            ]
        }

        // データをセットする
        let dataSet = PieChartDataSet(entries: dataEntries)
        dataSet.setColors(UIColor.white, R.color.mypageWeakDark()!)  // グラフの色
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
        //pieChartView.animate(xAxisDuration: 1.2, yAxisDuration: 0.8) // アニメーション
    }

    /// 円形プロフレスバーの中心のアイコンとラベルを前面に持ってくる
    private func bringIconToFront() {
        view.bringSubviewToFront(studyCurrentCountLabel)
        view.bringSubviewToFront(testCurrentCountLabel)
        view.bringSubviewToFront(studyImageView)
        view.bringSubviewToFront(testImageView)
        view.bringSubviewToFront(studyPieChartButton)
        view.bringSubviewToFront(testPieChartButton)
    }

    private func pieChartAnimation() {
        studyPieChartView.animate(xAxisDuration: 1.2, yAxisDuration: 0.8) // アニメーション
        testPieChartView.animate(xAxisDuration: 1.2, yAxisDuration: 0.8)
    }

}
