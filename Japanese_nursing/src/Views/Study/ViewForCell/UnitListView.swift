//
//  UnitListView.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/07/31.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import UIKit

/**
 * 単元一覧セルView
 */
class UnitListView: UITableViewCell {

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
    }

}
