//
//  EmptyView.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/29.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

enum EmptyPage {
    case none
    case tab  // タブが表示されているページ
    case learn  // 学習画面

    var icon: UIImage? {
        switch self {
        case .learn:
            return R.image.mypage_study()
        default:
            return nil
        }
    }

}

enum EmptyStatus {
    case none
    case loading
    case success
    case errorAndRetry(String?)
    case showPage  // ページ表示
}

final class EmptyView: UIView {

    private var disposeBag = DisposeBag()

    var retryAction: (() -> Void)?

    @IBOutlet private weak var retryButton: UIButton!
    @IBOutlet private weak var indicator: UIActivityIndicatorView!
    @IBOutlet private weak var iconImage: UIImageView!
    @IBOutlet private weak var headLabel: UILabel!
    @IBOutlet private weak var subTextLabel: UILabel!

    var page: EmptyPage = .none

    var status: EmptyStatus = .none {
        didSet { self.updateState() }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        retryButton.rx.tap
            .bind { [unowned self] in
                self.retryAction?()
            }.disposed(by: disposeBag)
    }

    private func emptyViewErrorAndRetry() {
        headLabel.text = "通信エラー"
        subTextLabel.text = "ネットワーク環境が不安定です。\nしばらくたってからリトライをお試しください。"
        retryButton.isHidden = false

        indicator.stopAnimating()
        indicator.isHidden = true
    }

    private func emptyViewShowPage(headText: String, subText: String) {
        headLabel.text = headText
        subTextLabel.text = subText
        iconImage.isHidden = true  // TODO: イメージも表示したい
        iconImage.image = page.icon
    }

    private func updateState() {
        switch status {
        case .none:
            self.isHidden = true

        case .loading:
            self.isHidden = false
            retryButton.isHidden = true
            indicator.startAnimating()
            indicator.isHidden = false
            iconImage.isHidden = true
            headLabel.text = nil
            subTextLabel.text = nil

        case .success:
            self.isHidden = true
            retryButton.isHidden = true
            indicator.stopAnimating()
            indicator.isHidden = true
            iconImage.isHidden = true
            headLabel.text = nil
            subTextLabel.text = nil

        case .errorAndRetry(let text):
            switch self.page {
            case .tab, .learn:
                emptyViewErrorAndRetry()
            default:
                self.isHidden = text == nil
                retryButton.isHidden = false
                indicator.stopAnimating()
                indicator.isHidden = true
                iconImage.isHidden = true
                headLabel.text = nil
                subTextLabel.text = text
            }
        case .showPage:
            self.isHidden = false
            retryButton.isHidden = true
            indicator.stopAnimating()
            indicator.isHidden = true
            switch self.page {
            case .learn:
                emptyViewShowPage(headText: "条件を満たすカードが\nありません",
                                  subText: "右上の設定ボタンを押して\n表示設定を変更しましょう")
            default:
                break
            }
        }
    }

}
