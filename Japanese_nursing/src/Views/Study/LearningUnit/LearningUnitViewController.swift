//
//  LearningUnitViewController.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/03.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import UIKit
import Koloda
import RxSwift
import RxCocoa

/**
 * 学習画面VC
 */
class LearningUnitViewController: UIViewController {

    // MARK: - Outlets

    /// 閉じるボタン
    @IBOutlet weak var closeButton: UIButton!
    /// 「覚えた」ボタン（チェックマーク）
    @IBOutlet weak var memorizedButton: UIButton!
    /// 「覚えていない」ボタン（バツマーク）
    @IBOutlet weak var notMemorizedButton: UIButton!
    /// 進捗バー
    @IBOutlet weak var progressView: UIProgressView!

    // MARK: - Properties

    private let kolodaView = KolodaView()

    /// カードのサイズ
    private var cardFrame: CGRect {
        let width = (view.bounds.size.width) * 0.85
        let height = (view.bounds.size.height) * 0.55
        return CGRect(x: 0, y: 0, width: width, height: height)
    }

    private var items: [String] = ["aa", "bb", "cc", "dd", "ee"]

    private var disposebag = DisposeBag()

    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()

        subscribe()

        kolodaView.dataSource = self
        kolodaView.delegate = self

        // 表示サイズや位置を調整して、viewに追加
        kolodaView.frame = cardFrame
        // このへんあとで調整
        kolodaView.center = CGPoint(x: view.bounds.size.width / 2, y: (view.bounds.size.height / 2) - 50)
        self.view.addSubview(kolodaView)
    }

    // MARK: - Functions

    private func subscribe() {
        // 閉じるボタンタップ
        closeButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.dismiss(animated: true)
        }).disposed(by: disposebag)

        // 覚えたボタンタップ
        memorizedButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.kolodaView.swipe(.right)
        }).disposed(by: disposebag)

        // 覚えていないボタンタップ
        notMemorizedButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.kolodaView.swipe(.left)
        }).disposed(by: disposebag)
    }

    /// 関数名
    private func updateProgressView(swipedCardIndex: Int) {
        /// カードの最大枚数
        let maxCardCount = Float(items.count)
        /// スワイプされたカードの枚数
        let swipedCardCount = Float(swipedCardIndex + 1)
        /// 進捗
        let progress = Float(swipedCardCount / maxCardCount)

        progressView.setProgress(progress, animated: true)
    }

}

// MARK: - KolodaViewDelegate

extension LearningUnitViewController: KolodaViewDelegate {

    /// スワイプを続けて行ってデータソース内のViewを全て表示しきった際に呼ばれるメソッド
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
        print("Out of stock!!")
    }

    /// カードがタップされた際に呼ばれるメソッド
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        print("index \(index) has tapped!!")
    }

    /// カードがスワイプされたら実行されるメソッド
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        // TODO: APIが追加されたら、スワイプの方向によって処理を変更する
//        switch direction {
//        case .right:
//        case .left:
//        default:
//            break
//        }
        updateProgressView(swipedCardIndex: index)
    }

}

// MARK: - KolodaViewDataSource

extension LearningUnitViewController: KolodaViewDataSource {

    /// カードの枚数を返す
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return items.count
    }

    /// カードのViewを返す
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {

        // CardのベースとなるView
        let view = UIView()
        view.frame = cardFrame
        view.layer.backgroundColor = UIColor.white.cgColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 1.5)


        // ラベルを表示する.
        let label = UILabel()
        label.text = items[index]
        label.font = R.font.notoSansCJKjpSubBold(size: 40)
        label.textColor = R.color.mainBlue()
        label.sizeToFit()
        label.center = view.center
        view.addSubview(label) // ラベルの追加

        view.layer.cornerRadius = 10

        return view
    }

}

// MARK: - MakeInstance

extension LearningUnitViewController {

    static func makeInstance() -> UIViewController {
        guard let vc = R.storyboard.learningUnit.learningUnitViewController() else {
            assertionFailure("Can't make instance 'LearningUnitViewController'.")
            return UIViewController()
        }
        return vc
    }

    static func makeInstanceInNavigationController() -> UIViewController {
        return UINavigationController(rootViewController: makeInstance())
    }

}
