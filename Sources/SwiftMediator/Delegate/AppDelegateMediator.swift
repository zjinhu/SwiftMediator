//
//  AppDelegateMediator.swift
//  SwiftMediator
//
//  Created by iOS on 2021/11/10.
//  Copyright © 2021 狄烨 . All rights reserved.
//
//  AppDelegate 生命周期解耦中介 / AppDelegate Lifecycle Decoupling Mediator
//  支持将 AppDelegate 的代理方法分发到多个模块
//  Supports distributing AppDelegate delegate methods to multiple modules

import Foundation
import UIKit
#if canImport(CloudKit)
import CloudKit
#endif
#if canImport(Intents)
import Intents
#endif

/** 使用方式 / Usage:
 1. 在 AppDelegate 中添加 / Add in AppDelegate:
 
    lazy var manager: AppDelegateManager = {
        return AppDelegateManager.init(delegates: [AppDe.init(window)])
    }()
 
 2. 在对应代理方法中添加钩子 / Add hook to corresponding delegate method:
 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        manager.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
 */

//MARK:--AppDelegate 解耦 / AppDelegate Decoupling--Swift
/// AppDelegate 代理协议类型别名 / AppDelegate delegate protocol typealias
public typealias AppDelegateMediator = UIResponder & UIApplicationDelegate

/// AppDelegate 代理管理器，负责分发代理方法到多个模块 / AppDelegate proxy manager, responsible for distributing delegate methods to multiple modules
public class AppDelegateManager : AppDelegateMediator {
    
    /// 代理对象数组 / Array of delegate objects
    private let delegates : [AppDelegateMediator]
    
    /// 初始化方法，需传入代理对象数组 / Initializer, requires an array of delegate objects
    /// - Parameter delegates: 代理对象数组 / Array of delegates
    public init(delegates:[AppDelegateMediator]) {
        self.delegates = delegates
    }

    /// Wrap completion so it can only be fired once when multiple delegates are registered.
    private func makeOnceHandler<T>(_ handler: @escaping (T) -> Void) -> (T) -> Void {
        let lock = NSLock()
        var fired = false
        return { value in
            lock.lock()
            guard !fired else {
                lock.unlock()
                return
            }
            fired = true
            lock.unlock()
            handler(value)
        }
    }

    /// Wrap completion so it can only be fired once when multiple delegates are registered.
    private func makeOnceHandler(_ handler: @escaping () -> Void) -> () -> Void {
        let lock = NSLock()
        var fired = false
        return {
            lock.lock()
            guard !fired else {
                lock.unlock()
                return
            }
            fired = true
            lock.unlock()
            handler()
        }
    }
    
