//
//  CustomTabBar.swift
//  TabBar
//
//  Created by MJHee on 2017/3/23.
//  Copyright © 2017年 MJBaby. All rights reserved.
//

import UIKit

class CustomTabBar: UIView {
    /** tabbar按钮显示信息 */
    var items = NSMutableArray() {
        didSet {
            for i in 0..<items.count {
                let item : UITabBarItem = items[i] as! UITabBarItem
                var btn = UIButton()
                if -1 != self.centerPlace && i == self.centerPlace {
                    self.centerBtn = HeCenterButton()
                    self.centerBtn.adjustsImageWhenHighlighted = false
                    self.centerBtn.bulge = self.bulge
                    btn = self.centerBtn
                    if -1 == item.tag {
                        btn.addTarget(self, action: #selector(CustomTabBar.centerBtnClick(btn:)), for: .touchUpInside)
                    }else {
                        btn.addTarget(self, action: #selector(CustomTabBar.controlBtnClick(btn:)), for: .touchUpInside)
                    }
                }else {
                    btn = HeButton()
                    item.addObserver(self, forKeyPath: "badgeValue", options: .new, context: UnsafeMutableRawPointer(bitPattern: btn.hash))
                    item.addObserver(self, forKeyPath: "badgeColor", options: .new, context: UnsafeMutableRawPointer(bitPattern: btn.hash))
                    self.btnArr.add(btn)
                    btn.addTarget(self, action: #selector(controlBtnClick(btn:)), for: .touchUpInside)
                }
                //set image
                btn.setImage(item.image, for: .normal)
                btn.setImage(item.selectedImage, for: .selected)
                btn.adjustsImageWhenHighlighted = false
                
                //set title
                btn.setTitle(item.title, for: .normal)
                btn.setTitleColor(UIColor.init(colorLiteralRed: 113 / 255.0, green: 109 / 255.0, blue: 104 / 255.0, alpha: 1.0), for: .normal)
                btn.setTitleColor(UIColor.init(colorLiteralRed: 113 / 255.0, green: 109 / 255.0, blue: 104 / 255.0, alpha: 1.0), for: .selected)
                btn.tag = item.tag
                self.addSubview(btn)
            }
        }
    }
    /** 设置文字颜色 */
    var textColor: UIColor! {
        didSet {
            for loop in self.btnArr {
                (loop as! UIButton).setTitleColor(textColor, for: .normal)
            }
        }
    }
    /** 设置选中颜色 */
    var selectedTextColor : UIColor! {
        didSet {
            for loop in self.btnArr {
                (loop as! UIButton).setTitleColor(selectedTextColor, for: .selected)
            }
        }
    }
    /** 其他按钮 */
    var btnArr : NSMutableArray! = nil
    /** 中间按钮 */
    var centerBtn : HeCenterButton! = nil
    
    /** selctButton */
    fileprivate var selButton : HeButton! {
        didSet {
            selButton.isSelected = true
        }
    }
    /** center button of place */
    var centerPlace : NSInteger! = 0
    /** Whether center button to bulge */
    var bulge : Bool! = false
    /** tabBarController */
    var controller : UITabBarController! = nil
    /** border */
    lazy var border : CAShapeLayer = {
        let bord = CAShapeLayer()
        bord.fillColor = UIColor.init(colorLiteralRed: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0).cgColor
        let width : CGFloat = self.bounds.size.width
        let path = UIBezierPath.init(rect: CGRect(x: 0, y: 0, width: width, height: 0.5))
        bord.path = path.cgPath
        self.layer.insertSublayer(bord, at: 0)
        
        return bord
    }()
    
    override func setValue(_ value: Any?, forKey key: String) {
        print("Key \(key) \(value!)")
        super.setValue(value!, forKey: key)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.btnArr = NSMutableArray()
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /**
     *  layout
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let count = (self.centerBtn != nil) ? self.btnArr.count + 1 : self.btnArr.count
        let mid = count / 2
        var rect = CGRect(x: 0, y: 0, width: Int(self.bounds.size.width) / count, height: Int(self.bounds.size.height))
        
        var j = 0
        
        for i in 0..<count {
            if i == mid && self.centerBtn != nil {
                let item = self.items[self.centerPlace] as! UITabBarItem
                let h = (item.title != nil) ? 10 : 0
                let radius = CGFloat(10)
                let width = rect.size.width
                let height = rect.size.height
                if self.bulge == true {
                    self.centerBtn.frame = CGRect(x: rect.origin.x + (width - height - radius) / 2, y: -BULGEH - CGFloat(h), width: height + radius, height: height + radius)
                }else {
                    self.centerBtn.frame = rect
                }
            }else {
                let btn = self.btnArr[j] as! HeButton
                btn.frame = rect
                j += 1
            }
            rect.origin.x += rect.size.width
        }
        self.border.path = UIBezierPath.init(rect: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: 1)).cgPath
    }
    
    /**
     *  Observe the attribute value change
     */
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "badgeValue" || keyPath == "badgeColor" {
            let btn = context as! HeButton
            btn.item = object as! UITabBarItem
        }
    }
    
    /**
     *  Remove observer
     */
    deinit {
        print("deinit")
        for i in 0..<self.btnArr.count {
            var n = 0
            if -1 != self.centerPlace {
                n = self.centerPlace > i ? 0 : 1
            }
            n += i
            let index = n
            
            let btn = self.btnArr[i] as! UIButton
            
            (self.items[index] as! UITabBarItem).removeObserver(self, forKeyPath: "badgeValue", context: UnsafeMutableRawPointer(bitPattern: btn.hash))
            (self.items[index] as! UITabBarItem).removeObserver(self, forKeyPath: "badgeColor", context: UnsafeMutableRawPointer(bitPattern: btn.hash))
        }
    }
    
    //MARK: - action
    /**
     *  Pass events for center button
     */
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let rect = self.centerBtn.frame
        if rect.contains(point) {
            return self.centerBtn
        }else {
            return super.hitTest(point, with: event)
        }
    }
    
    @objc func controlBtnClick(btn : HeButton) {
        let vc = self.controller as! HeTabBarController
        vc.selectIndex = btn.tag - 1
        self.setSelectButtonIndex(index: btn.tag)
    }
    
    @objc func setSelectButtonIndex(index: NSInteger) {
        
        for loop in self.btnArr {
            if (loop as! HeButton).tag == (index + 1) {
                if self.selButton != nil {
                    self.selButton.isSelected = false
                }
                self.selButton = loop as! HeButton
                return
            }
        }
        if index == self.centerBtn.tag {
            let button = self.centerBtn as UIButton
            if self.selButton != nil {
                self.selButton.isSelected = false
            }
            self.selButton = button as! HeButton
        }
    }
    
    @objc func centerBtnClick(btn : HeCenterButton) {
        print("CustomTabBar.m  141行 CenterBtnClick")
        
        PublicAnimate.standardPublishAnimate(view: btn as UIView)
    }
    
    
}
