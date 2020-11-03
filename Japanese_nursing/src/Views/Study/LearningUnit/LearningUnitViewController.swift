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

    @IBOutlet weak var cardView: KolodaView!

    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.dataSource = self
        cardView.delegate = self
    }

}

// MARK: Koloda view delegate

extension LearningUnitViewController: KolodaViewDelegate {

    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        label.text = "2"
    }

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
        let view = UIView(frame: koloda.bounds)
        view.backgroundColor = UIColor.gray
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
