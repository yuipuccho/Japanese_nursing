//
//  BaseTextField.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/28.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class BaseTextField: UITextField {

    @IBInspectable var canPerformAction: Bool = true

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return canPerformAction
    }

}
