//
//  AppDelegate.swift
//  SwiftMediator
//
//  Created by iOS on 2023/5/11.
//

import UIKit
import SwiftMediator
import SwiftBrick
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    lazy var manager: AppDelegateManager = {
        return AppDelegateManager.init(delegates: [AppDe.init(window)])
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        manager.application(application, didFinishLaunchingWithOptions: launchOptions)

        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print("即将进入前台")
    }
//    /// 过渡到活动状态
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("进入前台")
    }
//
//    /// 即将进入非活动状态，在此期间，App不接收消息或事件
//    /// 如:来电话
    func applicationWillResignActive(_ application: UIApplication) {
        print("即将进入后台")
        manager.applicationWillResignActive(application)
    }
//    /// 已过渡到后台
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("进入后台")
    }

    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

