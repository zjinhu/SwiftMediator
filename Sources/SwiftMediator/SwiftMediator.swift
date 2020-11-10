//
//  SwiftMediator.swift
//  SwiftMediator
//
//  Created by iOS on 27/11/2019.
//  Copyright © 2019 狄烨 . All rights reserved.
//

import UIKit

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

//MARK:--路由跳转
extension SwiftMediator {
    
    /// URL路由跳转 跳转区分Push、present、fullScreen
    /// - Parameter urlString:调用原生页面功能 scheme ://push/moduleName/vcName?quereyParams
    public func openUrl(_ urlString: String?) {
        guard let str = urlString, let url = URL.init(string: str) else { return }
        
        if let scheme = url.scheme,
            (scheme == "http" || scheme == "https") {
            // Web View Controller
        }else{
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
    
    /// 路由Push
    /// - Parameters:
    ///   - fromVC: 从那个页面起跳--不传默认取最上层VC
    ///   - moduleName: 目标VC所在组件名称
    ///   - vcName: 目标VC名称
    ///   - paramsDic: 参数字典
    public func push(_ vcName: String,
                     moduleName: String? = nil,
                     fromVC: UIViewController? = nil,
                     paramsDic:[String:Any]? = nil) {
        
        guard let vc = initVC(vcName, moduleName: moduleName, dic: paramsDic) else { return }
        vc.hidesBottomBarWhenPushed = true
        guard let from = fromVC else {
            currentNavigationController()?.pushViewController(vc, animated: true)
            return
        }
        from.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 简单Push,提前初始化好VC
    /// - Parameters:
    ///   - vc: 已初始化好的VC对象
    ///   - fromVC: 从哪个页面push,不传则路由选择最上层VC
    public func push(_ vc: UIViewController?,
                     fromVC: UIViewController? = nil) {
        guard let vc = vc else { return }
        vc.hidesBottomBarWhenPushed = true
        guard let from = fromVC else {
            currentNavigationController()?.pushViewController(vc, animated: true)
            return
        }
        from.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 路由present
    /// - Parameters:
    ///   - fromVC: 从那个页面起跳--不传默认取最上层VC
    ///   - moduleName: 目标VC所在组件名称
    ///   - vcName: 目标VC名称
    ///   - paramsDic: 参数字典
    ///   - modelStyle: 0:模态样式为默认，1:全屏模态,2:custom
    public func present(_ vcName: String,
                        moduleName: String? = nil,
                        fromVC: UIViewController? = nil,
                        paramsDic:[String:Any]? = nil,
                        modelStyle: Int = 0) {
        guard let vc = initVC(vcName, moduleName: moduleName, dic: paramsDic) else { return }
        
        let nav = UINavigationController.init(rootViewController: vc)
        switch modelStyle {
        case 1:
            nav.modalPresentationStyle = .fullScreen
        case 2:
            nav.modalPresentationStyle = .custom
        default:
            if #available(iOS 13.0, *) {
                nav.modalPresentationStyle = .automatic
            } else {
                nav.modalPresentationStyle = .fullScreen
            }
        }
        
        guard let from = fromVC else {
            currentViewController()?.present(nav, animated: true, completion: nil)
            return
        }
        from.present(nav, animated: true, completion: nil)
    }
    
    /// 简单present,提前初始化好VC
    /// - Parameters:
    ///   - vc: 已初始化好的VC对象
    ///   - fromVC: 从哪个页面push,不传则路由选择最上层VC
    ///   - needNav: 是否需要导航栏
    ///   - modelStyle: 0:模态样式为默认，1:全屏模态,2:custom
    public func present(_ vc: UIViewController?,
                        fromVC: UIViewController? = nil,
                        needNav: Bool = true,
                        modelStyle: Int = 0) {
        guard let vc = vc else { return }
        
        var container = vc
        
        if needNav {
            let nav = UINavigationController.init(rootViewController: vc)
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
            currentViewController()?.present(container, animated: true, completion: nil)
            return
        }
        from.present(container, animated: true, completion: nil)
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
    public func currentNavigationController() -> (UINavigationController?) {
        return currentViewController()?.navigationController
    }
    
    /// 获取顶层VC 根据window
    public func currentViewController() -> (UIViewController?) {
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

//以下解耦方案参考https://juejin.im/post/5bd0259d5188251a29719086#comment
//MARK:--AppDelegate解耦
public typealias AppDelegateMediator = UIResponder & UIApplicationDelegate

public class AppDelegateManager : AppDelegateMediator {
    
    private let delegates : [AppDelegateMediator]
    
    /// 钩子处需要初始化，采用数组的方式
    /// - Parameter delegates: 钩子数组
    public init(delegates:[AppDelegateMediator]) {
        self.delegates = delegates
    }
    //MARK:--- 启动 初始化 ----------
    /// 即将启动
    @discardableResult
    public func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        for item in delegates {
            if let bool = item.application?(application, willFinishLaunchingWithOptions: launchOptions), !bool {
                return false
            }
        }
        return true
    }
    /// 启动完成
    @discardableResult
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        for item in delegates {
            if let bool = item.application?(application, didFinishLaunchingWithOptions: launchOptions), !bool {
                return false
            }
        }
        return true
    }
    //MARK:--- 程序状态更改和系统事件 ----------
    /// 即将过渡到前台
    public func applicationWillEnterForeground(_ application: UIApplication) {
        delegates.forEach { _ = $0.applicationWillEnterForeground?(application)}
    }
    /// 过渡到活动状态
    public func applicationDidBecomeActive(_ application: UIApplication) {
        delegates.forEach { _ = $0.applicationDidBecomeActive?(application)}
    }
    
    /// 即将进入非活动状态，在此期间，App不接收消息或事件
    /// 如:来电话
    public func applicationWillResignActive(_ application: UIApplication) {
        delegates.forEach { _ = $0.applicationWillResignActive?(application)}
    }
    /// 已过渡到后台
    public func applicationDidEnterBackground(_ application: UIApplication) {
        delegates.forEach { _ = $0.applicationDidEnterBackground?(application)}
    }
    
    /// 内存警告
    public func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        delegates.forEach { _ = $0.applicationDidReceiveMemoryWarning?(application)}
    }
    
    /// App 即将终止
    public func applicationWillTerminate(_ application: UIApplication) {
        delegates.forEach { _ = $0.applicationWillTerminate?(application)}
    }
    /// 时间发生重大变化
    public func applicationSignificantTimeChange(_ application: UIApplication) {
        delegates.forEach { _ = $0.applicationSignificantTimeChange?(application)}
    }
    
    /// 受保护的文件已经可用
    public func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {
        delegates.forEach { _ = $0.applicationProtectedDataDidBecomeAvailable?(application)}
    }
    /// 受保护的文件即将变为不可用
    public func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication) {
        delegates.forEach { _ = $0.applicationProtectedDataWillBecomeUnavailable?(application)}
    }
    
    //MARK:--- 处理远程通知注册 ----------
    /// 该App已成功注册Apple推送通知服务
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        delegates.forEach { _ = $0.application?(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)}
    }
    /// Apple推送通知服务无法成功完成注册过程时
    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        delegates.forEach { _ = $0.application?(application, didFailToRegisterForRemoteNotificationsWithError: error)}
    }
    /// 已到达远程通知，表明有数据要提取
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        delegates.forEach { _ = $0.application?(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)}
    }
    
    /// 打开URL指定的资源
    @discardableResult
    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        //delegates.forEach { _ = $0.application?(app, open: url, options: options)}
        for item in delegates {
            if let bool = item.application?(app, open: url, options: options), !bool {
                return false
            }
        }
        return true
    }
    
    //MARK:--- 在后台下载数据 ----------
    /// 如果有数据要下载，它可以开始获取操作
    public func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        delegates.forEach { _ = $0.application?(application, performFetchWithCompletionHandler: completionHandler)}
    }
    /// 与URL会话相关的事件正在等待处理
    public func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        delegates.forEach { _ = $0.application?(application, handleEventsForBackgroundURLSession: identifier, completionHandler: completionHandler)}
    }
    
    //MARK:--- 管理App状态恢复 ----------
    /// 是否应该保留App的状态。
    public func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        for item in delegates {
            if let bool = item.application?(application, shouldSaveApplicationState: coder), !bool {
                return false
            }
        }
        return true
    }
    /// 是否应恢复App保存的状态信息
    public func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        for item in delegates {
            if let bool = item.application?(application, shouldRestoreApplicationState: coder), !bool {
                return false
            }
        }
        return true
    }
    /// 提供指定的视图控制器
    public func application(_ application: UIApplication, viewControllerWithRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {
        for item in delegates {
            if let vc = item.application?(application, viewControllerWithRestorationIdentifierPath: identifierComponents, coder: coder) {
                return vc
            }
        }
        return nil
    }
    /// 在状态保存过程开始时保存任何高级状态信息
    public func application(_ application: UIApplication, willEncodeRestorableStateWith coder: NSCoder) {
        delegates.forEach { _ = $0.application?(application, willEncodeRestorableStateWith: coder)}
    }
    /// 在状态恢复过程中恢复任何高级状态信息
    public func application(_ application: UIApplication, didDecodeRestorableStateWith coder: NSCoder) {
        delegates.forEach { _ = $0.application?(application, didDecodeRestorableStateWith: coder)}
    }
    
    //MARK:--- 持续的用户活动和处理快速操作 ----------
    /// 您的App是否负责在延续活动花费的时间超过预期时通知用户
    public func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        for item in delegates {
            if let bool = item.application?(application, willContinueUserActivityWithType: userActivityType), !bool {
                return false
            }
        }
        return true
    }
    /// 可以使用继续活动的数据
    public func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        for item in delegates {
            if let bool = item.application?(application, continue: userActivity, restorationHandler: restorationHandler), !bool {
                return false
            }
        }
        return true
    }
    /// 活动已更新
    public func application(_ application: UIApplication, didUpdate userActivity: NSUserActivity) {
        delegates.forEach { _ = $0.application?(application, didUpdate: userActivity)}
    }
    /// 活动无法继续
    public func application(_ application: UIApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {
        delegates.forEach { _ = $0.application?(application, didFailToContinueUserActivityWithType: userActivityType, error: error)}
    }
    /// 当用户为您的应用选择主屏幕快速操作时调用，除非您在启动方法中截获了交互
    public func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        delegates.forEach { _ = $0.application?(application, performActionFor: shortcutItem, completionHandler: completionHandler)}
    }
    
    //MARK:--- 与WatchKit交互 ----------
    /// 回复配对的watchOSApp的请求
    public func application(_ application: UIApplication, handleWatchKitExtensionRequest userInfo: [AnyHashable : Any]?, reply: @escaping ([AnyHashable : Any]?) -> Void) {
        delegates.forEach { _ = $0.application?(application, handleWatchKitExtensionRequest: userInfo, reply: reply)}
    }
    
    //MARK:--- 与HealthKit交互 ----------
    /// 当应用应该要求用户访问他或她的HealthKit数据时调用
    public func applicationShouldRequestHealthAuthorization(_ application: UIApplication) {
        delegates.forEach { _ = $0.applicationShouldRequestHealthAuthorization?(application)}
    }
    
    //MARK:--- 不允许指定的应用扩展类型 ----------
    /// 要求代理授予使用基于指定扩展点标识符的应用扩展的权限
    /// 如禁用第三方输入法 Custom keyboard，当启动输入法时会调用
    /// iOS 8系统有6个支持扩展的系统区域，分别是Today、Share、Action、Photo Editing、Storage Provider、Custom keyboard。支持扩展的系统区域也被称为扩展点。
    public func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
        for item in delegates {
            if let bool = item.application?(application, shouldAllowExtensionPointIdentifier: extensionPointIdentifier), !bool {
                return false
            }
        }
        return true
    }
    
    //MARK:--- 管理界面 ----------
    /// 询问接口方向，以用于指定窗口中的视图控制器
    public func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        for item in delegates {
            if let mask = item.application?(application, supportedInterfaceOrientationsFor: window) {
                return mask
            }
        }
        return UIInterfaceOrientationMask()
    }
    /// 当状态栏的界面方向即将更改时
    public func application(_ application: UIApplication, willChangeStatusBarOrientation newStatusBarOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        delegates.forEach { _ = $0.application?(application, willChangeStatusBarOrientation:newStatusBarOrientation, duration: duration)}
    }
    /// 当状态栏的界面方向发生变化时
    public func application(_ application: UIApplication, didChangeStatusBarOrientation oldStatusBarOrientation: UIInterfaceOrientation) {
        delegates.forEach { _ = $0.application?(application, didChangeStatusBarOrientation:oldStatusBarOrientation)}
    }
    /// 当状态栏的Frame即将更改时
    public func application(_ application: UIApplication, willChangeStatusBarFrame newStatusBarFrame: CGRect) {
        delegates.forEach { _ = $0.application?(application, willChangeStatusBarFrame:newStatusBarFrame)}
    }
    /// 当状态栏的Frame更改时
    public func application(_ application: UIApplication, didChangeStatusBarFrame oldStatusBarFrame: CGRect) {
        delegates.forEach { _ = $0.application?(application, didChangeStatusBarFrame:oldStatusBarFrame)}
    }
    
    @available(iOS 13.0, *)
    public func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        delegates.forEach { _ = $0.application?(application, configurationForConnecting:connectingSceneSession,options:options)}
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    public func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        delegates.forEach { _ = $0.application?(application, didDiscardSceneSessions:sceneSessions)}
    }
    //MARK:--- 处理SiriKit意图 ----------
    /// 处理指定的SiriKit意图
    /*
     public func application(_ application: UIApplication,
     handle intent: INIntent,
     completionHandler: @escaping (INIntentResponse) -> Void) {
     
     }*/
    
    //MARK:--- 处理CloudKit ----------
    /// App可以访问CloudKit中的共享信息
    /*
     public func application(_ application: UIApplication, userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShare.Metadata) {
     
     }*/
}

