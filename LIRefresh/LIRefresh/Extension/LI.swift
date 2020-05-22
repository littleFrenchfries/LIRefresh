//
//  LI.swift
//  LIRefresh
//
//  Created by wangxu on 2020/5/14.
//  Copyright © 2020 wangxu. All rights reserved.
//

import Foundation

import UIKit

public struct LI<Base> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

// MARK: - protocol for normal types
public protocol LICompatible {}
public extension LICompatible {
    static var li: LI<Self>.Type {
        get { LI<Self>.self }
        set {}
    }
    var li: LI<Self> {
        get { LI(self) }
        set {}
    }
}

// MARK: - protocol for types with a generic parameter
public struct LIGeneric<Base, LIT> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}
public protocol LIGenericCompatible {
    associatedtype LIT
}
public extension LIGenericCompatible {
    static var li: LIGeneric<Self, LIT>.Type {
        get { LIGeneric<Self, LIT>.self }
        set {}
    }
    var li: LIGeneric<Self, LIT> {
        get { LIGeneric(self) }
        set {}
    }
}

// MARK: - protocol for types with two generic parameter2
public struct LIGeneric2<Base, LIT1, LIT2> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}
public protocol LIGenericCompatible2 {
    associatedtype LIT1
    associatedtype LIT2
}
public extension LIGenericCompatible2 {
    static var li: LIGeneric2<Self, LIT1, LIT2>.Type {
        get { LIGeneric2<Self, LIT1, LIT2>.self }
        set {}
    }
    var li: LIGeneric2<Self, LIT1, LIT2> {
        get { LIGeneric2(self) }
        set {}
    }
}



// Mark: - 给UIViewController加前缀
extension UIViewController: LICompatible { }
