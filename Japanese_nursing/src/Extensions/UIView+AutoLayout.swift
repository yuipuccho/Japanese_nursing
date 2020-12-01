//
//  UIView+AutoLayout.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/11/29.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    public func checkTranslatesAutoresizing(withView: UIView?, toView: UIView?) {
        if withView?.translatesAutoresizingMaskIntoConstraints == true {
            withView?.translatesAutoresizingMaskIntoConstraints = false
        }
        if toView?.translatesAutoresizingMaskIntoConstraints == true {
            toView?.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    public func allSafePin(subView: UIView, top: CGFloat = 0) {
        checkTranslatesAutoresizing(withView: subView, toView: nil)
        NSLayoutConstraint.activate([
            subView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: top),
            subView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
            subView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor),
            subView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}
