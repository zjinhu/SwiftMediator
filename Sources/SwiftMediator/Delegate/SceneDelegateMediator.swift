//
//  SceneDelegateMediator.swift
//  SwiftMediator
//
//  Created by iOS on 2023/5/9.
//  Copyright © 2023 狄烨 . All rights reserved.
//
//  SceneDelegate 生命周期解耦中介 / SceneDelegate Lifecycle Decoupling Mediator
//  支持将 SceneDelegate 的代理方法分发到多个模块（iOS 13+）
//  Supports distributing SceneDelegate delegate methods to multiple modules (iOS 13+)

import UIKit
import Foundation
#if canImport(CloudKit)
import CloudKit
#endif

/** 使用方式 / Usage:
 1. 在 SceneDelegate 中添加 / Add in SceneDelegate:
 
    lazy var manager: SceneDelegateManager = {
        return SceneDelegateManager([SceneDelegate(window)])
    }()
 
 2. 在对应代理方法中添加钩子 / Add hook to corresponding delegate method:
 
    _ = manager.scene(scene, willConnectTo: session, options: connectionOptions)
 */

//MARK:--SceneDelegate 解耦 / SceneDelegate Decoupling--Swift
/// SceneDelegate 代理协议类型别名 / SceneDelegate delegate protocol typealias
@available(iOS 13.0, *)
public typealias SceneDelegateMediator = UIResponder & UIWindowSceneDelegate

/// SceneDelegate 代理管理器，负责分发代理方法到多个模块 / SceneDelegate proxy manager, responsible for distributing delegate methods to multiple modules
@available(iOS 13.0, *)
public class SceneDelegateManager : SceneDelegateMediator {
    
    /// 代理对象数组 / Array of delegate objects
    private let delegates : [SceneDelegateMediator]
    
    /// 初始化方法，需传入代理对象数组 / Initializer, requires an array of delegate objects
    /// - Parameter delegates: 代理对象数组 / Array of delegates
    public init(delegates:[SceneDelegateMediator]) {
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
    
    /// Scene 即将连接 / Scene will connect to session
    /// 用法同 didFinishLaunchingWithOptions / Similar to didFinishLaunchingWithOptions
    /// - Parameters:
    ///   - scene: 场景对象 / Scene object
    ///   - session: 会话对象 / Session object
    ///   - connectionOptions: 连接选项 / Connection options
    public func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        delegates.forEach {_ = $0.scene?(scene, willConnectTo: session, options: connectionOptions) }
    }
    
    /// Scene 已断开连接 / Scene did disconnect
    /// 当场景与 App 断开连接时调用（注意：之后可能重新连接）/ Called when scene disconnects from app (note: may reconnect later)
    /// - Parameter scene: 场景对象 / Scene object
    public func sceneDidDisconnect(_ scene: UIScene) {
        delegates.forEach {_ = $0.sceneDidDisconnect?(scene)}
    }
    
    /// Scene 变为活动状态 / Scene did become active
    /// 当用户开始与场景交互时调用（如从应用切换器中选择场景）/ Called when user starts interacting with scene
    /// - Parameter scene: 场景对象 / Scene object
    public func sceneDidBecomeActive(_ scene: UIScene) {
        delegates.forEach {_ = $0.sceneDidBecomeActive?(scene)}
    }
    
    /// Scene 即将进入非活动状态 / Scene will resign active
    /// 当用户停止与场景交互时调用（如通过切换器切换到另一个场景）/ Called when user stops interacting with scene
    /// - Parameter scene: 场景对象 / Scene object
    public func sceneWillResignActive(_ scene: UIScene) {
        delegates.forEach {_ = $0.sceneWillResignActive?(scene)}
    }
    
    /// Scene 进入后台 / Scene did enter background
    /// 当场景进入后台时调用，即 App 已最小化但仍存活在后台 / Called when scene enters background
    /// - Parameter scene: 场景对象 / Scene object
    public func sceneDidEnterBackground(_ scene: UIScene) {
        delegates.forEach {_ = $0.sceneDidEnterBackground?(scene)}
    }
    
    /// Scene 即将进入前台 / Scene will enter foreground
    /// 当场景变成活动窗口时调用，即从后台状态变成开始或恢复状态 / Called when scene becomes active window
    /// - Parameter scene: 场景对象 / Scene object
    public func sceneWillEnterForeground(_ scene: UIScene) {
        delegates.forEach {_ = $0.sceneWillEnterForeground?(scene)}
    }
    
