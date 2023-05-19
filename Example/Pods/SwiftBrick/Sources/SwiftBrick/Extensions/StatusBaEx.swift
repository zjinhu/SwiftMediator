//
//  StatusBar.swift
//  SwiftBrick
//
//  Created by iOS on 2020/3/31.
//  Copyright © 2020 狄烨 . All rights reserved.
//

import UIKit
// MARK: ===================================扩展: UIStatusBar 展示 隐藏 更换Style=========================================
extension UINavigationController {
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
    
    open override var childForStatusBarHidden: UIViewController? {
        return topViewController
    }
}

extension UITabBarController {
    open override var childForStatusBarStyle: UIViewController? {
        return selectedViewController
    }
    
    open override var childForStatusBarHidden: UIViewController? {
        return selectedViewController
    }
}

fileprivate var kHiddenStatusBar: Int = 0x2020_00
fileprivate var kStyleStatusBar: Int = 0x2020_01

extension UIViewController {
    
    /// 设置信号栏是否隐藏,请在隐藏了导航栏的VC中使用,如果使用了Nav会失效
    public var setHiddenStatusBar: Bool {
        get {
            if let value = objc_getAssociatedObject(self, &kHiddenStatusBar) as? Bool {
                return value
            } else {
                return false
            }
        }
        set {
            objc_setAssociatedObject(self, &kHiddenStatusBar, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// 设置信号栏样式,请在隐藏了导航栏的VC中使用,如果使用了Nav会失效,需要self.navigationController.navigationBar.barStyle = .default
    public var setStyleStatusBar: UIStatusBarStyle {
        get {
            if let value = objc_getAssociatedObject(self, &kStyleStatusBar) as? UIStatusBarStyle {
                return value
            } else {
                return .default
            }
        }
        set {
            objc_setAssociatedObject(self, &kStyleStatusBar, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    /// 隐藏|显示状态栏,请在隐藏了导航栏的VC中使用,如果使用了Nav会失效
    /// - Parameter hidden: 隐藏|显示状态栏
    public func hideOrShowStatusBar(hidden: Bool = false) {
        
        setHiddenStatusBar = hidden
        setNeedsStatusBarAppearanceUpdate()
    }
    
    
    /// 动态设置信号栏样式,请在隐藏了导航栏的VC中使用,如果使用了Nav会失效,需要self.navigationController.navigationBar.barStyle = .default
    /// - Parameter style: 信号栏样式
    public func changeStatusBarStyle(style: UIStatusBarStyle = .default) {
        
        setStyleStatusBar = style
        setNeedsStatusBarAppearanceUpdate()
    }
}


/**例子： VC内添加
override var prefersStatusBarHidden: Bool {
    return self.setHiddenStatusBar
}

override var preferredStatusBarStyle: UIStatusBarStyle{
    return self.setStyleStatusBar
}
 然后相应的调用 changeStatusBarStyle(style: .darkContent)
 或者 hideOrShowStatusBar（hidden：true）即可，支持在view内控制信号栏，只需要找到最上层VC即可
 */
