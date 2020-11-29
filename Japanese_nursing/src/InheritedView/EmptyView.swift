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
    case learn

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
    case noData(String)
    case errorAndRetry(String?)
    case showPage
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

    var status: EmptyStatus = .none

    override func awakeFromNib() {
        super.awakeFromNib()

        retryButton.rx.tap
            .bind { [unowned self] in
                self.retryAction?()
            }.disposed(by: disposeBag)
    }

    private func userEmptyViewErrorAndRetry() {
        iconImage.image = page.icon
        headLabel.text = "通信エラー"
        subTextLabel.text = "ネットワーク環境が不安定です。\nしばらくたってからリトライをお試しください。"
        retryButton.isHidden = false

        indicator.stopAnimating()
    }

}
