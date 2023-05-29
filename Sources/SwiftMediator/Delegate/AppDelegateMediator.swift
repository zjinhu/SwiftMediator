//
//  AppDelegateMediator.swift
//  SwiftMediator
//
//  Created by iOS on 2021/11/10.
//  Copyright © 2021 狄烨 . All rights reserved.
//

import Foundation
import UIKit
import CloudKit
import Intents
/** Use case AppDelegateMediator usage
 1. Add in AppDelegate
 
 lazy var manager: AppDelegateManager = {
 return AppDelegateManager.init(delegates: [AppDe.init(window)])
 }()
 
 2. Add a hook to the corresponding proxy method
 func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
 manager. application(application, didFinishLaunchingWithOptions: launchOptions)
 }
 */

//MARK:--AppDelegate decoupling
public typealias AppDelegateMediator = UIResponder & UIApplicationDelegate

public class AppDelegateManager : AppDelegateMediator {
    
    private let delegates : [AppDelegateMediator]
    
    /// The hook needs to be initialized in the form of an array
    /// - Parameter delegates: Array of hooks
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
    @available(iOS, introduced: 7.0, deprecated: 13.0, message: "Use a BGAppRefreshTask in the BackgroundTasks framework instead")
    public func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        delegates.forEach { _ = $0.application?(application, performFetchWithCompletionHandler: completionHandler)}
    }
    
    /// 与URL会话相关的事件正在等待处理
    public func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        delegates.forEach { _ = $0.application?(application, handleEventsForBackgroundURLSession: identifier, completionHandler: completionHandler)}
    }
    
    //MARK:--- 管理App状态恢复 ----------
    /// 是否应该保留App的状态。
    @available(iOS, introduced: 6.0, deprecated: 13.2, message: "Use application:shouldSaveSecureApplicationState: instead")
    public func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        for item in delegates {
            if let bool = item.application?(application, shouldSaveApplicationState: coder), !bool {
                return false
            }
        }
        return true
    }
    
    /// 是否应恢复App保存的状态信息
    @available(iOS, introduced: 6.0, deprecated: 13.2, message: "Use application:shouldRestoreSecureApplicationState: instead")
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
    @available(iOS, introduced: 2.0, deprecated: 13.0, message: "Use viewWillTransitionToSize:withTransitionCoordinator: instead.")
    public func application(_ application: UIApplication, willChangeStatusBarOrientation newStatusBarOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        delegates.forEach { _ = $0.application?(application, willChangeStatusBarOrientation: newStatusBarOrientation, duration: duration)}
    }
    
    /// 当状态栏的界面方向发生变化时
    @available(iOS, introduced: 2.0, deprecated: 13.0, message: "Use viewWillTransitionToSize:withTransitionCoordinator: instead.")
    public func application(_ application: UIApplication, didChangeStatusBarOrientation oldStatusBarOrientation: UIInterfaceOrientation) {
        delegates.forEach { _ = $0.application?(application, didChangeStatusBarOrientation: oldStatusBarOrientation)}
    }
    
    /// 当状态栏的Frame即将更改时
    @available(iOS, introduced: 2.0, deprecated: 13.0, message: "Use viewWillTransitionToSize:withTransitionCoordinator: instead.")
    public func application(_ application: UIApplication, willChangeStatusBarFrame newStatusBarFrame: CGRect) {
        delegates.forEach { _ = $0.application?(application, willChangeStatusBarFrame: newStatusBarFrame)}
    }
    
    /// 当状态栏的Frame更改时
    @available(iOS, introduced: 2.0, deprecated: 13.0, message: "Use viewWillTransitionToSize:withTransitionCoordinator: instead.")
    public func application(_ application: UIApplication, didChangeStatusBarFrame oldStatusBarFrame: CGRect) {
        delegates.forEach { _ = $0.application?(application, didChangeStatusBarFrame: oldStatusBarFrame)}
    }
    
    @available(iOS 13.0, *)
    public func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        delegates.forEach { _ = $0.application?(application, configurationForConnecting: connectingSceneSession,options: options)}
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    public func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        delegates.forEach { _ = $0.application?(application, didDiscardSceneSessions: sceneSessions)}
    }
    
    @available(iOS 13.2, *)
    public func application(_ application: UIApplication, shouldSaveSecureApplicationState coder: NSCoder) -> Bool{
        for item in delegates {
            if let bool = item.application?(application, shouldSaveSecureApplicationState: coder), !bool {
                return false
            }
        }
        return true
    }
    
    @available(iOS 13.2, *)
    public func application(_ application: UIApplication, shouldRestoreSecureApplicationState coder: NSCoder) -> Bool{
        for item in delegates {
            if let bool = item.application?(application, shouldRestoreSecureApplicationState: coder), !bool {
                return false
            }
        }
        return true
    }
    //MARK:--- 处理SiriKit意图 ----------
    /// 处理指定的SiriKit意图
    @available(iOS 14.0, *)
    public func application(_ application: UIApplication, handlerFor intent: INIntent) -> Any?{
        
        for item in delegates {
            if let any = item.application?(application, handlerFor: intent){
                return any
            }
        }
        return nil
    }
    
    @available(iOS 15.0, *)
    public func applicationShouldAutomaticallyLocalizeKeyCommands(_ application: UIApplication) -> Bool{
        for item in delegates {
            if let bool = item.applicationShouldAutomaticallyLocalizeKeyCommands?(application), !bool {
                return false
            }
        }
        return true
    }
    
    //MARK:--- 处理CloudKit ----------
    /// App可以访问CloudKit中的共享信息
    public func application(_ application: UIApplication, userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShare.Metadata) {
        delegates.forEach { _ = $0.application?(application, userDidAcceptCloudKitShareWith: cloudKitShareMetadata)}
    }
}
//解耦方案参考https://juejin.im/post/5bd0259d5188251a29719086#comment
