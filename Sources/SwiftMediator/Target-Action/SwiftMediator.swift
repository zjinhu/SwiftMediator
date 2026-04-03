//MARK:--核心中介类 / Core Mediator Class--Swift//
//  SwiftMediator.swift
//  SwiftMediator
//
//  Created by iOS on 27/11/2019.
//  Copyright © 2019 狄烨 . All rights reserved.
//
//  路由与模块解耦工具 / Routing and Module Decoupling Tool
//  基于 Target-Action 模式，支持字符串类名反射、字典参数传递、URL路由跳转
//  Based on Target-Action pattern, supports string-based class name reflection,
//  dictionary parameter passing, and URL-based routing

import UIKit
import Foundation

/// SwiftMediator 核心单例类 / Core Singleton Class
/// 用于模块间通信、页面跳转、方法调用等 / Used for inter-module communication, page navigation, method invocation, etc.
public class SwiftMediator {
    /// 全局共享单例 / Global shared singleton
    public static let shared = SwiftMediator()
    
    /// 私有初始化方法，确保单例唯一性 / Private initializer to ensure singleton uniqueness
    private init(){ }
}

extension SwiftMediator {
    /// Resolve module namespace safely and avoid force-unwrapping bundle metadata.
    func resolvedNamespace(_ moduleName: String?) -> String {
        if let moduleName, !moduleName.isEmpty {
            return moduleName
        }
        if let executable = Bundle.main.object(forInfoDictionaryKey: "CFBundleExecutable") as? String, !executable.isEmpty {
            return executable
        }
        if let bundleIdentifier = Bundle.main.bundleIdentifier,
           let last = bundleIdentifier.split(separator: ".").last,
           !last.isEmpty {
            return String(last)
        }
        return ""
    }
}
