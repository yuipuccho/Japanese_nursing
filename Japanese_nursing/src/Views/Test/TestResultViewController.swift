//
//  TestResultViewController.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/12/02.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

/**
 * テスト結果画面VC
 */
class TestResultViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var resultLabel: UILabel!

    @IBOutlet weak var closeButton: UIButton!

    // MARK: - Properties

    /// テスト数
    private var testCount: Int = 0
    /// 正解数
    private var correctCount: Int = 0

    private var disposeBag = DisposeBag()

    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribe()

        resultLabel.text = String(correctCount) + "/" + String(testCount)
    }

    // MARK: - Functions

    private func subscribe() {
        closeButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.presentingViewController?.presentingViewController?.dismiss(animated: true)
        }).disposed(by: disposeBag)
    }
}

// MARK: - MakeInstance

extension TestResultViewController {

    static func makeInstance(testCount: Int, correctCount: Int) -> UIViewController {
        guard let vc = R.storyboard.testResultViewController.testResultViewController() else {
            assertionFailure("Can't make instance 'TestResultViewController'.")
            return UIViewController()
        }
        vc.testCount = testCount
        vc.correctCount = correctCount
        return vc
    }

}

