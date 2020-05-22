//
//  RefreshComponent.swift
//  LIRefresh
//
//  Created by wangxu on 2020/5/18.
//  Copyright © 2020 wangxu. All rights reserved.
//

import UIKit

public enum RefreshState {
    // Mark:闲置
    case idle
    // Mark:  松开就可以刷新
    case pulling
    // Mark:  刷新中
    case refreshing
    // Mark:  即将刷新
    case willRefresh
    // Mark:  所有数据加载完毕 没有更过数据
    case nomoreData
    // Mark:  初始状态 刚创建的时候 状态会从none--->idle
    case none
}


public class RefreshComponent: UIView {
    public static let contentOffset = "contentOffset"
    public static let contentInSet = "contentInset"
    public static let contentSize = "contentSize"
    public static let panState = "state"
    /// 正在刷新的回调
    public typealias RefreshComponentRefreshingBlock = () -> Void
    // MARK: - 属性
    public var refreshingBlock: RefreshComponentRefreshingBlock?
    // Mark:  父控件
    public weak var scrollView: UIScrollView?
    // Mark:  手势
    private var pan: UIPanGestureRecognizer?
    // Mark:  记录scrollview刚开始的inset
    var scrollViewOriginalInset: UIEdgeInsets = UIEdgeInsets.zero
    // Mark:  拖拽百分比
    open var pullingPercent: CGFloat = 0.0
    public var state: RefreshState = .none
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = [.flexibleWidth]
        backgroundColor = .clear
        state = .idle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.placeSubViews()
    }
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        removeObservers()
        guard let superView = newSuperview as? UIScrollView  else { return }
        scrollView = superView
        addObservers()
        // Mark:  新父控件
        // Mark:  宽
        var sf = self
        sf.li.width = superView.li.width
        // Mark:  位置
        sf.li.x = 0
        // Mark:  设置永远支持垂直弹簧效果 否则不会触发delegate方法，kvo失效
        scrollView?.alwaysBounceVertical = true
        // Mark:  记录最开始的icontentInset
        scrollViewOriginalInset = superView.contentInset
    }
    // MARK: - observers
    /// 添加监听
    func addObservers() {
        let options: NSKeyValueObservingOptions = [.new, .old]
        scrollView?.addObserver(self, forKeyPath: RefreshComponent.contentOffset , options: options, context: nil)
        scrollView?.addObserver(self, forKeyPath: RefreshComponent.contentSize, options: options, context: nil)
        pan = self.scrollView?.panGestureRecognizer
        pan?.addObserver(self, forKeyPath: RefreshComponent.panState, options: options, context: nil)
    }
    /// 移除监听
    func removeObservers() {
        guard superview is UIScrollView else { return }
        superview?.removeObserver(self, forKeyPath: RefreshComponent.contentOffset)
        superview?.removeObserver(self, forKeyPath: RefreshComponent.contentSize)
        pan?.removeObserver(self, forKeyPath: RefreshComponent.panState)
        pan = nil
    }
    /// kvo
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if !self.isUserInteractionEnabled || self.isHidden { return }
        guard let path = keyPath as NSString? else { return }
        
        if let change = change, path.isEqual(to: RefreshComponent.contentOffset) {
            self.scrollViewContentOffsetDid(change: change)
        } else if let change = change, path.isEqual(to: RefreshComponent.contentSize) {
            self.scrollViewContentSizeDid(change: change)
        } else if let change = change, path.isEqual(to: RefreshComponent.panState) {
            self.scrollViewPanStateDid(change: change)
        }
    }
    // MARK: - 刷新状态控制
    public func beginRefreshing() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1.0
        }
        self.pullingPercent = 1.0
        // 只要正在刷新 就完全显示
        self.state = .refreshing
    }
    // 结束刷新
    public func endRefreshing() {
        DispatchQueue.main.async {
            self.state = .idle
        }
    }
    /// 摆放子控件的frame
    open func placeSubViews() {}
    /// 当scrollView的contentOffset发生改变的时候调用
    open func scrollViewContentOffsetDid(change: [NSKeyValueChangeKey: Any]) {}
    /// 当scrollView的contentSize发生改变的时候调用
    open func scrollViewContentSizeDid(change: [NSKeyValueChangeKey: Any]?) {}
    /// 当scrollView的拖拽状态发生改变的时候调用
    open func scrollViewPanStateDid(change: [NSKeyValueChangeKey: Any]) {}
}
