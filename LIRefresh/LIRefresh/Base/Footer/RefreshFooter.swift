//
//  RefreshFooter.swift
//  LIRefresh
//
//  Created by wangxu on 2020/5/19.
//  Copyright © 2020 wangxu. All rights reserved.
//

import UIKit

public class RefreshFooter: RefreshComponent {
    // Mark:  当底部控件出现多少时就会自动h刷新（默认为1.0）
    public var atuomaticallyRefreshPercent: CGFloat = 1.0
    public override var pullingPercent: CGFloat {
        willSet {
            switch state {
            case .idle,.none,.nomoreData,.pulling:
                self.alpha = newValue
            default:break
            }
        }
    }
    public override var state: RefreshState {
        willSet {
            guard var indeedScrollView = self.scrollView else { return }
            switch newValue {
            case .refreshing:
                UIView.animate(withDuration: 0.3, animations: {
                    indeedScrollView.li.bottom = self.li.height
                }) { (finish) in
                    
                }
                break
            case .idle:
                UIView.animate(withDuration: 0.3, animations: {
                    indeedScrollView.li.bottom = 0
                    self.alpha = 0.0
                }) { (finish) in
                    
                }
                break
            default:break
            }
        }
    }
    
    static public func footerWithRefreshing(block: @escaping RefreshComponentRefreshingBlock) -> RefreshFooter {
        let footer = self.init()
        footer.refreshingBlock = block
        return footer
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        var sf = self
        sf.li.height = 50
    }
    public override func placeSubViews() {
        super.placeSubViews()
        var sf = self
        sf.li.y = (self.scrollView?.li.contentH ?? 0)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func scrollViewContentOffsetDid(change: [NSKeyValueChangeKey : Any]) {
        super.scrollViewContentOffsetDid(change: change)
        // Mark:  如果正在刷新，直接返回
        if self.state == .refreshing { return }
        guard let indeedScrollView = self.scrollView else { return }
        let offsetY = indeedScrollView.li.offsetY
        // Mark:  尾部控件刚好出现的offsetY
        let pullingPercent = (offsetY - happenOffSetY) / self.li.height
        if indeedScrollView.isDragging {
            self.pullingPercent = pullingPercent
            // Mark:  普通和即将刷新的临界点
            let normalPullingOffsetY = happenOffSetY + self.li.height
            switch state {
            // Mark:闲置
            case .idle:
                if offsetY >= normalPullingOffsetY {
                    state = .pulling
                }
                break
            // Mark:  松开就可以刷新
            case .pulling:
                if offsetY < normalPullingOffsetY {
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
    var happenOffSetY: CGFloat {
        let deltaH = heightForContentBreakView
        if  deltaH > 0 {
            /// 上拉加载更多的控件在可视区域内
            return deltaH - self.scrollViewOriginalInset.top
        } else {
            return -self.scrollViewOriginalInset.top
        }
    }
    /// 获得scrollView的内容超出view的高度
    var heightForContentBreakView: CGFloat {
        if let indeedScrollView = self.scrollView {
            let height = indeedScrollView.frame.size.height - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom
            return indeedScrollView.contentSize.height - height
        } else {
            return 0
        }
    }
}
