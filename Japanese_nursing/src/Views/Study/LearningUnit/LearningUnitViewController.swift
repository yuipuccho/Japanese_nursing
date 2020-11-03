//
//  LearningUnitViewController.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/03.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import UIKit
import Koloda

/**
 * 学習画面VC
 */
class LearningUnitViewController: UIViewController {

    @IBOutlet weak var kolodaView: KolodaView!

    @IBOutlet weak var label: UILabel!

    private lazy var cardView = R.nib.cardView.firstView(owner: nil)!

    var items: [String] = ["aa", "bb", "cc"]

    override func viewDidLoad() {
        super.viewDidLoad()
        kolodaView.dataSource = self
        kolodaView.delegate = self
    }

}

// MARK: Koloda view delegate

extension LearningUnitViewController: KolodaViewDelegate {

    /// スワイプを続けて行ってデータソース内のViewを全て表示しきった際に呼ばれるメソッド
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
        print("Out of stock!!")
    }

    func koloda(koloda: KolodaView, didSelectCardAtIndex index: Int) {
        print("index \(index) has tapped!!")
    }

    /// カードがスワイプされたら実行されるメソッド
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        switch direction {
        case .right:
            print("Swiped to right!")
        case .left:
            print("Swiped to left!")
        default:
            print("aaa")
        }
    }

}

// MARK: Koloda view data source

extension LearningUnitViewController: KolodaViewDataSource {

    /// カードの枚数を返す
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return 3
    }

    /// カードのViewを返す
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
//        var view = UIView(frame: koloda.bounds)
//        view = cardView
//        view.backgroundColor = UIColor.gray


//        // UILabelの設定
//        let titleLabel = UILabel() // ラベルの生成
//        titleLabel.frame = CGRect(x: 50, y: 50, width: 100, height: 40) // 位置とサイズの指定
//        titleLabel.textAlignment = .center // 横揃えの設定
//        titleLabel.text = items[index] // テキストの設定
//        titleLabel.textColor = UIColor.white // テキストカラーの設定
//        titleLabel.font = R.font.notoSansCJKjpSubBlack(size: 40) // フォントの設定
//        titleLabel.center = view.center
//
//        view.addSubview(titleLabel) // ラベルの追加

//        cardView.frame = view.frame
//        cardView.center = view.center
//        view.addSubview(cardView)
        let view = cardView

        view.layer.cornerRadius = 20

        return view
    }


//    //左へ
//    @IBAction func cardGoToleft() {
//    kolodaView.swipe(.left)
//    }
//
//    //右へ
//    @IBAction func cardGoToright() {
//        kolodaView.swipe(.right)
//    }

}

// MARK: - makeInstance

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
