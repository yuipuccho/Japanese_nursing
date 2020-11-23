//
//  UIView+IBInspectable.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/23.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    @IBInspectable var cornerRadius: CGFloat {
        get { return self.layer.cornerRadius }
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get { return self.layer.borderWidth }
        set { self.layer.borderWidth = newValue }
    }

    @IBInspectable var borderColor: UIColor {
        get {
            guard let cgColor = self.layer.borderColor else { return .clear }
            return UIColor(cgColor: cgColor)
        }
        set { self.layer.borderColor = newValue.cgColor }
    }
}
