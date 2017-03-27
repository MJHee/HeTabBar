//
//  HeBadgeView.swift
//  TabBar
//
//  Created by MJHee on 2017/3/23.
//  Copyright © 2017年 MJBaby. All rights reserved.
//

import UIKit

class HeBadgeView: UIButton {
    /** remind number */
    var badgeValue : String = "" {
        didSet {
            if badgeValue != oldValue {
                self.layoutIfNeeded()
            }
        }
    }
    /** remind color */
    var badgeColor : UIColor! = nil {
        didSet {
            if badgeColor != nil && badgeColor != oldValue {
                var image = UIImage.init(named: "main_badge")
                UIGraphicsBeginImageContextWithOptions((image?.size)!, false, 0)
                let ref = UIGraphicsGetCurrentContext()
                let rect = CGRect(x: 0, y: 0, width: (image?.size.width)!, height: (image?.size.height)!)
                ref!.clip(to: rect, mask: (image?.cgImage)!)
                badgeColor.setFill()
                ref!.fill(rect)
                image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                let width = (image?.size.width)! * 0.5
                let height = (image?.size.height)! * 0.5
                image = image?.stretchableImage(withLeftCapWidth: Int(width), topCapHeight: Int(height))
                self.setBackgroundImage(image, for: .normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = false
        self.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        
        //set protection of image area
        //var image = UIImage.init(named: "HeTabBar.bundle" + "main_badge@2x.png")
        var image = UIImage.init(named: "main_badge")
        let width : CGFloat = (image?.size.width)! * 0.5
        let height : CGFloat = (image?.size.height)! * 0.5
        image = image?.stretchableImage(withLeftCapWidth: Int(width), topCapHeight: Int(height))
        self.setBackgroundImage(image, for: .normal)
        
        //set text of alignment
        self.titleLabel?.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /**
         *  red dot remind
         */
        if self.badgeValue.isEqual("remind") {
            self.frame = CGRect(x: (self.superview?.frame.size.width)! / 2 + 7, y: 4, width: (self.currentBackgroundImage?.size.width)! / 2, height: (self.currentBackgroundImage?.size.height)! / 2)
            return
        }
        
        /**
         *  number remind
         */
        if (self.badgeValue as NSString).integerValue <= 0 {
            self.badgeValue = NSString() as String
            self.isHidden = true
            return
        }
        
        var n = 0
        self.isHidden = false
        if (self.badgeValue as NSString).integerValue > 999 {
            self.setTitle("···", for: .normal)
        }else {
            n = (self.badgeValue as NSString).integerValue > 9 ? 8 : 0
            self.setTitle(self.badgeValue as String, for: .normal)
        }
        
        let x = (self.superview?.frame.size.width)! / 2 + 5
        let width = Int((self.currentBackgroundImage?.size.width)!) + n
        let height = (self.currentBackgroundImage?.size.height)!
        self.frame = CGRect(x: Int(x), y: 1, width: width, height: Int(height))
    }
    
}
