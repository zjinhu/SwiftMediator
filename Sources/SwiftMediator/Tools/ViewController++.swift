//
//  SwiftMediator+CurrentVC.swift
//  SwiftMediator
//
//  Created by iOS on 2023/5/25.
//

import UIKit
import Foundation

//MARK:--Get the top UIViewController
extension UIViewController {
    
    /// Get the top-level UINavigationController according to the window
    public static func currentNavigationController() -> UINavigationController? {
        currentViewController()?.navigationController
    }
    
    /// Get the top-level UIViewController according to the window
    public static func currentViewController() -> UIViewController? {
        
        let vc = UIWindow.keyWindow?.rootViewController
        return getCurrentViewController(withCurrentVC: vc)
    }
    
    ///Get the top-level controller recursively according to the controller
    private static func getCurrentViewController(withCurrentVC VC : UIViewController?) -> UIViewController? {
        
        if VC == nil {
            debugPrint("🌶： Could not find top level UIViewController")
            return nil
        }
        
        if let presentVC = VC?.presentedViewController {
            //modal出来的 控制器
            return getCurrentViewController(withCurrentVC: presentVC)
            
        }
        else
        if let splitVC = VC as? UISplitViewController {
            // UISplitViewController 的跟控制器
            if splitVC.viewControllers.isEmpty {
                return VC
            }else{
                return getCurrentViewController(withCurrentVC: splitVC.viewControllers.last)
            }
        }
        else
        if let tabVC = VC as? UITabBarController {
            // tabBar 的跟控制器
            if let _ = tabVC.viewControllers {
                return getCurrentViewController(withCurrentVC: tabVC.selectedViewController)
            }else{
                return VC
            }
        }
        else
        if let naiVC = VC as? UINavigationController {
            // 控制器是 nav
            if naiVC.viewControllers.isEmpty {
                return VC
            }else{
                //return getCurrentViewController(withCurrentVC: naiVC.topViewController)
                return getCurrentViewController(withCurrentVC:naiVC.visibleViewController)
            }
        }
        else
        {
            // 返回顶控制器
            return VC
        }
    }
}
