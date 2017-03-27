//
//  HeTabBarController.swift
//  TabBar
//
//  Created by MJHee on 2017/3/23.
//  Copyright © 2017年 MJBaby. All rights reserved.
//

import UIKit
/**
 *  READNE
 
 *  中间按钮可以 设置为 [控制器 或 普通触发事件的按钮]     
 *  ----> 只需要设置为普通按钮的话，Controller传入nil即可
 
 
 *  中间按钮可以 设置为 [圆形凸出 或 普通]
 *  ----> 圆形凸出 bulge传入YES  普通 bulge传入NO
 
 
 *  如果你只是想小红点提醒用户
 *  ----> 可以设置控制器的 tabBarItem.badgeValue 为remind
 *  ----> Controller.tabBarItem.badgeValue = @"remind";
 

 *  如果你想以数字提醒用户
 *  ----> 可以设置控制器的 tabBarItem.badgeValue 为字符串
 *  ----> Controller.tabBarItem.badgeValue = @"100";
 
 
 *  如果你想切换控制器
 *  ----> 可以设置控制器的 selectedIndex 为数字
 *  ----> tabBarController.selectedIndex = x(索引为添加控制器时的顺序);
 

 *  如果你想改变提醒背景颜色
 *  ----> 可以设置控制器的 tabBarItem.badgeColor 为一个颜色
 *  ----> Controller.tabBarItem.badgeColor = [UIColor xxxColor];
 */
 
class HeTabBarController: UITabBarController {
    
    /** center button of place ( -1:none center button >=0:contain center button) */
    var centerPlace : NSInteger! = 0
    /** Whether center button to bulge */
    var bulge: Bool! = false
    /** items */
    fileprivate lazy var items = { () -> NSMutableArray in 
        let item = NSMutableArray()
        return item
    }()
    
    fileprivate var tabBarItemTag : Int = 0
    
    fileprivate var firstInit : Bool! = false
    
    open var selectIndex: Int = 0 {
        didSet {
            if selectIndex >= (self.viewControllers?.count)! {
                NSException.init(name: NSExceptionName(rawValue: "selectedTabbarError"), reason: "Don't have the controller can be used, index beyond the viewControllers.", userInfo: nil)
            }
            
            self.selectedIndex = self.selectIndex
            
            let viewController = self.findViewController(object: (self.viewControllers?[selectIndex])! as UIViewController)
            self.tabbar.removeFromSuperview()
            viewController.view.addSubview(self.tabbar)
        }
    }
    
    /** 自定义的tabbar */
    lazy var tabbar : CustomTabBar! = {
        let tabbar : CustomTabBar = CustomTabBar.init(frame: self.tabBar.frame)
        tabbar.bulge = self.bulge!
        tabbar.setValue(self, forKey: "controller")
        tabbar.centerPlace = self.centerPlace!
        tabbar.items = self.items
        
        //remove tabBar
        for loop in self.tabBar.subviews {
            let view : UIView = loop
            view.removeFromSuperview()
        }
        self.tabBar.isHidden = true
        self.tabBar.removeFromSuperview()
        
        return tabbar
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.centerPlace = -1
    }
    
    //MARK: - 初始化
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if firstInit == false {
            firstInit = true
            
            if self.centerPlace != -1 && (self.items[self.centerPlace] as! UITabBarItem).tag != -1 {
                self.selectIndex = self.centerPlace
            }else {
                self.selectIndex = 0
            }
            self.tabbar.setSelectButtonIndex(index: self.selectIndex)
            //self.tabbar.setValue(NSNumber(value: self.selectedIndex), forKey: "selectButtoIndex")
        }
    }
    
    /**
     * 添加子控制器
     * @param Controller          需管理的子控制器
     * @param title               底部文字
     * @param imageName           未选中的图片名
     * @param selectedImageName   选中的图片名
     */
    func addChildController(vc: Any, title: String, imageName: String, selectedImageName: String) {
        let VC : UIViewController = self.findViewController(object: vc)
        VC.tabBarItem.title = title
        VC.tabBarItem.image = UIImage.init(named: imageName)
        VC.tabBarItem.selectedImage = UIImage.init(named: selectedImageName)
        tabBarItemTag += 1
        VC.tabBarItem.tag = tabBarItemTag
        self.items.add(VC.tabBarItem)
        self.addChildViewController(vc as! UIViewController)
		
    }
    
    /**
     * 设置中间按钮
     * @param Controller          需管理的子控制器
     * @param title               底部文字
     * @param imageName           未选中的图片名
     * @param selectedImageName   选中的图片名
     */
    func addCenterController(vc: Any?, bulge: Bool, title: String, imageName: String, selectedImageName: String) {
        self.bulge = bulge
        if vc != nil {
            self.addChildController(vc: vc as Any, title: title, imageName: imageName, selectedImageName: selectedImageName)
            self.centerPlace = tabBarItemTag - 1
        }else {
            let item = UITabBarItem.init(title: title, image: UIImage.init(named: imageName), selectedImage: UIImage.init(named: selectedImageName))
            item.tag = -1
            self.items.add(item)
            self.centerPlace = tabBarItemTag
        }
    }
    
    /**
     *  Catch viewController
     */
    func findViewController(object: Any) -> UIViewController {
        var vc : UIViewController!
        vc = object as! UIViewController
        
        while object is UITabBarController || object is UINavigationController {
            let obj = object as! UITabBarController
            vc = obj.viewControllers?.first
        }
        return vc!
    }

}
