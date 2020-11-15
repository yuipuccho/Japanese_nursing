//
//  UnderlineTextField.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/15.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import UIKit

class UnderlineTextField: PaddingTextField {

    @IBInspectable var underlineHeight: CGFloat = 0
    @IBInspectable var underlineColor: UIColor?


    private var _underline: CALayer?

    override func awakeFromNib() {
        super.awakeFromNib()

        if let lineColor = underlineColor {
            setUnderline(lineColor, height: underlineHeight)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if let lineColor = underlineColor {
            setUnderline(lineColor, height: underlineHeight)
        }
    }

    func setUnderline(_ color: UIColor, height: CGFloat? = nil) {
        let h = height ?? self.underlineHeight
        _underline?.removeFromSuperlayer()
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.bounds.height - h, width: self.bounds.width, height: h)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
        _underline = border
        underlineHeight = h
        underlineColor = color
    }

}
