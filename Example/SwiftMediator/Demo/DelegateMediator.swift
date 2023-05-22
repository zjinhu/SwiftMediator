//
//  SceneDe.swift
//  SwiftMediator
//
//  Created by iOS on 2020/1/10.
//  Copyright © 2020 狄烨 . All rights reserved.
//

import UIKit
import SwiftMediator
@available(iOS 13.0, *)
class SceneDe: SceneDelegateMediator{
     var window: UIWindow?
     init(_ win : UIWindow?) {
         window = win
     }
     func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
         print("UIScene starts here")
         guard let _ = (scene as? UIWindowScene) else { return }
     }
    
     func sceneWillResignActive(_ scene: UIScene) {
         print("UIScene is about to enter the background")
     }
}


class AppDe: AppDelegateMediator{
     var window: UIWindow?
     init(_ win : UIWindow?) {
         window = win
     }
    
     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
         print("UIApplication starts here")
         return true
     }

     func applicationWillResignActive(_ application: UIApplication) {
         print("UIApplication will enter the background here")
     }
}
