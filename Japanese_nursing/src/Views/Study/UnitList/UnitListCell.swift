//
//  UnitListCell.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/03.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import UIKit

class UnitListCell: UITableViewCell {

    // MARK: - Outlets

    /// 単元のタイトル
    @IBOutlet weak var unitTitleLabel: UILabel!
    /// 単語数
    @IBOutlet weak var wordsCountLabel: UILabel!
    /// ブックマーク数
    @IBOutlet weak var bookMarksCountLabel: UILabel!
    /// チェックマーク率
    @IBOutlet weak var checkMarkPercentageLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        //clearConfigure()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        //clearConfigure()
    }

    func clearConfigure() {
        unitTitleLabel.text = nil
        wordsCountLabel.text = nil
        bookMarksCountLabel.text = nil
        checkMarkPercentageLabel.text = nil
    }

}
