//
//  JHToolsDefine.swift
//  JHToolsModule_Swift
//
//  Created by iOS on 15/11/2019.
//  Copyright © 2019 HU. All rights reserved.
//

import UIKit
import Foundation
// MARK: ===================================变量宏定义=========================================

// MARK:- 屏幕
public let screen_height = UIScreen.main.bounds.height
public let screen_width = UIScreen.main.bounds.width
public let fit_width = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) / 375
public let fit_height = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) / 667

public func status_bar_height() ->CGFloat {
    if #available(iOS 13.0, *){
        let window = UIApplication.shared.windows.first
        return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }else{
        return UIApplication.shared.statusBarFrame.height
    }
}
//导航栏高度:通用
public let nav_bar_height = UINavigationController().navigationBar.frame.size.height
//判断是否iphoneX
public func is_bangs_iPhone() -> Bool {
    guard #available(iOS 11.0, *) else {
        return false
    }
    
    let isX = UIApplication.shared.windows[0].safeAreaInsets.bottom > 0
    return isX
}

public let nav_status_height = is_bangs_iPhone() ? Float(88.0) : Float(64.0)
public let tab_bar_height = is_bangs_iPhone() ? Float(49.0+34.0) : Float(49.0)
public let status_height = is_bangs_iPhone() ? Float(44.0) : Float(20.0)

// MARK:- 画线宽度
public let scare = UIScreen.main.scale
public let line_height = Float(scare >= 1 ? 1/scare : 1)


// MARK:- 系统版本
public let iOS_later_11 = (UIDevice.current.systemVersion as NSString).doubleValue >= 11.0
public let iOS_later_12 = (UIDevice.current.systemVersion as NSString).doubleValue >= 12.0
public let iOS_later_13 = (UIDevice.current.systemVersion as NSString).doubleValue >= 13.0

public func later_iOS_11() -> Bool { return (UIDevice.current.systemVersion as NSString).doubleValue >= 11.0 }
public func later_iOS_12() -> Bool { return (UIDevice.current.systemVersion as NSString).doubleValue >= 12.0 }
public func later_iOS_13() -> Bool { return (UIDevice.current.systemVersion as NSString).doubleValue >= 13.0 }
public let system_version = (UIDevice.current.systemVersion as String)

// MARK:- 字体
public let font_11 = UIFont.systemFont(ofSize: 11)
public let font_12 = UIFont.systemFont(ofSize: 12)
public let font_13 = UIFont.systemFont(ofSize: 13)
public let font_14 = UIFont.systemFont(ofSize: 14)
public let font_15 = UIFont.systemFont(ofSize: 15)
public let font_16 = UIFont.systemFont(ofSize: 16)

public func font(_ size: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: size)
}

public func font_bold(_ size: CGFloat) -> UIFont {
    return UIFont.boldSystemFont(ofSize: size)
}

public func font_weight(_ size: CGFloat, weight: UIFont.Weight) -> UIFont {
    return UIFont.systemFont(ofSize: size, weight: weight)
}


// MARK:- 打印输出
//public func SLog<T>(_ message : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {
//    #if DEBUG
//        let fileName = (file as NSString).lastPathComponent
//        print("\n\n<><><><><>-「LOG」-<><><><><>\n\n>>>>>>>>>>>>>>>所在类:>>>>>>>>>>>>>>>\n\n\(fileName)\n\n>>>>>>>>>>>>>>>所在行:>>>>>>>>>>>>>>>\n\n\(lineNum)\n\n>>>>>>>>>>>>>>>信 息:>>>>>>>>>>>>>>>\n\n\(message)\n\n<><><><><>-「END」-<><><><><>\n\n")
//    #endif
//}

