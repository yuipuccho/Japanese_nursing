//
//  UnitListCell.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/03.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class UnitListCell: UITableViewCell {

    // MARK: - Outlets

    /// 単元のタイトル
    @IBOutlet weak var unitTitleLabel: UILabel!
    /// 単語数
    @IBOutlet weak var wordsCountLabel: UILabel!
    /// チェックマーク率
    @IBOutlet weak var checkMarkPercentageLabel: UILabel!
    /// セルボタン（セルのタップだとセルが白くなる不具合がなぜか発生するため、応急処置）
    @IBOutlet weak var cellButton: UIButton!

    // MARK: - Properties

    /// セルタップ
    var cellTappedSubject: PublishSubject<Void> = PublishSubject<Void>()

    var disposeBag = DisposeBag()

    // MARK: - LifeCycles

    override func awakeFromNib() {
        super.awakeFromNib()
        subscribe()
        //clearConfigure()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        //clearConfigure()
    }

    // MARK: - Functions

    func clearConfigure() {
        unitTitleLabel.text = nil
        wordsCountLabel.text = nil
        checkMarkPercentageLabel.text = nil
    }

    func subscribe() {
        // セルタップ
        cellButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.cellTappedSubject.onNext(())
        }).disposed(by: disposeBag)
    }

}
