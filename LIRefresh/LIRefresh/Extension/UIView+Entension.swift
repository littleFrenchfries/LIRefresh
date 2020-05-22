//
//  UIView+Entension.swift
//  LIRefresh
//
//  Created by wangxu on 2020/5/14.
//  Copyright © 2020 wangxu. All rights reserved.
//

import UIKit

extension UIView: LICompatible { }
public extension LI where Base : UIView {
    var x: CGFloat {
        get {
            return self.base.frame.origin.x
        }
        set {
            self.base.frame.origin.x = newValue
        }
    }
    var y: CGFloat {
        get {
            return self.base.frame.origin.y
        }
        set {
            self.base.frame.origin.y = newValue
        }
    }
    var width: CGFloat {
        get {
            return self.base.frame.size.width
        }
        set {
            return self.base.frame.size.width = newValue
        }
    }
    var height: CGFloat {
        get {
            return self.base.frame.size.height
        }
        set {
            self.base.frame.size.height = newValue
        }
    }
    var size: CGSize {
        get {
            return self.base.frame.size
        }
        set {
            self.base.frame.size = newValue
        }
    }
    var origin: CGPoint {
        get {
            return self.base.frame.origin
        }
        set {
            self.base.frame.origin = newValue
        }
    }
}
