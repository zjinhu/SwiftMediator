//
//  UITabBarEx.swift
//  SwiftBrick
//
//  Created by iOS on 2020/4/26.
//  Copyright © 2020 狄烨 . All rights reserved.
//

import Foundation
import UIKit
// MARK: ===================================扩展: UITabBar=========================================
public extension UITabBar {
    
    fileprivate struct AssociatedKeys {
        static var kBadgeSize: String = "kBadgeSize"
        static var kBadgeColor: String = "kBadgeColor"
        static var kBadgeImage: String = "kBadgeImage"
        static var kBadgePoint: String = "kBadgePoint"
        static var kBadgeValue: String = "kBadgeValue"
    }
    
    fileprivate var badgeTag: Int {
        return 1000
    }
    
    // 小红点size
    var badgeSize: CGSize {
        get{
            if let size = objc_getAssociatedObject(self, &AssociatedKeys.kBadgeSize) as? CGSize {
                return size
            } else {
                return CGSize.zero
            }
        }
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.kBadgeSize, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // 小红点图片
    var badgeImage: UIImage? {
        get{
            if let image = objc_getAssociatedObject(self, &AssociatedKeys.kBadgeImage) as? UIImage {
                return image
            } else {
                return UIImage()
            }
        }
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.kBadgeImage, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // 小红点颜色
    var badgeColor: UIColor {
        get{
            if let color = objc_getAssociatedObject(self, &AssociatedKeys.kBadgeColor) as? UIColor {
                return color
            } else {
                return .red
            }
        }
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.kBadgeColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // 小红点的x、y值
    var badgePoint: CGPoint {
        get{
            if let point = objc_getAssociatedObject(self, &AssociatedKeys.kBadgePoint) as? CGPoint {
                return point
            } else {
                return CGPoint.zero
            }
        }
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.kBadgePoint, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // 小红点的数字
    var badgeValue: Int {
        get{
            if let num = objc_getAssociatedObject(self, &AssociatedKeys.kBadgeValue) as? Int{
                return num
            } else {
                return 0
            }
        }
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.kBadgeValue, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    
    // MARK:-显示小红点
    func showBadgeOnItemIndex(index:Int){
        // 移除
        removeRedPointOnIndex(index: index, animation: false)
        
        // 小红点背景默认值大小设置
        if __CGSizeEqualToSize(badgeSize, CGSize.zero) {
            badgeSize = CGSize(width: 10, height: 10)
        }
        
        
        let badgeView = UIView()
        badgeView.backgroundColor = badgeColor
        badgeView.layer.cornerRadius = badgeSize.width / 2
        badgeView.tag = badgeTag + 1
        
        let barButtonView = getBarButttonViewWithIndex(index: index)
        
        //（图片的imageView）
        var iconView = UIView()
        for swappableImageView in barButtonView.subviews {
            if swappableImageView.isKind(of: UIImageView.self) {
                iconView = swappableImageView
                break
            }
        }
        
        // 小红点背景默认值Point设置
        if __CGPointEqualToPoint(badgePoint, CGPoint.zero) {
            let iconViewSize = iconView.frame.size
            badgeView.frame = CGRect(x: iconViewSize.width - badgeSize.width / 2, y: -badgeSize.width / 2, width: badgeSize.width, height: badgeSize.height)
        }else{
            badgeView.frame = CGRect(x: badgePoint.x, y: badgePoint.y, width: badgeSize.width, height: badgeSize.height)
        }
        
        // 添加图片到小红点上
        let imageview = UIImageView(frame: badgeView.bounds)
        imageview.clipsToBounds = true
        imageview.contentMode = .scaleAspectFill
        imageview.image = badgeImage
        badgeView.addSubview(imageview)
        
        if badgeValue > 0 {
            let badgeLabel = UILabel(frame: badgeView.bounds)
            badgeLabel.text = badgeValue <= 99 ? "\(badgeValue)": "\(99)"
            badgeLabel.textAlignment = .center
            badgeLabel.adjustsFontSizeToFitWidth = true
            badgeLabel.minimumScaleFactor = 0.1
            badgeLabel.font = UIFont.systemFont(ofSize: 11)
            badgeLabel.textColor = UIColor.white
            badgeView.addSubview(badgeLabel)
        }
        
        iconView.addSubview(badgeView)
    }
    
    // MARK:-隐藏小红点
    func hiddenRedPointOnIndex(index:Int, animation:Bool){
        removeRedPointOnIndex(index: index, animation: animation)
    }
    
    fileprivate func removeRedPointOnIndex(index:Int, animation:Bool) {
        let barButtonView = getBarButttonViewWithIndex(index: index)
        
        for swapView in barButtonView.subviews {
            
            if swapView.isKind(of: UIImageView.self) {
                
                for view1 in swapView.subviews {
                    
                    if view1.tag == (badgeTag + 1) {
                        
                        if animation {
                            UIView.animate(withDuration: 0.2, animations: {
                                view1.transform = CGAffineTransform(translationX: 2, y: 2)
                                view1.alpha = 0
                            }) { (finished) in
                                view1.removeFromSuperview()
                            }
                        }else{
                            view1.removeFromSuperview()
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    // 获取barButtonView
    fileprivate func getBarButttonViewWithIndex(index:Int) -> UIView {
        
        if let itemss = items {
            let item = itemss[index]
            let barButtonView = item.value(forKey: "view")
            return barButtonView as! UIView
        }
        
        let vw = UIView()
        return vw
    }
}
