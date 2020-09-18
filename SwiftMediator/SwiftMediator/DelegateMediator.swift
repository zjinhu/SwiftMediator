//
//  SceneDe.swift
//  SwiftMediator
//
//  Created by iOS on 2020/1/10.
//  Copyright © 2020 狄烨 . All rights reserved.
//

import UIKit
@available(iOS 13.0, *)
class SceneDe: SceneDelegateMediator{
    var window: UIWindow?
    init(_ win : UIWindow?) {
        window = win
    }
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print("UIScene在这启动")
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        print("UIScene在这将要进入后台")
    }
}


class AppDe: AppDelegateMediator{
    var window: UIWindow?
    init(_ win : UIWindow?) {
        window = win
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("UIApplication在这启动")
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        print("UIApplication在这将要进入后台")
    }
}
