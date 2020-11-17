//
//  OverlayView.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/17.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import UIKit
import Koloda

/**
 * オーバレイView
 */
class CustomOverlayView: OverlayView {

    // MARK: - Outlets

    // 覚えた
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var checkLabel: UILabel!
    // 覚えていない
    @IBOutlet weak var batuImageView: UIImageView!
    @IBOutlet weak var batuLabel: UILabel!

    // MARK: - Properties

    override var overlayState: SwipeResultDirection? {
        didSet {
            switch overlayState {
            case .left:
                checkImageView.isHidden = true
                checkLabel.isHidden = true
                batuImageView.isHidden = false
                batuLabel.isHidden = false
                let color = R.color.mistakePink()
                self.backgroundColor = color?.withAlphaComponent(0.5)

            case .right:
                checkImageView.isHidden = false
                checkLabel.isHidden = false
                batuImageView.isHidden = true
                batuLabel.isHidden = true
                let color = R.color.mainBlue()
                self.backgroundColor = color?.withAlphaComponent(0.5)

            default:
                break
            }
        }
    }

}