    /// Scene 处理 URL 打开 / Scene handle URL open
    public func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        delegates.forEach {_ = $0.scene?(scene, openURLContexts: URLContexts)}
    }

    /// Scene 更新坐标空间/方向/trait（iOS 26 起已废弃） / Scene updated coordinate space/orientation/traits (deprecated in iOS 26)
    public func windowScene(_ windowScene: UIWindowScene,
                            didUpdate previousCoordinateSpace: UICoordinateSpace,
                            interfaceOrientation previousInterfaceOrientation: UIInterfaceOrientation,
                            traitCollection previousTraitCollection: UITraitCollection) {
        delegates.forEach {
            _ = $0.windowScene?(
                windowScene,
                didUpdate: previousCoordinateSpace,
                interfaceOrientation: previousInterfaceOrientation,
                traitCollection: previousTraitCollection
            )
        }
    }

    /// Scene 已处理主屏快捷操作 / Scene handled home screen shortcut action
    public func windowScene(_ windowScene: UIWindowScene,
                            performActionFor shortcutItem: UIApplicationShortcutItem,
                            completionHandler: @escaping (Bool) -> Void) {
        let onceCompletion = makeOnceHandler(completionHandler)
        var handled = false
        for item in delegates {
            if item.windowScene?(windowScene, performActionFor: shortcutItem, completionHandler: onceCompletion) != nil {
                handled = true
            }
        }
        if !handled {
            onceCompletion(false)
        }
    }

#if canImport(CloudKit)
    /// Scene 接受 CloudKit 分享 / Scene accepted CloudKit share invitation
    public func windowScene(_ windowScene: UIWindowScene, userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShare.Metadata) {
        delegates.forEach { _ = $0.windowScene?(windowScene, userDidAcceptCloudKitShareWith: cloudKitShareMetadata) }
    }
#endif

    /// Scene 几何信息更新（iOS 26+） / Scene effective geometry updated (iOS 26+)
    @available(iOS 26.0, *)
    public func windowScene(_ windowScene: UIWindowScene, didUpdateEffectiveGeometry previousEffectiveGeometry: UIWindowScene.Geometry) {
        delegates.forEach { _ = $0.windowScene?(windowScene, didUpdateEffectiveGeometry: previousEffectiveGeometry) }
    }

    /// Scene 窗口控制样式（iOS 26+） / Preferred windowing control style for scene (iOS 26+)
    @available(iOS 26.0, *)
    public func preferredWindowingControlStyle(for windowScene: UIWindowScene) -> UIWindowScene.WindowingControlStyle {
        for item in delegates {
            if let style = item.preferredWindowingControlStyle?(for: windowScene) {
                return style
            }
        }
        return .automatic
    }
    
    /// 获取状态恢复活动 / Get state restoration activity
    public func stateRestorationActivity(for scene: UIScene) -> NSUserActivity?{
        for item in delegates{
            if let userActivity = item.stateRestorationActivity?(for: scene){
                return userActivity
            }
        }
        return nil
    }
    
    /// 恢复交互状态 / Restore interaction state
    /// 在场景连接后、激活前调用，提供上次保存的 NSUserActivity / Called after scene connection, before activation
    public func scene(_ scene: UIScene, restoreInteractionStateWith stateRestorationActivity: NSUserActivity){
        delegates.forEach {_ = $0.scene?(scene, restoreInteractionStateWith: stateRestorationActivity)}
    }
    
    /// 用户活动即将继续 / User activity will continue
    public func scene(_ scene: UIScene, willContinueUserActivityWithType userActivityType: String){
        delegates.forEach {_ = $0.scene?(scene, willContinueUserActivityWithType: userActivityType)}
    }
    
    /// 继续用户活动 / Continue user activity
    public func scene(_ scene: UIScene, continue userActivity: NSUserActivity){
        delegates.forEach {_ = $0.scene?(scene, continue: userActivity)}
    }
    
    /// 用户活动继续失败 / User activity failed to continue
    public func scene(_ scene: UIScene, didFailToContinueUserActivityWithType userActivityType: String, error: Error){
        delegates.forEach {_ = $0.scene?(scene, didFailToContinueUserActivityWithType: userActivityType, error: error)}
    }
    
    /// 用户活动已更新 / User activity did update
    public func scene(_ scene: UIScene, didUpdate userActivity: NSUserActivity){
        delegates.forEach {_ = $0.scene?(scene, didUpdate: userActivity)}
    }
}
