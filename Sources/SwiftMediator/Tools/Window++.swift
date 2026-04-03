//
//  UIWindow+.swift
//  SwiftMediator
//
//  Created by iOS on 2023/5/25.
//
//  UIWindow 工具扩展 / UIWindow Utility Extension
//  提供获取 keyWindow 和当前 UIWindowScene 的能力
//  Provides ability to get keyWindow and current UIWindowScene

import UIKit
import Foundation

/// UIWindow 扩展 / UIWindow Extension
extension UIWindow {
    /// 获取当前 keyWindow / Get current key window
    /// 兼容 iOS 13+ 的 Scene 架构和旧版 UIApplication / Compatible with iOS 13+ Scene architecture and legacy UIApplication
    public static var keyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .sorted { $0.activationState.sortPriority < $1.activationState.sortPriority }
                .compactMap { $0 as? UIWindowScene }
                .compactMap { $0.windows.first { $0.isKeyWindow } }
                .first
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}

/// UIWindowScene 扩展 / UIWindowScene Extension
@available(iOS 13.0, *)
extension UIWindowScene {
    /// 获取当前活跃的 UIWindowScene / Get current active UIWindowScene
    public static var currentWindowScene: UIWindowScene?  {
        for scene in UIApplication.shared.connectedScenes{
            if scene.activationState == .foregroundActive{
                return scene as? UIWindowScene
            }
        }
        return nil
    }
}

/// UIScene.ActivationState 扩展 / UIScene.ActivationState Extension
/// 用于场景激活状态的优先级排序 / Used for sorting scene activation state priority
@available(iOS 13.0, *)
private extension UIScene.ActivationState {
    /// 激活状态优先级，数值越小优先级越高 / Activation state priority, lower value means higher priority
    var sortPriority: Int {
        switch self {
        case .foregroundActive: return 1
        case .foregroundInactive: return 2
        case .background: return 3
        case .unattached: return 4
        @unknown default: return 5
        }
    }
}
