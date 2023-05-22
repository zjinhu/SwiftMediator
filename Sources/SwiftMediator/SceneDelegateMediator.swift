//
//  SceneDelegateMediator.swift
//  UIMediator
//
//  Created by iOS on 2023/5/9.
//  Copyright © 2023 狄烨 . All rights reserved.
//
import UIKit
import Foundation
/** Use case SceneDelegateMediator usage
 1. Add in SceneDelegate
 lazy var manager: SceneDelegateManager = {
 return SceneDelegateManager([SceneDelegate(window)])
 }()
 
 2. Add a hook to the corresponding proxy method
 _ = manager. scene(scene, willConnectTo: session, options: connectionOptions)
 */

//MARK:--SceneDelegate decoupling
@available(iOS 13.0, *)
public typealias SceneDelegateMediator = UIResponder & UIWindowSceneDelegate

@available(iOS 13.0, *)
public class SceneDelegateManager : SceneDelegateMediator {
    
    private let delegates : [SceneDelegateMediator]
    
    /// The hook needs to be initialized in the form of an array
    /// - Parameter delegates: Array of hooks
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
    
    public func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        delegates.forEach {_ = $0.scene?(scene, openURLContexts: URLContexts)}
    }
    
    public func stateRestorationActivity(for scene: UIScene) -> NSUserActivity?{
        for item in delegates{
            if let userActivity = item.stateRestorationActivity?(for: scene){
                return userActivity
            }
        }
        return nil
    }
    
    
    // This will be called after scene connection, but before activation, and will provide the
    // activity that was last supplied to the stateRestorationActivityForScene callback, or
    // set on the UISceneSession.stateRestorationActivity property.
    // Note that, if it's required earlier, this activity is also already available in the
    // UISceneSession.stateRestorationActivity at scene connection time.
    public func scene(_ scene: UIScene, restoreInteractionStateWith stateRestorationActivity: NSUserActivity){
        delegates.forEach {_ = $0.scene?(scene, restoreInteractionStateWith: stateRestorationActivity)}
    }
    
    
    public func scene(_ scene: UIScene, willContinueUserActivityWithType userActivityType: String){
        delegates.forEach {_ = $0.scene?(scene, willContinueUserActivityWithType: userActivityType)}
    }
    
    public func scene(_ scene: UIScene, continue userActivity: NSUserActivity){
        delegates.forEach {_ = $0.scene?(scene, continue: userActivity)}
    }
    
    public func scene(_ scene: UIScene, didFailToContinueUserActivityWithType userActivityType: String, error: Error){
        delegates.forEach {_ = $0.scene?(scene, didFailToContinueUserActivityWithType: userActivityType, error: error)}
    }
    
    public func scene(_ scene: UIScene, didUpdate userActivity: NSUserActivity){
        delegates.forEach {_ = $0.scene?(scene, didUpdate: userActivity)}
    }
}
