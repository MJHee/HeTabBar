//
//  HeCenterButton.swift
//  TabBar
//
//  Created by MJHee on 2017/3/23.
//  Copyright © 2017年 MJBaby. All rights reserved.
//

import UIKit

let BULGEH : CGFloat = 16 //button bulge of height

class HeCenterButton: UIButton {

    var bulge : Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        self.titleLabel?.textAlignment = .center
        self.adjustsImageWhenHighlighted = false
        self.imageView?.contentMode = .center
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.frame.equalTo(CGRect.zero) {
            return
        }
        
        let width = self.frame.size.width
        let height = self.frame.size.height
        /**
         *  button is bulge
         */
         if self.bulge {
            self.imageView?.frame = self.bounds
            if ((self.titleLabel?.text?.lengthOfBytes(using: String.Encoding.utf8)) != nil) {
                self.titleLabel?.frame = CGRect(x: 0, y: height + (BULGEH - 16), width: width, height: 16)
            }
            return
         }
        /**
         *  button is normal and no text
         */
         if ((self.titleLabel?.text?.lengthOfBytes(using: String.Encoding.utf8)) != nil) {
            self.imageView?.frame = self.bounds
            return
        }
        /**
         *  button is normal and contain text
         */
        self.titleLabel?.frame = CGRect(x: 0, y: height - BULGEH, width: width, height: BULGEH)
        self.imageView?.frame = CGRect(x: 0, y: 0, width: width, height: 35)
    }

}
