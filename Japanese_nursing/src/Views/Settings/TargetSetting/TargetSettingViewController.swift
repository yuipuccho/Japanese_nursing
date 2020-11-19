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
class TargetSettingViewController: UIViewController {

    // MARK: - Outlets

    /// 円形進捗バー
    @IBOutlet private weak var pieChartView: PieChartView!
    /// 目標数ラベル
    @IBOutlet weak var targetNumberLabel: UILabel!
    /// 目標数ピッカー
    @IBOutlet weak var pickerView: UIPickerView!
    /// キャンセルボタン
    @IBOutlet weak var cancelButton: UIButton!
    /// 保存ボタン
    @IBOutlet weak var saveButton: UIButton!

    // MARK: - Properties

    private var disposeBag = DisposeBag()

    var targetNumber: Int = 0

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

        subscribe()
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
