//
//  NormalRefreshFooter.swift
//  LIRefresh
//
//  Created by wangxu on 2020/5/22.
//  Copyright © 2020 wangxu. All rights reserved.
//

import UIKit

open class NormalRefreshFooter: RefreshFooter {
    fileprivate let circleLayer = CAShapeLayer()
    fileprivate let strokeColor = UIColor(red: 135.0/255.0, green: 136.0/255.0, blue: 137.0/255.0, alpha: 1.0)
    
    override open var pullingPercent: CGFloat {
        didSet {
            //这里可以根据百分比 绘制进度效果
            let adjustPercent = max(min(1.0, pullingPercent),0.0)
            self.circleLayer.strokeEnd = 0.05 + 0.9 * adjustPercent
        }
    }
    
    lazy var stateLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .lightGray
        label.autoresizingMask = [.flexibleWidth]
        label.textAlignment = .center
        label.li.x = 0
        label.li.y = 0
        label.li.width = li.width
        label.li.height = li.height
        addSubview(label)
        return label
    }()
    
    /// 状态对应的问题
    public var stateTitles: [RefreshState: String] = [
        .idle: "上拉加载更多",
        .pulling: "松开刷新",
        .refreshing: "加载中..."
    ]
    
    public override var state: RefreshState {
        willSet {
            stateLabel.text = stateTitles[newValue]
            if newValue == .idle {
                /// save
                UserDefaults.standard.setValue(Date(), forKey: NSStringFromClass(Self.self))
                UserDefaults.standard.synchronize()
                didCompleteHideAnimation()
                self.circleLayer.isHidden = true
            } else if newValue == .refreshing {
                self.circleLayer.isHidden = false
                didBeginRefreshingState()
            }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpCircleLayer()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func placeSubviews() {
        super.placeSubviews()
        self.circleLayer.isHidden = true
        self.circleLayer.position = CGPoint(x:  self.li.width * 0.5, y: self.li.height * 0.5)
    }
    
    func setUpCircleLayer() {
        let bezierPath = UIBezierPath(arcCenter: CGPoint(x: 20, y: 20), radius: 12.0, startAngle: -.pi / 2, endAngle: .pi/2.0 * 3.0, clockwise: true)
        self.circleLayer.path = bezierPath.cgPath
        self.circleLayer.strokeColor = UIColor.lightGray.cgColor
        self.circleLayer.fillColor = UIColor.clear.cgColor
        self.circleLayer.strokeStart = 0.05
        self.circleLayer.strokeEnd = 0.05
        self.circleLayer.lineWidth = 1.0
        self.circleLayer.lineCap = CAShapeLayerLineCap.round
        self.circleLayer.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.circleLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.layer.addSublayer(self.circleLayer)
    }
    
    func didBeginRefreshingState(){
        self.circleLayer.strokeEnd = 0.95
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.toValue = NSNumber(value: .pi * 2.0)
        rotateAnimation.duration = 0.6
        rotateAnimation.isCumulative = true
        rotateAnimation.repeatCount = 10000000
        self.circleLayer.add(rotateAnimation, forKey: "rotate")
    }
    
    func didCompleteHideAnimation(){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.circleLayer.strokeEnd = 0.05
        CATransaction.commit()
        self.circleLayer.removeAllAnimations()
    }
}
