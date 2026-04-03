//
//  SwiftMediator+CurrentVC.swift
//  SwiftMediator
//
//  Created by iOS on 2023/5/25.
//
//  UIViewController 工具扩展 / UIViewController Utility Extension
//  提供获取顶层控制器和导航控制器的能力
//  Provides ability to get top-most view controller and navigation controller

import UIKit
import Foundation

//MARK:--获取顶层控制器 / Get Top-Most View Controller--Swift
extension UIViewController {
    
    /// 获取当前顶层的 UINavigationController / Get current top-most UINavigationController
    /// - Returns: 当前导航控制器 / Current navigation controller, or nil if not found
    public static func currentNavigationController() -> UINavigationController? {
        currentViewController()?.navigationController
    }
    
    /// 获取当前顶层的 UIViewController / Get current top-most UIViewController
    /// - Returns: 顶层视图控制器 / Top-most view controller, or nil if not found
    public static func currentViewController() -> UIViewController? {
        
        let vc = UIWindow.keyWindow?.rootViewController
        return getCurrentViewController(withCurrentVC: vc)
    }
    
    /// 递归获取顶层控制器 / Recursively get top-most view controller
    /// 支持处理 present、UISplitViewController、UITabBarController、UINavigationController / Supports present, UISplitViewController, UITabBarController, UINavigationController
    /// - Parameter VC: 当前控制器 / Current view controller
    /// - Returns: 顶层控制器 / Top-most view controller
    private static func getCurrentViewController(withCurrentVC VC : UIViewController?) -> UIViewController? {
        
        if VC == nil {
            debugPrint("🌶： Could not find top level UIViewController")
            return nil
        }
        
        if let presentVC = VC?.presentedViewController {
            // modal 出来的控制器 / Controller presented modally
            return getCurrentViewController(withCurrentVC: presentVC)
            
        }
        else
        if let splitVC = VC as? UISplitViewController {
            // UISplitViewController 的根控制器 / Root controller of UISplitViewController
            if splitVC.viewControllers.isEmpty {
                return VC
            }else{
                return getCurrentViewController(withCurrentVC: splitVC.viewControllers.last)
            }
        }
        else
        if let tabVC = VC as? UITabBarController {
            // tabBar 的根控制器 / Root controller of UITabBarController
            if let _ = tabVC.viewControllers {
                return getCurrentViewController(withCurrentVC: tabVC.selectedViewController)
            }else{
                return VC
            }
        }
        else
        if let naiVC = VC as? UINavigationController {
            // 控制器是导航控制器 / Controller is UINavigationController
            if naiVC.viewControllers.isEmpty {
                return VC
            }else{
                // 返回可见的控制器 / Return visible view controller
                return getCurrentViewController(withCurrentVC:naiVC.visibleViewController)
            }
        }
        else
        {
            // 返回顶层控制器 / Return top-most controller
            return VC
        }
    }
}
