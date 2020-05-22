//
//  UILabel+Entension.swift
//  LIRefresh
//
//  Created by wangxu on 2020/5/22.
//  Copyright © 2020 wangxu. All rights reserved.
//

import Foundation
import UIKit

public extension LI where Base : UILabel {
    var textWidth: CGFloat {
        let size = CGSize(width: Int.max, height: Int.max)
        guard let text = self.base.text else { return 0 }
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading, .usesDeviceMetrics, .truncatesLastVisibleLine]
        let attributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.font : self.base.font ?? 14]
        let width = (text as NSString).boundingRect(with: size, options: options, attributes: attributes, context: nil).size.width
        return width
    }
}
