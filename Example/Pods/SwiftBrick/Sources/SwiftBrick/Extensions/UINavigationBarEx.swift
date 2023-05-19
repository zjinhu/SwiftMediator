//
//  UINavigationBarEx.swift
//  SwiftBrick
//
//  Created by iOS on 2020/9/4.
//  Copyright © 2020 狄烨 . All rights reserved.
//

import UIKit
// MARK: ===================================扩展: UINavigationBar 背景色 分割线=========================================
public extension UINavigationBar {
    
    fileprivate struct AssociatedKeys {
        static var OverlayKey = "overlayKey"
    }
    
    fileprivate var overlay: UIView? {
        
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.OverlayKey) as? UIView
        }
        
        set {
            if let newValue = newValue {
                objc_setAssociatedObject( self, &AssociatedKeys.OverlayKey, newValue as UIView?, .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
    
    /// 设置导航栏背景色
    /// - Parameter color: 颜色
    func setBackgroundColor(_ color: UIColor) {
        
        if overlay == nil {
            setBackgroundImage(UIImage(), for: .default)
            overlay = UIView(frame: CGRect(x: 0, y: -SwiftBrick.Define.statusBarHeight(), width: self.bounds.width, height: self.bounds.height + SwiftBrick.Define.statusBarHeight() ))
            overlay?.isUserInteractionEnabled = false
            overlay?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            overlay?.layer.zPosition = -9999
            insertSubview(overlay!, at: 0)
        }
        
        overlay?.backgroundColor = color
    }
    
    func setTranslationY(_ translation: CGFloat) {
        transform  = CGAffineTransform(translationX: 0, y: translation)
    }
    
    func setAlphaElements(_ alpha: CGFloat) {
        self.alpha = alpha
        _ = subviews.map { (subView)  in
            subView.alpha = alpha
        }
    }
    
    func reset() {
        setBackgroundImage(nil, for: .default)
        overlay?.removeFromSuperview()
        overlay = nil
    }
    
    /// 隐藏/展示分割线
    /// - Parameter hidden: true/false
    func setLineHidden(hidden: Bool) {
        if let shadowImg = seekLineImageView(view: self) {
            shadowImg.isHidden = hidden
        }
    }
    
    fileprivate func seekLineImageView(view: UIView) -> UIImageView? {
        if view is UIImageView && view.bounds.size.height <= 1 {
            return (view as! UIImageView)
        }

        for subview in view.subviews {
            if let imageView = seekLineImageView(view: subview) {
                return imageView
            }
        }
        return nil
    }

}
