//
//  SwiftMediator.swift
//  SwiftMediator
//
//  Created by iOS on 27/11/2019.
//  Copyright © 2019 狄烨 . All rights reserved.
//

import UIKit
//MARK:--单例--Swift
public class SwiftMediator {
    public static let shared = SwiftMediator()
}

//MARK:--初始化对象--Swift
extension SwiftMediator {
    
    /// 反射VC初始化并且赋值
    /// - Parameters:
    ///   - moduleName: 组件boundle名称，不传则为默认命名空间
    ///   - vcName: VC名称
    ///   - dic: 参数字典//由于是KVC赋值，必须要在参数上标记@objc
    @discardableResult
    public func initVC(_ vcName: String,
                       moduleName: String? = nil,
                       dic: [String : Any]? = nil) -> UIViewController?{
        
        var namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        if let name = moduleName {
            namespace = name
        }
        
        let className = "\(namespace).\(vcName)"
        let cls: AnyClass? = NSClassFromString(className)
        guard let vc = cls as? UIViewController.Type else {
            return nil
        }
        let controller = vc.init()
        setObjectParams(obj: controller, paramsDic: dic)
        return controller
    }
    
    /// 反射objc初始化并且赋值 继承NSObject
    /// - Parameters:
    ///   - objcName: objcName
    ///   - moduleName: moduleName
    ///   - dic: 参数字典//由于是KVC赋值，必须要在参数上标记@objc
    /// - Returns: objc
    @discardableResult
    public func initObjc(_ objcName: String,
                         moduleName: String? = nil,
                         dic: [String : Any]? = nil) -> NSObject?{
        
        var namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        if let name = moduleName {
            namespace = name
        }
        
        let className = "\(namespace).\(objcName)"
        let cls: AnyClass? = NSClassFromString(className)
        guard let ob = cls as? NSObject.Type else {
            return nil
        }
        let objc = ob.init()
        setObjectParams(obj: objc, paramsDic: dic)
        return objc
    }
}

