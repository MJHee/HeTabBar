//
//  HeButton.swift
//  TabBar
//
//  Created by MJHee on 2017/3/23.
//  Copyright © 2017年 MJBaby. All rights reserved.
//

import UIKit

class HeButton: UIButton {

    var item : UITabBarItem! = nil {
        didSet {
            self.badgeView.badgeValue = item.badgeValue!
            self.badgeView.badgeColor = item.badgeColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        self.titleLabel?.textAlignment = .center
        self.adjustsImageWhenHighlighted = false
        self.imageView?.contentMode = .center
        
        self.addSubview(self.badgeView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = self.frame.size.width
        let height = self.superview?.frame.size.height
        if width != 0 && height != 0 {
            self.titleLabel?.frame = CGRect(x: 0, y: height! - 16, width: width, height: 16)
            self.imageView?.frame = CGRect(x: 0, y: 0, width: width, height: 35)
        }
    }
    
    /** remind number */
    lazy var badgeView : HeBadgeView = {
        
        let badgeView = HeBadgeView()
        return badgeView
    }()

}
