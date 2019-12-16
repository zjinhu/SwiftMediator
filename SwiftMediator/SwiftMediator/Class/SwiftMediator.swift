//
//  SwiftMediator.swift
//  SwiftMediator
//
//  Created by iOS on 27/11/2019.
//  Copyright © 2019 狄烨 . All rights reserved.
//

import UIKit

open class SwiftMediator {
    public static let shared = SwiftMediator()
}

//MARK:--路由跳转
public extension SwiftMediator {
    func openUrl(url: URL) {
        if url.path.count > 0{
            
        }
    }
    
    
}

//MARK:--获取最上层视图
public extension SwiftMediator {
    
    // 获取顶层控制器 根据window
    func currentNavigationController() -> (UINavigationController?) {
        return currentViewController()?.navigationController
    }
    // 获取顶层控制器 根据window
    func currentViewController() -> (UIViewController?) {
        var window = UIApplication.shared.keyWindow
        //是否为当前显示的window
        if window?.windowLevel != UIWindow.Level.normal{
            let windows = UIApplication.shared.windows
            for  windowTemp in windows{
                if windowTemp.windowLevel == UIWindow.Level.normal{
                    window = windowTemp
                    break
                }
            }
        }
        let vc = window?.rootViewController
        return getCurrentViewController(withCurrentVC: vc)
    }
    
    ///根据控制器获取 顶层控制器
    private func getCurrentViewController(withCurrentVC VC :UIViewController?) -> UIViewController? {
        if VC == nil {
            print("🌶： 找不到顶层控制器")
            return nil
        }
        
        if let presentVC = VC?.presentedViewController {
            //modal出来的 控制器
            return getCurrentViewController(withCurrentVC: presentVC)
        }
        else if let splitVC = VC as? UISplitViewController {
            // UISplitViewController 的跟控制器
            if splitVC.viewControllers.count > 0 {
                return getCurrentViewController(withCurrentVC: splitVC.viewControllers.last)
            }else{
                return VC
            }
        }
        else if let tabVC = VC as? UITabBarController {
            // tabBar 的跟控制器
            if tabVC.viewControllers != nil {
                return getCurrentViewController(withCurrentVC: tabVC.selectedViewController)
            }else{
                return VC
            }
            
        }
        else if let naiVC = VC as? UINavigationController {
            // 控制器是 nav
            if naiVC.viewControllers.count > 0 {
                return getCurrentViewController(withCurrentVC: naiVC.topViewController)
            }else{
                return VC
            }
            //            return getCurrentViewController(withCurrentVC:naiVC.visibleViewController)
        }
        else {
            // 返回顶控制器
            return VC
        }
    }
}
//MARK:--初始化对象
public extension SwiftMediator {
    
    func initVC(vcName: String, dic: [String : Any]) -> UIViewController?{
        guard let className = objc_getClass(vcName) as? UIViewController.Type else {
            return nil
        }
        return className.init()
    }
    
    //MARK:-- 获取本类所有 ‘属性‘ 的数组
    func allProperties(cName: String) ->[String] {
        // 这个类型可以使用CUnsignedInt,对应Swift中的UInt32
        var count: UInt32 = 0
        
        let className = objc_getClass(cName) as! AnyClass.Type

        let properties = class_copyPropertyList(className, &count)
        
        var propertyNames: [String] = []
        
        // Swift中类型是严格检查的，必须转换成同一类型
        for index in 0...count-1 {
            // UnsafeMutablePointer<objc_property_t>是
            // 可变指针，因此properties就是类似数组一样，可以
            // 通过下标获取
            let property = properties![Int(index)]
            let name = property_getName(property)
            
            // 这里还得转换成字符串
            let strName = String.init(cString: name)
            propertyNames.append(strName);
        }
        
        // 不要忘记释放内存，否则C语言的指针很容易成野指针的
        free(properties)
        
        return propertyNames;
    }
    //MARK:-- 获取本类所有 ‘方法‘ 的数组
    func allMethods(cName: String) ->[Selector]{
        var count: UInt32 = 0
        let className = objc_getClass(cName) as! AnyClass.Type
        let methods = class_copyMethodList(className, &count)
        var methodNames: [Selector] = []
        for index in 0...count-1{
            let method = methods![Int(index)]
            let sel = method_getName(method)
            methodNames.append(sel);
            let methodName = sel_getName(sel)
            let argument = method_getNumberOfArguments(method)
            
            print("name: \(methodName), arguemtns: \(argument)")
        }
        free(methods)
        return methodNames
    }
    //MARK:-- 获取本类所有 ‘成员变量‘ 的数组
    func allMemberVariables(cName: String) ->[String] {
        var count:UInt32 = 0
        let className = objc_getClass(cName) as! AnyClass.Type
        let ivars = class_copyIvarList(className, &count)
        
        var result: [String] = []
        for index in 0...count-1{
            let ivar = ivars![Int(index)]
            
            let name = ivar_getName(ivar)
            
            let varName = String.init(cString: name!)
            result.append(varName)
        }
        free(ivars)
        return result
    }
    
}



