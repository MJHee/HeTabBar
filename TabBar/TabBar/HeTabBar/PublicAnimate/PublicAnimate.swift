//
//  PublicAnimate.swift
//  TabBar
//
//  Created by MJHee on 2017/3/24.
//  Copyright © 2017年 MJBaby. All rights reserved.
//

import UIKit

let W = UIScreen.main.bounds.size.width
let H = UIScreen.main.bounds.size.height
let CenterPoint = CGPoint.init(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height - 38.347785)
let bl = UIScreen.main.bounds.size.width / 375

extension PublicAnimate {
    func RGBA (r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
        return UIColor(red: CGFloat(r / 255.0), green: CGFloat(g / 255.0), blue: CGFloat(b / 255.0), alpha: CGFloat(1.0))
    }
}


//通知点击按钮协议
protocol PublicAnimateDelegate {
    func didSelectBtnWithBtnTag(tag: NSInteger)
}

class PublicAnimate: UIView {
    //通知点击按钮代理人
    var delegate : PublicAnimateDelegate?
    
    var CenterBtn : UIButton! = nil
    lazy var BtnItem : NSMutableArray! = {
        let BtnItem = NSMutableArray()
        return BtnItem
    }()
    lazy var BtnItemTitle : NSMutableArray! = {
        let BtnItemTitle = NSMutableArray()
        return BtnItemTitle
    }()
    var rect : CGRect!
    
    //show view 
    class func standardPublishAnimate(view: UIView) -> PublicAnimate {
        let animateView = PublicAnimate()
        let keyWindow = UIApplication.shared.keyWindow
        keyWindow?.addSubview(animateView)
        var rect = animateView.convert(view.frame, from: view.superview)
        rect.origin.y += 5
        animateView.rect = rect
        
        //Add button
        animateView.CreateBtn(imageName: "post_animate_camera", title: "拍照", tag: 0)
        animateView.CreateBtn(imageName: "post_animate_album", title: "相册", tag: 1)
        animateView.CreateBtn(imageName: "post_animate_akey", title: "一键转卖", tag: 2)
        //Add center button
        animateView.CreateCenterBtn(imageName: "post_animate_add", tag: 3)
        //Do animation
        animateView.AnimateBegin()
        
