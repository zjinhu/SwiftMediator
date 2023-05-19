//
//  JHToolsDefine.swift
//  JHToolsModule_Swift
//
//  Created by iOS on 15/11/2019.
//  Copyright © 2019 HU. All rights reserved.
//

import UIKit
import Foundation
extension SwiftBrick{
    // MARK: ===================================工具类:变量宏定义=========================================
    public struct Define {
        // MARK:- 屏幕
        /// 当前屏幕状态 宽度
        public static let screenHeight = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        /// 当前屏幕状态 高度
        public static let screenWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)

        /// 当前屏幕状态 宽度按照4.7寸 375 屏幕比例 例如 30*FitWidth即可
        public static let fitWidth = screenWidth / 375
        /// 当前屏幕状态 高度按照4.7寸 667 屏幕比例 例如 30*FitHeight即可
        public static let fitHeight = screenHeight / 667
        /// 当前屏幕比例
        public static let screenScale = UIScreen.main.scale
        /// 画线宽度 不同分辨率都是一像素
        public static let lineHeight = CGFloat(screenScale >= 1 ? 1/screenScale: 1)

        /// 信号栏高度
        /// - Returns: 高度
        public static func statusBarHeight() ->CGFloat {
            if #available(iOS 13.0, *){
                return getWindow()?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            }else{
                return UIApplication.shared.statusBarFrame.height
            }
        }
        
        ///获取当前设备window用于判断尺寸
        public static func getWindow() -> UIWindow?{
            if #available(iOS 13.0, *){
                let winScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                return winScene?.windows.first
            }else{
                return UIApplication.shared.keyWindow
            }
        }

        /// 导航栏高度 实时获取,可获取不同分辨率手机横竖屏切换后的实时高度变化
        /// - Returns: 高度
        public static func navBarHeight() ->CGFloat {
            return UINavigationController().navigationBar.frame.size.height
        }

        /// 获取屏幕导航栏+信号栏总高度
        public static let navAndStatusHeight = statusBarHeight() + navBarHeight()
        /// 获取刘海屏底部home键高度,普通屏为0
        public static let bottomHomeHeight = getWindow()?.safeAreaInsets.bottom ?? 0

        /// TabBar高度 实时获取,可获取不同分辨率手机横竖屏切换后的实时高度变化
        /// - Returns: 高度
        public static func tabbarHeight() ->CGFloat {
            return UITabBarController().tabBar.frame.size.height
        }
        //刘海屏=TabBar高度+Home键高度, 普通屏幕为TabBar高度
        public static let tabBarHeight = tabbarHeight() + bottomHomeHeight

        // MARK:- 打印输出
        public static func sLog<T>(_ message: T, file: String = #file, funcName: String = #function, lineNum: Int = #line) {
        #if DEBUG
            let fileName = (file as NSString).lastPathComponent
            print("\n\n<><><><><>-「LOG」-<><><><><>\n\n>>>>>>>>>>>>>>>所在类:>>>>>>>>>>>>>>>\n\n\(fileName)\n\n>>>>>>>>>>>>>>>所在行:>>>>>>>>>>>>>>>\n\n\(lineNum)\n\n>>>>>>>>>>>>>>>信 息:>>>>>>>>>>>>>>>\n\n\(message)\n\n<><><><><>-「END」-<><><><><>\n\n")
        #endif
        }
    }}


