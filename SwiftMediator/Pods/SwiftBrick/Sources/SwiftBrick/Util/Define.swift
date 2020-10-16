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
/// 当前屏幕状态 宽度
public let ScreenHeight = UIScreen.main.bounds.height
/// 当前屏幕状态 高度
public let ScreenWidth = UIScreen.main.bounds.width

/// 当前屏幕状态 宽度按照4.7寸 375 屏幕比例 例如 30*FitWidth即可
public let FitWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) / 375
/// 当前屏幕状态 高度按照4.7寸 667 屏幕比例 例如 30*FitHeight即可
public let FitHeight = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) / 667
/// 当前屏幕比例
public let Scare = UIScreen.main.scale
/// 画线宽度 不同分辨率都是一像素
public let LineHeight = CGFloat(Scare >= 1 ? 1/Scare : 1)

/// 信号栏高度
/// - Returns: 高度
public func StatusBarHeight() ->CGFloat {
    if #available(iOS 13.0, *){
        let window = UIApplication.shared.windows.first
        return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }else{
        return UIApplication.shared.statusBarFrame.height
    }
}

/// 导航栏高度 实时获取,可获取不同分辨率手机横竖屏切换后的实时高度变化
/// - Returns: 高度
public func NavBarHeight() ->CGFloat {
    return UINavigationController().navigationBar.frame.size.height
}

/// 判断是否iphoneX 带刘海
public func IsBangs_iPhone() -> Bool {
    guard #available(iOS 11.0, *) else {
        return false
    }
    let isX = UIApplication.shared.windows[0].safeAreaInsets.bottom > 0
    return isX
}

/// 获取屏幕导航栏+信号栏总高度
public let NavAndStatusHeight = StatusBarHeight() + NavBarHeight()
/// 获取刘海屏底部home键高度,普通屏为0
public let BottomHomeHeight = UIApplication.shared.windows[0].safeAreaInsets.bottom

/// TabBar高度 实时获取,可获取不同分辨率手机横竖屏切换后的实时高度变化
/// - Returns: 高度
public func TabbarHeight() ->CGFloat {
    return UITabBarController().tabBar.frame.size.height
}
//刘海屏=TabBar高度+Home键高度, 普通屏幕为TabBar高度
public let TabBarHeight = TabbarHeight() + BottomHomeHeight

// MARK:- 系统版本
public let SystemVersion : Double = Double(UIDevice.current.systemVersion) ?? 0
public let Later_iOS11 = SystemVersion >= 11.0
public let Later_iOS12 = SystemVersion >= 12.0
public let Later_iOS13 = SystemVersion >= 13.0
public let Later_iOS14 = SystemVersion >= 14.0

public func Later_iOS_11() -> Bool { return SystemVersion >= 11.0 }
public func Later_iOS_12() -> Bool { return SystemVersion >= 12.0 }
public func Later_iOS_13() -> Bool { return SystemVersion >= 13.0 }
public func Later_iOS_14() -> Bool { return SystemVersion >= 14.0 }

// MARK:- 字体
/// 系统默认字体
public let Font11 = UIFont.systemFont(ofSize: 11)
/// 系统默认字体
public let Font12 = UIFont.systemFont(ofSize: 12)
/// 系统默认字体
public let Font13 = UIFont.systemFont(ofSize: 13)
/// 系统默认字体
public let Font14 = UIFont.systemFont(ofSize: 14)
/// 系统默认字体
public let Font15 = UIFont.systemFont(ofSize: 15)
/// 系统默认字体
public let Font16 = UIFont.systemFont(ofSize: 16)

///根据屏幕自适应字体参数 16*FontFit
public let FontFit = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height) / 375

/// 系统默认字体
public func SystemFont(_ size: CGFloat) -> UIFont {
    return .systemFont(ofSize: size)
}
/// 系统默认字体
public func SystemFontBold(_ size: CGFloat) -> UIFont {
    return .boldSystemFont(ofSize: size)
}
/// 系统默认字体
public func SystemFont(_ size: CGFloat, weight: UIFont.Weight) -> UIFont {
    return .systemFont(ofSize: size, weight: weight)
}

public enum Weight {
    case medium
    case semibold
    case light
    case ultralight
    case regular
    case thin
}
/// pingfang-sc 字体
public func Font(_ size: CGFloat) -> UIFont {
    return FontWeight(size, weight: .regular)
}
/// pingfang-sc 字体
public func FontMedium(_ size: CGFloat) -> UIFont {
    return FontWeight(size, weight: .medium)
}
/// pingfang-sc 字体
public func FontBold(_ size: CGFloat) -> UIFont {
    return FontWeight(size, weight: .semibold)
}
/// pingfang-sc 字体
public func FontWeight(_ size: CGFloat, weight: Weight) -> UIFont {
    var name = ""
    switch weight {
    case .medium:
        name = "PingFangSC-Medium"
    case .semibold:
        name = "PingFangSC-Semibold"
    case .light:
        name = "PingFangSC-Light"
    case .ultralight:
        name = "PingFangSC-Ultralight"
    case .regular:
        name = "PingFangSC-Regular"
    case .thin:
        name = "PingFangSC-Thin"
    }
    return UIFont.init(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
}

// MARK:- 打印输出
//public func SLog<T>(_ message : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {
//    #if DEBUG
//        let fileName = (file as NSString).lastPathComponent
//        print("\n\n<><><><><>-「LOG」-<><><><><>\n\n>>>>>>>>>>>>>>>所在类:>>>>>>>>>>>>>>>\n\n\(fileName)\n\n>>>>>>>>>>>>>>>所在行:>>>>>>>>>>>>>>>\n\n\(lineNum)\n\n>>>>>>>>>>>>>>>信 息:>>>>>>>>>>>>>>>\n\n\(message)\n\n<><><><><>-「END」-<><><><><>\n\n")
//    #endif
//}

