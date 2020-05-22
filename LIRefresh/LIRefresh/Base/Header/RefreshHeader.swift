//
//  RefreshHeader.swift
//  LIRefresh
//
//  Created by wangxu on 2020/5/18.
//  Copyright © 2020 wangxu. All rights reserved.
//

import UIKit

public class RefreshHeader: RefreshComponent {
    public override var state: RefreshState {
        willSet {
            guard var indeedScrollView = self.scrollView else { return }
            if newValue == .refreshing {
                UIView.animate(withDuration: 0.3, animations: {
                    indeedScrollView.li.top = self.li.height
                    var offset = indeedScrollView.contentOffset
                    offset.y = -self.li.height
                    indeedScrollView.setContentOffset(offset, animated: false)
                }) { (finish) in
                    
                }
            }else if newValue == .idle {
                UIView.animate(withDuration: 0.3, animations: {
                    indeedScrollView.li.top = 0
                }) { (finish) in
                    
                }
            }
        }
    }
   
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        var sf = self
        sf.li.height = 50
    }
    // MARK: - 构造方法
    public static func headerWithRefreshing(block: @escaping RefreshComponentRefreshingBlock) -> RefreshHeader {
        let header = self.init()
        header.refreshingBlock = block
        return header
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func placeSubViews() {
        super.placeSubViews()
        var sf = self
        sf.li.y = -self.li.height
        
    }
    public override func scrollViewContentOffsetDid(change: [NSKeyValueChangeKey : Any]) {
        super.scrollViewContentOffsetDid(change: change)
        // Mark:  如果正在刷新，直接返回
        if self.state == .refreshing { return }
        guard let indeedScrollView = self.scrollView else { return }
        // Mark:  当前contentOffset
        let offsetY = indeedScrollView.li.offsetY
        let pullingPercent = (-offsetY) / self.li.height
        if indeedScrollView.isDragging {
            self.pullingPercent = pullingPercent
            // Mark:  普通和即将刷新的临界点
            let normalPullingOffsetY =  -self.li.height
            switch state {
            // Mark:闲置
            case .idle:
                if offsetY < normalPullingOffsetY {
                    state = .pulling
                }
                break
            // Mark:  松开就可以刷新
            case .pulling:
                if offsetY >= normalPullingOffsetY {
                    state = .idle
                }
                break
            default: break
            }
        }else if state == .pulling {
            // Mark:  调用刷新
            beginRefreshing()
            if let block = refreshingBlock {
                block()
            }
        }else if pullingPercent < 1 {
            self.pullingPercent = pullingPercent
        }
    }
    
    public override func scrollViewContentSizeDid(change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentSizeDid(change: change)
    }
    public override func scrollViewPanStateDid(change: [NSKeyValueChangeKey : Any]) {
        super.scrollViewPanStateDid(change: change)
    }
}