        return animateView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        let blurEffect = UIBlurEffect.init(style: .dark)
        let visualEffectView = UIVisualEffectView.init(effect: blurEffect)
        visualEffectView.frame = self.bounds
        self.addSubview(visualEffectView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     *  creat button
     */
    func CreateBtn(imageName: String, title: String, tag: Int) {
        if self.BtnItem.count >= 3 {
            return
        }
        let btn = UIButton.init(frame: self.rect)
        btn.tag = tag
        btn.setImage(UIImage.init(named: imageName), for: .normal)
        btn.addTarget(self, action: #selector(BtnClick(btn:)), for: .touchUpInside)
        self.addSubview(btn)
        self.BtnItem.add(btn)
        self.BtnItemTitle.add(self.CenterBtnTitle(title: title))
    }
    
    /**
     *  CenterBtnTitle
     */
    func CenterBtnTitle(title: String) -> UILabel {
        let label = UILabel.init()
        label.textColor = self.RGBA(r: 240, g: 240, b: 240, a: 1)
        label.font = UIFont.systemFont(ofSize: 13.5 * bl)
        label.textAlignment = .center
        label.text = title
        self.addSubview(label)
        return label
    }
    
    /**
     *  creat center button
     */
    func CreateCenterBtn(imageName: String, tag: Int) {
        self.CenterBtn = UIButton.init(frame: self.rect)
        self.CenterBtn.setImage(UIImage.init(named: imageName), for: .normal)
        self.CenterBtn.addTarget(self, action: #selector(cancelAnimation), for: .touchUpInside)
        self.CenterBtn.tag = tag
        self.addSubview(self.CenterBtn)
    }
    
    /**
     *  remove view and notice the selectIndex
     */
    func removeView(btn: UIButton) {
        self.removeFromSuperview()
        self.delegate?.didSelectBtnWithBtnTag(tag: btn.tag)
    }
    
    /**
     *  click other space to cancle
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.cancelAnimation()
    }
    
    /**
     *  Do animation
     */
    func AnimateBegin() {
        UIView.animate(withDuration: 0.2, animations: { 
            self.CenterBtn.transform = CGAffineTransform(rotationAngle: (-(CGFloat)(M_PI_4)-(CGFloat)(M_LOG10E)))
        }) { (finish) in
            UIView.animate(withDuration: 0.15, animations: { 
                
                self.CenterBtn.transform = CGAffineTransform(rotationAngle: (-(CGFloat)(M_PI_4)+(CGFloat)(M_LOG10E)))
            }, completion: { (finish) in
                UIView.animate(withDuration: 0.15, animations: { 
                    
                    self.CenterBtn.transform = CGAffineTransform(rotationAngle: -(CGFloat)(M_PI_4))
                })
            })
        }
        
        var i = 0.0
        var k = 0
        
        for btn in self.BtnItem {
            let button = btn as! UIButton
            //rotation
            UIView.animate(withDuration: 0.7, delay: i * 0.14, usingSpringWithDamping: 0.46, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
                button.transform = CGAffineTransform(scaleX: 1.2734 * bl, y: 1.2734 * bl)
                button.center = CGPoint(x: (74 + CGFloat(i) * 113) * bl, y: self.frame.size.height - 165 * bl)
                i += 1
            }, completion: { (finish) in
                
            })
            let PI_2 = CGFloat(M_2_PI)
            let Log10 = CGFloat(M_LOG10E)
            //move
            UIView.animate(withDuration: 0.2, delay: i * 0.1, options: UIViewAnimationOptions(rawValue: 0), animations: {
                button.transform = CGAffineTransform(rotationAngle: -PI_2)
            }, completion: { (finish) in
                UIView.animate(withDuration: 0.15, delay: 0, options: UIViewAnimationOptions(rawValue: 0), animations: {
                    button.transform = CGAffineTransform(rotationAngle: (PI_2+Log10))
                    
                }, completion: { (finish) in
                    
                    UIView.animate(withDuration: 0.1, delay: 0, options: UIViewAnimationOptions(rawValue: 0), animations: {
                        button.transform = CGAffineTransform(rotationAngle: 0)
                    }, completion: { (finish) in
                        let lab = self.BtnItemTitle[k] as! UILabel
                        k += 1
                        lab.frame = CGRect(x: 0, y: 0, width: W / 3 - 30, height: 30)
                        lab.center = CGPoint(x: button.center.x, y: button.frame.maxY + 20)
                    })
                })
            })
        }
    }
    
    //MARK: - action
    func BtnClick(btn: UIButton) {
        print(btn.tag)
        self.delegate?.didSelectBtnWithBtnTag(tag: btn.tag)
        self.removeFromSuperview()
    }
    
    func cancelAnimation() {
        UIView.animate(withDuration: 0.15, animations: { 
           self.CenterBtn.transform = .identity
        }) { (finish) in
            let n = self.BtnItem.count
            for i in (0...(n - 1)).reversed() {
                let btn = self.BtnItem[i] as! UIButton
                UIButton.animate(withDuration: 0.25, delay: 0.1 * Double(n - i), options: .transitionCurlDown, animations: {
                    btn.center = CGPoint(x: W / 2, y: H - 43.052385)
                    btn.transform = CGAffineTransform(scaleX: 1, y: 1)
                    btn.transform = CGAffineTransform(rotationAngle: -(CGFloat)(M_PI_4))
                    let lab = self.BtnItemTitle[i] as! UILabel
                    lab.removeFromSuperview()
                }, completion: { (finish) in
                    btn.removeFromSuperview()
                    if 0 == i {
                        self.removeFromSuperview()
                    }
                })
                
            }
        }
    }
    
}
