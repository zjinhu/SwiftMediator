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
    
    /// URL路由跳转 跳转区分Push、present、fullScreen
    /// - Parameter urlString:调用原生页面功能 scheme ://push/moduleName/vcName?quereyParams
    func openUrl(_ urlString: String?) {
        guard let url = URL.init(string: urlString!) else {
            return
        }
        if let scheme = url.scheme,
            (scheme == "http" || scheme == "https") {
            // Web View Controller
        }else{
            let path = url.path as String
            let startIndex = path.index(path.startIndex, offsetBy: 1)
            let pathArray = path.suffix(from: startIndex).components(separatedBy: "/")
            guard pathArray.count == 2 else {
                return
            }
            switch url.host {
            case "present":
                present(moduleName: pathArray.first!, toVC: pathArray.last!, paramsDic: url.queryDictionary)
            case "fullScreen":
                present(moduleName: pathArray.first!, toVC: pathArray.last!, paramsDic: url.queryDictionary, modelStyle: 1)
            default:
                push(moduleName: pathArray.first!, toVC: pathArray.last!, paramsDic: url.queryDictionary)
            }
        }
    }
    
    /// 原生路由Push
    /// - Parameters:
    ///   - fromVC: 从那个页面起跳--不传默认取最上层VC
    ///   - moduleName: 目标VC所在组件名称
    ///   - toVC: 目标VC名称
    ///   - paramsDic: 参数字典
    func push(fromVC: UIViewController? = nil, moduleName: String, toVC: String, paramsDic:[String:Any]? = nil) {
        guard let vc = initVC(moduleName: moduleName, vcName: toVC, dic: paramsDic) else { return }
        vc.hidesBottomBarWhenPushed = true
        if fromVC != nil {
            fromVC?.navigationController?.pushViewController(vc, animated: true)
        }else{
            currentNavigationController()?.pushViewController(vc, animated: true)
        }
    }
    
    /// 原生路由present
    /// - Parameters:
    ///   - fromVC: 从那个页面起跳--不传默认取最上层VC
    ///   - moduleName: 目标VC所在组件名称
    ///   - toVC: 目标VC名称
    ///   - paramsDic: 参数字典
    ///   - modelStyle: 0模态样式为默认，1是全屏模态。。。。。
    func present(fromVC: UIViewController? = nil, moduleName: String, toVC: String, paramsDic:[String:Any]? = nil,modelStyle: Int = 0) {
        guard let vc = initVC(moduleName: moduleName, vcName: toVC, dic: paramsDic) else { return }
        
        let nav = UINavigationController.init(rootViewController: vc)
        nav.navigationBar.backgroundColor = .white
        nav.navigationBar.barTintColor = .white
        nav.navigationBar.isTranslucent = false
        switch modelStyle {
        case 1:
            nav.modalPresentationStyle = .fullScreen
        default:
            if #available(iOS 13.0, *) {
                nav.modalPresentationStyle = .automatic
            } else {
                // Fallback on earlier versions
            }
        }
        if fromVC != nil {
            fromVC?.present(nav, animated: true, completion: nil)
        }else{
            currentViewController()?.present(nav, animated: true, completion: nil)
        }
    }
}

//MARK:--获取最上层视图
public extension SwiftMediator {
    
    /// 获取顶层Nav 根据window
    func currentNavigationController() -> (UINavigationController?) {
        return currentViewController()?.navigationController
    }
    
    /// 获取顶层VC 根据window
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
    
    ///根据控制器获取 顶层控制器 递归
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
                //                return getCurrentViewController(withCurrentVC: naiVC.topViewController)
                return getCurrentViewController(withCurrentVC:naiVC.visibleViewController)
            }else{
                return VC
            } 
        }
        else {
            // 返回顶控制器
            return VC
        }
    }
}
//MARK:--初始化对象--Swift
public extension SwiftMediator {
    
    /// 反射VC初始化并且赋值
    /// - Parameters:
    ///   - moduleName: 组件boundle名称
    ///   - vcName: VC名称
    ///   - dic: 参数字典//由于是KVC赋值，必须要在参数上标记@objc
    func initVC(moduleName: String, vcName: String, dic: [String : Any]? = nil) -> UIViewController?{
        let className = "\(moduleName).\(vcName)"
        let cls: AnyClass? = NSClassFromString(className)
        guard let vc = cls as? UIViewController.Type else {
            return nil
        }
        let controller = vc.init()
        setObjectParams(obj: controller, paramsDic: dic)
        return controller
    }
    
    /// 判断属性是否存在
    /// - Parameters:
    ///   - name: 属性名称
    ///   - obj: 目标对象
    private func getTypeOfProperty (_ name: String, obj:AnyObject) -> Bool{
        // 注意：obj是实例(对象)，如果是类，则无法获取其属性
        let morror = Mirror.init(reflecting: obj)
        let superMorror = Mirror.init(reflecting: obj).superclassMirror
        for (key,_) in morror.children {
            if key == name {
                return  true
            }
        }
        for (key,_) in superMorror!.children {
            if key == name {
                return  true
            }
        }
        return false
    }
    
    /// KVC给属性赋值
    /// - Parameters:
    ///   - obj: 目标对象
    ///   - paramsDic: 参数字典Key必须对应属性名
    private func setObjectParams(obj: AnyObject, paramsDic:[String:Any]?) {
        if let paramsDic = paramsDic {
            for (key,value) in paramsDic {
                if getTypeOfProperty(key, obj: obj){
                    obj.setValue(value, forKey: key)
                }
            }
        }
    }
    
}

//MARK:--URL获取query字典
extension URL {
    var queryDictionary: [String: Any]? {
        guard let query = self.query else { return nil}
        
        var queryStrings = [String: String]()
        for pair in query.components(separatedBy: "&") {
            
            let key = pair.components(separatedBy: "=")[0]
            
            let value = pair
                .components(separatedBy:"=")[1]
                .replacingOccurrences(of: "+", with: " ")
                .removingPercentEncoding ?? ""
            
            queryStrings[key] = value
        }
        return queryStrings
    }
}

//MARK:--路由跳转
public extension SwiftMediator {
    
    /// 路由调用类方法，仅支持单一参数或者无参数，样式：@objc class func qqqqq(_ name: String)
    /// - Parameters:
    ///   - moduleName: 组件名称
    ///   - objName: 类名称
    ///   - selName: 方法名
    ///   - param: 参数
    func callClassMethod(moduleName: String, objName: String, selName: String, param: Any? = nil ){
        let className = "\(moduleName).\(objName)"
        let cls: AnyClass? = NSClassFromString(className)

        let sel = NSSelectorFromString(selName)
        
        guard let method = class_getClassMethod(cls, sel) else {
            return
        }
        let imp = method_getImplementation(method)
        
        typealias Function = @convention(c) (AnyObject, Selector, Any?) -> Void
        let function = unsafeBitCast(imp, to: Function.self)
        return function(cls!, sel, param)
    }
}
