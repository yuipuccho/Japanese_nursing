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

    /// 正解した単語情報の配列
    private var correctArray: [TestWordsDomainModel] = []
    /// 間違えた単語情報の配列
    private var mistakeArray: [TestWordsDomainModel] = []

    private var disposeBag = DisposeBag()

    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()
        subscribe()

        let allCount = correctArray.count + mistakeArray.count

        resultLabel.text = String(correctArray.count) + "/" + String(allCount)
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

    static func makeInstance(correctArray: [TestWordsDomainModel], mistakeArray: [TestWordsDomainModel]) -> UIViewController {
        guard let vc = R.storyboard.testResultViewController.testResultViewController() else {
            assertionFailure("Can't make instance 'TestResultViewController'.")
            return UIViewController()
        }
        vc.correctArray = correctArray
        vc.mistakeArray = mistakeArray
        return vc
    }

}