//MARK:--检查属性--Swift
extension SwiftMediator {
    /// 判断属性是否存在
    /// - Parameters:
    ///   - name: 属性名称
    ///   - obj: 目标对象
    private func getTypeOfProperty (_ name: String, obj:AnyObject) -> Bool{
        // 注意：obj是实例(对象)，如果是类，则无法获取其属性
        let morror = Mirror(reflecting: obj)
        let superMorror = Mirror(reflecting: obj).superclassMirror
        
        for (key,_) in morror.children {
            if key == name {
                return  true
            }
        }
        
        guard let superM = superMorror else {
            return false
        }
        
        for (key,_) in superM.children {
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

//MARK:--路由跳转--代码跳转
extension SwiftMediator {
    /// 路由Push
    /// - Parameters:
    ///   - fromVC: 从那个页面起跳--不传默认取最上层VC
    ///   - moduleName: 目标VC所在组件名称
    ///   - vcName: 目标VC名称
    ///   - paramsDic: 参数字典
    ///   - animated: 是否有动画
    public func push(_ vcName: String,
                     moduleName: String? = nil,
                     fromVC: UIViewController? = nil,
                     paramsDic:[String:Any]? = nil,
                     animated: Bool = true) {
        guard let vc = initVC(vcName, moduleName: moduleName, dic: paramsDic) else { return }
        pushVC(animated: animated, vc: vc, fromVC: fromVC)
    }
    
    /// 简单Push,提前初始化好VC
    /// - Parameters:
    ///   - vc: 已初始化好的VC对象
    ///   - fromVC: 从哪个页面push,不传则路由选择最上层VC
    ///   - animated: 是否有动画
    public func push(_ vc: UIViewController?,
                     fromVC: UIViewController? = nil,
                     animated: Bool = true) {
        guard let vc = vc else { return }
        pushVC(animated: animated, vc: vc, fromVC: fromVC)
    }
    
    fileprivate func pushVC(animated: Bool,
                            vc: UIViewController,
                            fromVC: UIViewController? = nil){
        vc.hidesBottomBarWhenPushed = true
        guard let from = fromVC else {
            currentNavigationController()?.pushViewController(vc, animated: animated)
            return
        }
        from.navigationController?.pushViewController(vc, animated: animated)
    }
    
    /// 路由present
    /// - Parameters:
    ///   - fromVC: 从那个页面起跳--不传默认取最上层VC
    ///   - moduleName: 目标VC所在组件名称
    ///   - vcName: 目标VC名称
    ///   - paramsDic: 参数字典
    ///   - modelStyle: 0:模态样式为默认，1:全屏模态,2:custom
    ///   - needNav: 是否需要导航栏
    ///   - animated: 是否有动画
    public func present(_ vcName: String,
                        moduleName: String? = nil,
                        paramsDic:[String:Any]? = nil,
                        fromVC: UIViewController? = nil,
                        needNav: Bool = true,
                        modelStyle: Int = 0,
                        animated: Bool = true) {
        guard let vc = initVC(vcName, moduleName: moduleName, dic: paramsDic) else { return }
        presentVC(needNav: needNav, animated: animated, modelStyle: modelStyle, vc: vc)
        
    }
    
    /// 简单present,提前初始化好VC
    /// - Parameters:
    ///   - vc: 已初始化好的VC对象
    ///   - fromVC: 从哪个页面push,不传则路由选择最上层VC
    ///   - needNav: 是否需要导航栏
    ///   - modelStyle: 0:模态样式为默认，1:全屏模态,2:custom
    ///   - animated: 是否有动画
    public func present(_ vc: UIViewController?,
                        fromVC: UIViewController? = nil,
                        needNav: Bool = true,
                        modelStyle: Int = 0,
                        animated: Bool = true) {
        guard let vc = vc else { return }
        presentVC(needNav: needNav, animated: animated, modelStyle: modelStyle, vc: vc)
    }
    
    fileprivate func presentVC(needNav: Bool,
                               animated: Bool,
                               modelStyle: Int,
                               vc: UIViewController,
                               fromVC: UIViewController? = nil){
        var container = vc
        
        if needNav {
            let nav = UINavigationController(rootViewController: vc)
            container = nav
        }
        
        switch modelStyle {
        case 1:
            container.modalPresentationStyle = .fullScreen
        case 2:
            container.modalPresentationStyle = .custom
        default:
            if #available(iOS 13.0, *) {
                container.modalPresentationStyle = .automatic
            } else {
                container.modalPresentationStyle = .fullScreen
            }
        }
        
        guard let from = fromVC else {
            currentViewController()?.present(container, animated: animated, completion: nil)
            return
        }
        from.present(container, animated: animated, completion: nil)
    }
}

//MARK:--URL路由跳转--Swift
extension SwiftMediator {
    /// URL路由跳转 跳转区分Push、present、fullScreen
    /// - Parameter urlString:调用原生页面功能 scheme ://push/moduleName/vcName?quereyParams
    /// - 此处注意编进URL的字符串不能出现特殊字符,要进行URL编码,不支持quereyParams参数有url然后url里还有querey(如果非要URL带token这种情况拦截一下使用路由代码跳转)
    public func openUrl(_ urlString: String?) {
        guard let str = urlString, let url = URL(string: str) else { return }
        let path = url.path as String
        let startIndex = path.index(path.startIndex, offsetBy: 1)
        let pathArray = path.suffix(from: startIndex).components(separatedBy: "/")
        guard pathArray.count == 2 , let first = pathArray.first , let last = pathArray.last else { return }
        switch url.host {
        case "present":
            present(last, moduleName: first, paramsDic: url.queryDictionary)
        case "fullScreen":
            present(last, moduleName: first, paramsDic: url.queryDictionary, modelStyle: 1)
        default:
            push(last, moduleName: first, paramsDic: url.queryDictionary)
        }
    }
}

//MARK:--路由执行方法
extension SwiftMediator {
    /// 路由调用实例对象方法：必须标记@objc  例子： @objc class func qqqqq(_ name: String)
    /// - Parameters:
    ///   - objc: 初始化好的对象
    ///   - selName: 方法名
    ///   - param: 参数1
    ///   - otherParam: 参数2
    @discardableResult
    public func callObjcMethod(objc: AnyObject,
                               selName: String,
                               param: Any? = nil,
                               otherParam: Any? = nil ) -> Unmanaged<AnyObject>?{
        
        let sel = NSSelectorFromString(selName)
        guard let _ = class_getInstanceMethod(type(of: objc), sel) else {
            return nil
        }
        return objc.perform(sel, with: param, with: otherParam)
    }
    
    /// 路由调用类方法：必须标记@objc  例子：@objc  func qqqqq(_ name: String)
    /// - Parameters:
    ///   - moduleName: 组件名称
    ///   - className: 类名称
    ///   - selName: 方法名
    ///   - param: 参数1
    ///   - otherParam: 参数2
    @discardableResult
    public func callClassMethod(className: String,
                                selName: String,
                                moduleName: String? = nil,
                                param: Any? = nil,
                                otherParam: Any? = nil ) -> Unmanaged<AnyObject>?{
        
        var namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        if let name = moduleName {
            namespace = name
        }
        let className = "\(namespace).\(className)"
        guard let cls: AnyObject? = NSClassFromString(className) else {
            return nil
        }
        
        let sel = NSSelectorFromString(selName)
        guard let _ = class_getClassMethod(cls as? AnyClass, sel) else {
            return nil
        }
        
        return cls?.perform(sel, with: param, with: otherParam)
    }
    
    //    /// 路由调用类方法，仅支持单一参数或者无参数，样式：@objc class func qqqqq(_ name: String)
    //    /// - Parameters:
    //    ///   - moduleName: 组件名称
    //    ///   - objName: 类名称
    //    ///   - selName: 方法名
    //    ///   - param: 参数
    //    func callClassMethod(moduleName: String, objName: String, selName: String, param: Any? = nil ){
    //        let className = "\(moduleName).\(objName)"
    //        let cls: AnyClass? = NSClassFromString(className)
    //
    //        let sel = NSSelectorFromString(selName)
    //
    //        guard let method = class_getClassMethod(cls, sel) else {
    //            return
    //        }
    //        let imp = method_getImplementation(method)
    //
    //        typealias Function = @convention(c) (AnyObject, Selector, Any?) -> Void
    //        let function = unsafeBitCast(imp, to: Function.self)
    //        return function(cls!, sel, param)
    //    }
    
}

//MARK:--获取最上层视图
extension SwiftMediator {
    
    /// 获取顶层Nav 根据window
    public func currentNavigationController() -> UINavigationController? {
        return currentViewController()?.navigationController
    }
    
    /// 获取顶层VC 根据window
    public func currentViewController() -> UIViewController? {
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

//MARK:--获取对象所在的命名空间
public extension NSObject {
    func getModuleName() -> String{
        let name = type(of: self).description()
        guard let module : String = name.components(separatedBy: ".").first else {
            return Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        }
        return module
    }
}

//MARK:--URL获取query字典
extension URL {
    public var queryDictionary: [String: Any]? {
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
//MARK:--URL编解码
extension String {
    //将原始的url编码为合法的url
    func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed)
        return encodeUrlString ?? ""
    }
     
    //将编码后的url转换回原始的url
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
}
