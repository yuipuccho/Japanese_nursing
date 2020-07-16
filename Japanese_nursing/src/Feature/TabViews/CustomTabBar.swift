//
//  CustomTabBar.swift
//  Japanese_nursing
//
//  Created by 吉澤優衣 on 2020/07/16.
//  Copyright © 2020 吉澤優衣. All rights reserved.
//

import UIKit

class CustomTabBar: UITabBar {

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 58
        sizeThatFits.height += safeAreaInsets.bottom

        return sizeThatFits
    }

}
