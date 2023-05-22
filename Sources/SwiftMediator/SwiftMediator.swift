//MARK:--initialize object--Swift//
//  SwiftMediator.swift
//  SwiftMediator
//
//  Created by iOS on 27/11/2019.
//  Copyright © 2019 狄烨 . All rights reserved.
//

import UIKit
public class SwiftMediator {
    public static let shared = SwiftMediator()
    private init(){ }
}

//MARK:--initialize object--Swift
extension SwiftMediator {
    
    /// Reflect UIViewController initialization and assignment
    /// - Parameters:
    /// - moduleName: component boundle name, if not passed, it will be the default namespace
    /// - vcName: UIViewController name
    /// - dic: parameter dictionary // Since it is a KVC assignment, @objc must be marked on the parameter
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
    
    /// Reflect objc initialization and assignment Inherit NSObject
    /// - Parameters:
    /// - objcName: objcName
    /// - moduleName: moduleName
    /// - dic: parameter dictionary // Since it is a KVC assignment, @objc must be marked on the parameter
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

//MARK:--Inspect property--Swift
extension SwiftMediator {
    /// Determine whether the attribute exists
    /// - Parameters:
    /// - name: attribute name
    /// - obj: target object
    private func getTypeOfProperty (_ name: String, obj:AnyObject) -> Bool{
        // Note: obj is an instance (object), if it is a class, its properties cannot be obtained
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
    
    /// KVC assigns values to attributes
    /// - Parameters:
    /// - obj: target object
    /// - paramsDic: The parameter dictionary Key must correspond to the attribute name
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

//MARK:--route jump--code jump
extension SwiftMediator {
    /// Routing Push
    /// - Parameters:
    /// - fromVC: Jump from that page--if not passed, the top VC is taken by default
    /// - moduleName: The name of the component where the target VC is located
    /// - vcName: target VC name
    /// - paramsDic: parameter dictionary
    /// - animated: whether there is animation
    public func push(_ vcName: String,
                     moduleName: String? = nil,
                     fromVC: UIViewController? = nil,
                     paramsDic:[String:Any]? = nil,
                     animated: Bool = true) {
        
        guard let vc = initVC(vcName, moduleName: moduleName, dic: paramsDic) else { return }
        pushVC(animated: animated, vc: vc, fromVC: fromVC)
    }
    
    /// Simple Push, initialize VC in advance
    /// - Parameters:
    /// - vc: initialized VC object
    /// - fromVC: From which page to push, if not, the route selects the top VC
    /// - animated: whether there is animation
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
    
    /// route present
    /// - Parameters:
    /// - fromVC: Jump from that page--if not passed, the top VC is taken by default
    /// - moduleName: The name of the component where the target VC is located
    /// - vcName: target VC name
    /// - paramsDic: parameter dictionary
    /// - modelStyle: 0: modal style is default, 1: full screen modal, 2: custom
    /// - needNav: Do you need a navigation bar (native navigation bar, if you need a custom navigation bar, please directly pass the corresponding VC object with navigation bar)
    /// - animated: whether there is animation
    public func present(_ vcName: String,
                        moduleName: String? = nil,
                        paramsDic:[String:Any]? = nil,
                        fromVC: UIViewController? = nil,
                        needNav: Bool = false,
                        modelStyle: Int = 0,
                        animated: Bool = true) {
        
        guard let vc = initVC(vcName, moduleName: moduleName, dic: paramsDic) else { return }
        presentVC(needNav: needNav, animated: animated, modelStyle: modelStyle, vc: vc)
        
    }
    
    /// Simple present, initialize VC in advance
    /// - Parameters:
    /// - vc: initialized VC object, can pass Nav object (custom navigation bar)
    /// - fromVC: From which page to push, if not, the route selects the top VC
    /// - needNav: Do you need a navigation bar (native navigation bar, if you need a custom navigation bar, please directly pass the corresponding VC object with navigation bar)
    /// - modelStyle: 0: modal style is default, 1: full screen modal, 2: custom
    /// - animated: whether there is animation
    public func present(_ vc: UIViewController?,
                        fromVC: UIViewController? = nil,
                        needNav: Bool = false,
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
    
    /// Exit the current page
    public func dismissVC() {
        let current = currentViewController()
        if let viewControllers: [UIViewController] = current?.navigationController?.viewControllers {
            guard viewControllers.count <= 1 else {
                current?.navigationController?.popViewController(animated: true)
                return
            }
        }
        
        if let _ = current?.presentingViewController {
            current?.dismiss(animated: true, completion: nil)
        }
    }
}

//MARK:--URL routing jump--Swift
extension SwiftMediator {
    /// URL routing jump Jump to distinguish Push, present, fullScreen
    /// - Parameter urlString: Call native page function scheme ://push/moduleName/vcName?quereyParams
    /// - Note here that the string encoded into the URL cannot contain special characters. URL encoding is required. It does not support the queryParams parameter with url and query in the url (if you want the URL to have a token, intercept it and use the routing code jump)
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

//MARK:--routing execution method ///Swift reflection execution function has limited functions, OC method can pass block parameters (see https://github.com/jackiehu/JHMediator for OC routing middleware)
extension SwiftMediator {
    /// Routing call instance object method: @objc must be marked Example: @objc class func qqqqq(_ name: String)
    /// - Parameters:
    /// - objc: initialized object
    /// - selName: method name
    /// - param: parameter 1
    /// - otherParam: parameter 2
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
    
    /// Routing call class method: @objc must be marked Example: @objc func qqqqq(_ name: String)
    /// - Parameters:
    /// - moduleName: component name
    /// - className: class name
    /// - selName: method name
    /// - param: parameter 1
    /// - otherParam: parameter 2
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

//MARK:--Get the top UIViewController
extension SwiftMediator {
    
    /// Get the top-level UINavigationController according to the window
    public func currentNavigationController() -> UINavigationController? {
        currentViewController()?.navigationController
    }
    
    /// Get the top-level UIViewController according to the window
    public func currentViewController() -> UIViewController? {
        
        let vc = UIWindow.keyWindow?.rootViewController
        return getCurrentViewController(withCurrentVC: vc)
    }
    
    ///Get the top-level controller recursively according to the controller
    private func getCurrentViewController(withCurrentVC VC : UIViewController?) -> UIViewController? {
        
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


extension UIWindow {
    /// get window
    public static var keyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .sorted { $0.activationState.sortPriority < $1.activationState.sortPriority }
                .compactMap { $0 as? UIWindowScene }
                .compactMap { $0.windows.first { $0.isKeyWindow } }
                .first
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
}

@available(iOS 13.0, *)
extension UIWindowScene {
    /// Get UIWindowScene
    public static var currentWindowSence: UIWindowScene?  {
        for scene in UIApplication.shared.connectedScenes{
            if scene.activationState == .foregroundActive{
                return scene as? UIWindowScene
            }
        }
        return nil
    }
}

@available(iOS 13.0, *)
private extension UIScene.ActivationState {
    var sortPriority: Int {
        switch self {
        case .foregroundActive: return 1
        case .foregroundInactive: return 2
        case .background: return 3
        case .unattached: return 4
        @unknown default: return 5
        }
    }
}

//MARK:--Get the namespace where the object is located
public extension NSObject {
    
    func getModuleName() -> String{
        let name = type(of: self).description()
        guard let module : String = name.components(separatedBy: ".").first else {
            return Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        }
        return module
    }
}

//MARK:--URL get query dictionary
public extension URL {
    
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
//MARK:--URL codec
public extension String {
    //Encode the original url into a valid url
    func urlEncoded() -> String {
        self.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed) ?? ""
    }
    
    //convert the encoded url back to the original url
    func urlDecoded() -> String {
        self.removingPercentEncoding ?? ""
    }
}
