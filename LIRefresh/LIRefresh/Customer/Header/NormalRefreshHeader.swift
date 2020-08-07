//
//  NormalRefreshHeader.swift
//  LIRefresh
//
//  Created by wangxu on 2020/5/21.
//  Copyright © 2020 wangxu. All rights reserved.
//

import UIKit

open class NormalRefreshHeader: RefreshHeader {
    fileprivate let circleLayer = CAShapeLayer()
    fileprivate let arrowLayer = CAShapeLayer()
    fileprivate let strokeColor = UIColor(red: 135.0/255.0, green: 136.0/255.0, blue: 137.0/255.0, alpha: 1.0)
    
    override open var pullingPercent: CGFloat {
        didSet {
            //这里可以根据百分比 绘制进度效果
            let adjustPercent = max(min(1.0, pullingPercent),0.0)
            self.circleLayer.strokeEnd = 0.05 + 0.9 * adjustPercent
        }
    }
    private var lastUpdatedTime: Date? {
        return UserDefaults.standard.object(forKey: NSStringFromClass(Self.self)) as? Date
    }
    private var lastUpdatedTimeString: String {
        if let time = lastUpdatedTime {
            let calender = Calendar.current
            /// 存储的时间
            let cmp1 = calender.dateComponents([.year, .month, .day, .hour, .minute], from: time)
            /// 当前时间
            let cmp2 = calender.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
            /// 格式化日期
            let formatter = DateFormatter()
            var isToday = false
            /// 今天
            if cmp1.day == cmp2.day {
                formatter.dateFormat = " HH:mm"
                isToday = true
            } else if cmp1.year == cmp2.year {
                /// 今年
                formatter.dateFormat = "MM-dd HH:mm"
            } else {
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
            }
            let timeStr = formatter.string(from: time)
            
            /// 显示日期
            let desc: String = isToday ? "今天" : ""
            return String(format: "%@%@%@", arguments: ["最后更新：", desc, timeStr])
        }
        return String(format: "%@%@", arguments: ["最后更新：", "无记录"])
    }
    lazy var lastUpdatedTimeLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .lightGray
        label.autoresizingMask = [.flexibleWidth]
        label.textAlignment = .center
        label.li.x = 0
        label.li.y = li.height * 0.5
        label.li.width = li.width
        label.li.height = li.height * 0.5
        addSubview(label)
        return label
    }()
    lazy var stateLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .lightGray
        label.autoresizingMask = [.flexibleWidth]
        label.textAlignment = .center
        label.li.x = 0
        label.li.y = 0
        label.li.width = li.width
        label.li.height = li.height * 0.5
        addSubview(label)
        return label
    }()
    /// 状态对应的问题
    open var stateTitles: [RefreshState: String] = [
        .idle: "下拉刷新",
        .pulling: "松开刷新",
        .refreshing: "刷新中"
    ]
    open override var state: RefreshState {
        willSet {
            stateLabel.text = stateTitles[newValue]
            if newValue == .idle {
                /// save
                lastUpdatedTimeLabel.text = lastUpdatedTimeString
                UserDefaults.standard.setValue(Date(), forKey: NSStringFromClass(Self.self))
                UserDefaults.standard.synchronize()
                didCompleteHideAnimation()
            } else if newValue == .refreshing {
                didBeginRefreshingState()
            }
        }
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        lastUpdatedTimeLabel.text = lastUpdatedTimeString
        setUpCircleLayer()
        setUpArrowLayer()
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open override func placeSubviews() {
        super.placeSubviews()
        //放置Views和Layer
        self.arrowLayer.position = CGPoint(x: (self.li.width - lastUpdatedTimeLabel.li.textWidth) * 0.5 - 40, y: self.frame.height/2)
        self.circleLayer.position = CGPoint(x: (self.li.width - lastUpdatedTimeLabel.li.textWidth) * 0.5 - 40, y: self.frame.height/2)
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
    
    func setUpArrowLayer(){
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 20, y: 15))
        bezierPath.addLine(to: CGPoint(x: 20, y: 25))
        bezierPath.addLine(to: CGPoint(x: 25,y: 20))
        bezierPath.move(to: CGPoint(x: 20, y: 25))
        bezierPath.addLine(to: CGPoint(x: 15, y: 20))
        self.arrowLayer.path = bezierPath.cgPath
        self.arrowLayer.strokeColor = UIColor.lightGray.cgColor
        self.arrowLayer.fillColor = UIColor.clear.cgColor
        self.arrowLayer.lineWidth = 1.0
        self.arrowLayer.lineCap = CAShapeLayerLineCap.round
        self.arrowLayer.bounds = CGRect(x: 0, y: 0,width: 40, height: 40)
        self.arrowLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.layer.addSublayer(self.arrowLayer)
    }
    
    func didBeginRefreshingState(){
        self.circleLayer.strokeEnd = 0.95
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.toValue = NSNumber(value: .pi * 2.0)
        rotateAnimation.duration = 0.6
        rotateAnimation.isCumulative = true
        rotateAnimation.repeatCount = 10000000
        self.circleLayer.add(rotateAnimation, forKey: "rotate")
        self.arrowLayer.isHidden = true
    }
    
    func didCompleteHideAnimation(){
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.circleLayer.strokeEnd = 0.05
        CATransaction.commit()
        
        self.circleLayer.removeAllAnimations()
        self.arrowLayer.isHidden = false
    }
}