    //MARK:--- 启动初始化 / Launch Initialization ----------
    /// App 即将启动 / App will finish launching
    @discardableResult
    public func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        for item in delegates {
            if let bool = item.application?(application, willFinishLaunchingWithOptions: launchOptions), !bool {
                return false
            }
        }
        return true
    }
    
    /// App 启动完成 / App did finish launching
    @discardableResult
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        for item in delegates {
            if let bool = item.application?(application, didFinishLaunchingWithOptions: launchOptions), !bool {
                return false
            }
        }
        return true
    }
    
    //MARK:--- 程序状态更改和系统事件 / App State Changes and System Events ----------
    /// App 即将过渡到前台 / App will enter foreground
    public func applicationWillEnterForeground(_ application: UIApplication) {
        delegates.forEach { _ = $0.applicationWillEnterForeground?(application)}
    }
    
    /// App 过渡到活动状态 / App did become active
    public func applicationDidBecomeActive(_ application: UIApplication) {
        delegates.forEach { _ = $0.applicationDidBecomeActive?(application)}
    }
    
    /// App 即将进入非活动状态 / App will resign active
    /// 例如：来电时 / e.g., when receiving a phone call
    public func applicationWillResignActive(_ application: UIApplication) {
        delegates.forEach { _ = $0.applicationWillResignActive?(application)}
    }
    
    /// App 已过渡到后台 / App did enter background
    public func applicationDidEnterBackground(_ application: UIApplication) {
        delegates.forEach { _ = $0.applicationDidEnterBackground?(application)}
    }
    
    /// 收到内存警告 / Received memory warning
    public func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        delegates.forEach { _ = $0.applicationDidReceiveMemoryWarning?(application)}
    }
    
    /// App 即将终止 / App will terminate
    public func applicationWillTerminate(_ application: UIApplication) {
        delegates.forEach { _ = $0.applicationWillTerminate?(application)}
    }
    
    /// 时间发生重大变化 / Significant time change occurred
    public func applicationSignificantTimeChange(_ application: UIApplication) {
        delegates.forEach { _ = $0.applicationSignificantTimeChange?(application)}
    }
    
    /// 受保护的文件已可用 / Protected data did become available
    public func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication) {
        delegates.forEach { _ = $0.applicationProtectedDataDidBecomeAvailable?(application)}
    }
    
    /// 受保护的文件即将不可用 / Protected data will become unavailable
    public func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication) {
        delegates.forEach { _ = $0.applicationProtectedDataWillBecomeUnavailable?(application)}
    }
    
    //MARK:--- 远程通知注册 / Remote Notification Registration ----------
    /// 成功注册 Apple 推送通知服务 / Successfully registered for Apple push notifications
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        delegates.forEach { _ = $0.application?(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)}
    }
    
    /// 注册远程通知失败 / Failed to register for remote notifications
    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        delegates.forEach { _ = $0.application?(application, didFailToRegisterForRemoteNotificationsWithError: error)}
    }
    
    /// 收到远程通知 / Received remote notification
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let onceCompletion = makeOnceHandler(completionHandler)
        var handled = false
        for item in delegates {
            if item.application?(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: onceCompletion) != nil {
                handled = true
            }
        }
        if !handled {
            onceCompletion(.noData)
        }
    }
    
    /// 处理 URL 打开请求 / Handle URL open request
    @discardableResult
    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        for item in delegates {
            if let bool = item.application?(app, open: url, options: options), !bool {
                return false
            }
        }
        return true
    }
    
    //MARK:--- 后台数据下载 / Background Data Download ----------
    /// 后台数据获取 / Background fetch (deprecated in iOS 13)
    @available(iOS, introduced: 7.0, deprecated: 13.0, message: "Use a BGAppRefreshTask in the BackgroundTasks framework instead")
    public func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let onceCompletion = makeOnceHandler(completionHandler)
        var handled = false
        for item in delegates {
            if item.application?(application, performFetchWithCompletionHandler: onceCompletion) != nil {
                handled = true
            }
        }
        if !handled {
            onceCompletion(.noData)
        }
    }
    
    /// 后台 URL 会话事件处理 / Handle background URL session events
    public func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        let onceCompletion = makeOnceHandler(completionHandler)
        var handled = false
        for item in delegates {
            if item.application?(application, handleEventsForBackgroundURLSession: identifier, completionHandler: onceCompletion) != nil {
                handled = true
            }
        }
        if !handled {
            onceCompletion()
        }
    }
    
    //MARK:--- 状态恢复管理 / State Restoration Management ----------
    /// 是否应保存 App 状态 / Whether app state should be saved
    @available(iOS, introduced: 6.0, deprecated: 13.2, message: "Use application:shouldSaveSecureApplicationState: instead")
    public func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        for item in delegates {
            if let bool = item.application?(application, shouldSaveApplicationState: coder), !bool {
                return false
            }
        }
        return true
    }
    
    /// 是否应恢复 App 状态 / Whether app state should be restored
    @available(iOS, introduced: 6.0, deprecated: 13.2, message: "Use application:shouldRestoreSecureApplicationState: instead")
    public func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        for item in delegates {
            if let bool = item.application?(application, shouldRestoreApplicationState: coder), !bool {
                return false
            }
        }
        return true
    }
    
    /// 提供指定视图控制器 / Provide view controller with restoration identifier
    public func application(_ application: UIApplication, viewControllerWithRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {
        for item in delegates {
            if let vc = item.application?(application, viewControllerWithRestorationIdentifierPath: identifierComponents, coder: coder) {
                return vc
            }
        }
        return nil
    }
    
    /// 状态保存 / State will encode restorable state
    public func application(_ application: UIApplication, willEncodeRestorableStateWith coder: NSCoder) {
        delegates.forEach { _ = $0.application?(application, willEncodeRestorableStateWith: coder)}
    }
    
    /// 状态恢复 / State did decode restorable state
    public func application(_ application: UIApplication, didDecodeRestorableStateWith coder: NSCoder) {
        delegates.forEach { _ = $0.application?(application, didDecodeRestorableStateWith: coder)}
    }
    
    //MARK:--- 用户活动与快速操作 / User Activities and Quick Actions ----------
    /// 是否负责通知用户活动超时 / Whether app is responsible for notifying user of activity timeout
    public func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        for item in delegates {
            if let bool = item.application?(application, willContinueUserActivityWithType: userActivityType), !bool {
                return false
            }
        }
        return true
    }
    
    /// 继续用户活动 / Continue user activity
    public func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        let onceRestoration = makeOnceHandler(restorationHandler)
        for item in delegates {
            if let bool = item.application?(application, continue: userActivity, restorationHandler: onceRestoration), !bool {
                return false
            }
        }
        return true
    }
    
    /// 用户活动已更新 / User activity did update
    public func application(_ application: UIApplication, didUpdate userActivity: NSUserActivity) {
        delegates.forEach { _ = $0.application?(application, didUpdate: userActivity)}
    }
    
    /// 用户活动继续失败 / User activity failed to continue
    public func application(_ application: UIApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error) {
        delegates.forEach { _ = $0.application?(application, didFailToContinueUserActivityWithType: userActivityType, error: error)}
    }
    
    /// 处理主屏幕快速操作 / Handle home screen quick action
    public func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        let onceCompletion = makeOnceHandler(completionHandler)
        var handled = false
        for item in delegates {
            if item.application?(application, performActionFor: shortcutItem, completionHandler: onceCompletion) != nil {
                handled = true
            }
        }
        if !handled {
            onceCompletion(false)
        }
    }
    
    //MARK:--- WatchKit 交互 / WatchKit Interaction ----------
    /// 回复配对的 watchOS App 请求 / Reply to paired watchOS app request
    public func application(_ application: UIApplication, handleWatchKitExtensionRequest userInfo: [AnyHashable : Any]?, reply: @escaping ([AnyHashable : Any]?) -> Void) {
        let onceReply = makeOnceHandler(reply)
        var handled = false
        for item in delegates {
            if item.application?(application, handleWatchKitExtensionRequest: userInfo, reply: onceReply) != nil {
                handled = true
            }
        }
        if !handled {
            onceReply(nil)
        }
    }
    
    //MARK:--- HealthKit 交互 / HealthKit Interaction ----------
    /// 请求健康数据授权 / Request health data authorization
    public func applicationShouldRequestHealthAuthorization(_ application: UIApplication) {
        delegates.forEach { _ = $0.applicationShouldRequestHealthAuthorization?(application)}
    }
    
    //MARK:--- 应用扩展管理 / App Extension Management ----------
    /// 是否允许指定扩展点 / Whether to allow specified extension point
    /// 例如：禁用第三方输入法 / e.g., disable third-party keyboards
    public func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
        for item in delegates {
            if let bool = item.application?(application, shouldAllowExtensionPointIdentifier: extensionPointIdentifier), !bool {
                return false
            }
        }
        return true
    }
    
    //MARK:--- 界面管理 / Interface Management ----------
    /// 支持的界面方向 / Supported interface orientations for window
    public func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        for item in delegates {
            if let mask = item.application?(application, supportedInterfaceOrientationsFor: window) {
                return mask
            }
        }
        return .all
    }
    
    /// 状态栏方向即将更改 / Status bar orientation will change
    @available(iOS, introduced: 2.0, deprecated: 13.0, message: "Use viewWillTransitionToSize:withTransitionCoordinator: instead.")
    public func application(_ application: UIApplication, willChangeStatusBarOrientation newStatusBarOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        delegates.forEach { _ = $0.application?(application, willChangeStatusBarOrientation: newStatusBarOrientation, duration: duration)}
    }
    
    /// 状态栏方向已更改 / Status bar orientation did change
    @available(iOS, introduced: 2.0, deprecated: 13.0, message: "Use viewWillTransitionToSize:withTransitionCoordinator: instead.")
    public func application(_ application: UIApplication, didChangeStatusBarOrientation oldStatusBarOrientation: UIInterfaceOrientation) {
        delegates.forEach { _ = $0.application?(application, didChangeStatusBarOrientation: oldStatusBarOrientation)}
    }
    
    /// 状态栏 Frame 即将更改 / Status bar frame will change
    @available(iOS, introduced: 2.0, deprecated: 13.0, message: "Use viewWillTransitionToSize:withTransitionCoordinator: instead.")
    public func application(_ application: UIApplication, willChangeStatusBarFrame newStatusBarFrame: CGRect) {
        delegates.forEach { _ = $0.application?(application, willChangeStatusBarFrame: newStatusBarFrame)}
    }
    
    /// 状态栏 Frame 已更改 / Status bar frame did change
    @available(iOS, introduced: 2.0, deprecated: 13.0, message: "Use viewWillTransitionToSize:withTransitionCoordinator: instead.")
    public func application(_ application: UIApplication, didChangeStatusBarFrame oldStatusBarFrame: CGRect) {
        delegates.forEach { _ = $0.application?(application, didChangeStatusBarFrame: oldStatusBarFrame)}
    }
    
    /// 配置 Scene 连接 / Configure scene connection
    @available(iOS 13.0, *)
    public func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        delegates.forEach { _ = $0.application?(application, configurationForConnecting: connectingSceneSession,options: options)}
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    /// Scene 会话已丢弃 / Scene session did discard
    @available(iOS 13.0, *)
    public func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        delegates.forEach { _ = $0.application?(application, didDiscardSceneSessions: sceneSessions)}
    }
    
    /// 是否应保存安全应用状态 / Whether secure app state should be saved
    @available(iOS 13.2, *)
    public func application(_ application: UIApplication, shouldSaveSecureApplicationState coder: NSCoder) -> Bool{
        for item in delegates {
            if let bool = item.application?(application, shouldSaveSecureApplicationState: coder), !bool {
                return false
            }
        }
        return true
    }
    
    /// 是否应恢复安全应用状态 / Whether secure app state should be restored
    @available(iOS 13.2, *)
    public func application(_ application: UIApplication, shouldRestoreSecureApplicationState coder: NSCoder) -> Bool{
        for item in delegates {
            if let bool = item.application?(application, shouldRestoreSecureApplicationState: coder), !bool {
                return false
            }
        }
        return true
    }
    
    //MARK:--- SiriKit 意图处理 / SiriKit Intent Handling ----------
    /// 处理 SiriKit 意图 / Handle SiriKit intent
    @available(iOS 14.0, *)
    public func application(_ application: UIApplication, handlerFor intent: INIntent) -> Any?{
        
        for item in delegates {
            if let any = item.application?(application, handlerFor: intent){
                return any
            }
        }
        return nil
    }
    
    /// 是否应自动本地化快捷键命令 / Whether key commands should be automatically localized
    @available(iOS 15.0, *)
    public func applicationShouldAutomaticallyLocalizeKeyCommands(_ application: UIApplication) -> Bool{
        for item in delegates {
            if let bool = item.applicationShouldAutomaticallyLocalizeKeyCommands?(application), !bool {
                return false
            }
        }
        return true
    }
    
    //MARK:--- CloudKit 共享 / CloudKit Sharing ----------
    /// 用户接受 CloudKit 共享 / User accepted CloudKit share
    public func application(_ application: UIApplication, userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShare.Metadata) {
        delegates.forEach { _ = $0.application?(application, userDidAcceptCloudKitShareWith: cloudKitShareMetadata)}
    }
}
