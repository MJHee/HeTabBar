//
//  ViewController2.swift
//  TabBar
//
//  Created by MJHee on 2017/3/23.
//  Copyright © 2017年 MJBaby. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imgView = UIImageView.init(frame: self.view.bounds)
        imgView.image = UIImage.init(named: "IMG_1101")
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        self.view.addSubview(imgView)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }


}
