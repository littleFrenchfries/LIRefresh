//
//  UIScrollView+Extension.swift
//  LIRefresh
//
//  Created by wangxu on 2020/5/18.
//  Copyright © 2020 wangxu. All rights reserved.
//

import Foundation
import UIKit

private struct StorageKey {
    static var refreshHeader = "refreshHeader"
    static var refreshFooter = "refreshFooter"
    static var refreshLeft   = "refreshLeft"
    static var refreshRight  = "refreshRight"
    static var reloadHandler = "reloadHandler"
}

public extension LI where Base : UIScrollView {
    var inset: UIEdgeInsets {
        get {
            if #available(iOS 11.0, *) {
                return self.base.adjustedContentInset
            }
            return self.base.contentInset
        }
    }
    var top: CGFloat {
        get {
            return self.inset.top
        }
        set {
            var insert = self.base.contentInset;
            insert.top = newValue
            if #available(iOS 11.0, *) {
                insert.top -= (self.base.adjustedContentInset.top - self.base.contentInset.top)
            }
            self.base.contentInset = insert
        }
    }
    
    var left: CGFloat {
        get {
            return self.inset.left
        }
        set {
            var insert = self.base.contentInset;
            insert.left = newValue
            if #available(iOS 11.0, *) {
                insert.left -= (self.base.adjustedContentInset.left - self.base.contentInset.left)
            }
            self.base.contentInset = insert
        }
    }
    var bottom: CGFloat {
        get {
            return self.inset.bottom
        }
        set {
            var insert = self.base.contentInset;
            insert.bottom = newValue
            if #available(iOS 11.0, *) {
                insert.bottom -= (self.base.adjustedContentInset.bottom - self.base.contentInset.bottom)
            }
            self.base.contentInset = insert
        }
    }
    var right: CGFloat {
        get {
            return self.inset.right
        }
        set {
            var insert = self.base.contentInset;
            insert.right = newValue
            if #available(iOS 11.0, *) {
                insert.right -= (self.base.adjustedContentInset.right - self.base.contentInset.right)
            }
            self.base.contentInset = insert
        }
    }
    
    var offsetX: CGFloat {
        get {
            return self.base.contentOffset.x
        }
        set {
            var offset = self.base.contentOffset
            offset.x = newValue
            self.base.contentOffset = offset
        }
    }
    
    var offsetY: CGFloat {
        get {
            return self.base.contentOffset.y
        }
        set {
            var offset = self.base.contentOffset
            offset.y = newValue
            self.base.contentOffset = offset
        }
    }
    var contentW: CGFloat {
        get {
            return self.base.contentSize.width
        }
        set {
            var size = self.base.contentSize
            size.width = newValue
            self.base.contentSize = size
        }
    }
    var contentH: CGFloat {
        get {
            return self.base.contentSize.height
        }
        set {
            var size = self.base.contentSize
            size.height = newValue
            self.base.contentSize = size
        }
    }
    var header: RefreshHeader? {
        set {
            guard header != newValue else { return }
            header?.removeFromSuperview()
            objc_setAssociatedObject(self.base, &StorageKey.refreshHeader, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            guard let header = newValue else { return }
            base.insertSubview(header, at: 0)
        }
        get {
            return objc_getAssociatedObject(self.base, &StorageKey.refreshHeader) as? RefreshHeader
        }
    }
    var footer: RefreshFooter? {
        set {
            guard footer != newValue else { return }
            footer?.removeFromSuperview()
            objc_setAssociatedObject(self.base, &StorageKey.refreshFooter, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            guard let header = newValue else { return }
            base.insertSubview(header, at: 0)
        }
        get {
            return objc_getAssociatedObject(self.base, &StorageKey.refreshFooter) as? RefreshFooter
        }
    }
}