//MARK:--SceneDelegate解耦
@available(iOS 13.0, *)
public typealias SceneDelegateMediator = UIResponder & UIWindowSceneDelegate

@available(iOS 13.0, *)
public class SceneDelegateManager : SceneDelegateMediator {
    
    private let delegates : [SceneDelegateMediator]
    
    /// 钩子处需要初始化，采用数组的方式
    /// - Parameter delegates: 钩子数组
    public init(delegates:[SceneDelegateMediator]) {
        self.delegates = delegates
    }
    
    /// 用法同didFinishLaunchingWithOptions
    /// - Parameters:
    ///   - scene: scene
    ///   - session: session
    ///   - connectionOptions: connectionOptions
    public func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        delegates.forEach {_ = $0.scene?(scene, willConnectTo: session, options: connectionOptions) }
    }
    
    /// 当场景与app断开连接是调用（注意，以后它可能被重新连接
    /// - Parameter scene: scene
    public func sceneDidDisconnect(_ scene: UIScene) {
        delegates.forEach {_ = $0.sceneDidDisconnect?(scene)}
    }
    
    /// 当用户开始与场景进行交互（例如从应用切换器中选择场景）时，会调用
    /// - Parameter scene: scene
    public func sceneDidBecomeActive(_ scene: UIScene) {
        delegates.forEach {_ = $0.sceneDidBecomeActive?(scene)}
    }
    
    /// 当用户停止与场景交互（例如通过切换器切换到另一个场景）时调用
    /// - Parameter scene: scene
    public func sceneWillResignActive(_ scene: UIScene) {
        delegates.forEach {_ = $0.sceneWillResignActive?(scene)}
    }
    
    /// 当场景进入后台时调用，即该应用已最小化但仍存活在后台中
    /// - Parameter scene: scene
    public func sceneDidEnterBackground(_ scene: UIScene) {
        delegates.forEach {_ = $0.sceneDidEnterBackground?(scene)}
    }
    
    /// 当场景变成活动窗口时调用，即从后台状态变成开始或恢复状态
    /// - Parameter scene: scene
    public func sceneWillEnterForeground(_ scene: UIScene) {
        delegates.forEach {_ = $0.sceneWillEnterForeground?(scene)}
    }
}
/**用例  AppDelegateMediator SceneDelegateMediator用法相同
 1、新建类继承协议SceneDelegateMediator
 
 class SceneDe: SceneDelegateMediator{
 var window: UIWindow?
 init(_ win : UIWindow?) {
 window = win
 }
 func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
 guard let _ = (scene as? UIWindowScene) else { return }
 }
 }
 
 2、SceneDelegate中添加
 
 lazy var manager: SceneDelegateManager = {
 return SceneDelegateManager.init([SceneDe.init(window)])
 }()
 
 3、相应代理方法中添加钩子
 
 _ = manager.scene(scene, willConnectTo: session, options: connectionOptions)
 */
