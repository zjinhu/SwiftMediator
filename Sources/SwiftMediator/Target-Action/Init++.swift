//
//  SwiftMediator+Init.swift
//  SwiftMediator
//
//  Created by iOS on 2023/5/25.
//
//  对象反射初始化扩展 / Object Reflection Initialization Extension
//  支持 UIViewController、NSObject、UIView 的反射创建与属性赋值
//  Supports reflection-based creation and property assignment for UIViewController, NSObject, UIView

import Foundation
import UIKit

//MARK:--对象反射初始化 / Object Reflection Initialization--Swift
extension SwiftMediator {
    
    /// 反射初始化 UIViewController 并赋值 / Reflect and initialize UIViewController with property assignment
    /// - Parameters:
    ///   - vcName: UIViewController 类名 / UIViewController class name
    ///   - moduleName: 组件 Bundle 名称，不传则使用默认命名空间 / Component bundle name, defaults to main namespace if not provided
    ///   - dic: 参数字典，因使用 KVC 赋值，属性需标记 @objc / Parameter dictionary, properties must be marked @objc since KVC is used
    /// - Returns: 初始化后的 UIViewController 实例 / Initialized UIViewController instance, or nil if failed
    @discardableResult
    public func initVC(_ vcName: String,
                       moduleName: String? = nil,
                       dic: [String: Any]? = nil) -> UIViewController?{
        
        var namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        if let name = moduleName {
            namespace = name
        }
        
        let className = "\(namespace).\(vcName)"
        let cls: AnyClass? = NSClassFromString(className)
        guard let vc = cls as? UIViewController.Type else {
            return nil
        }
        let controller = vc.init()
        setObjectParams(obj: controller, paramsDic: dic)
        return controller
    }
    
    /// 反射初始化 NSObject 子类并赋值 / Reflect and initialize NSObject subclass with property assignment
    /// - Parameters:
    ///   - objcName: 类名 / Class name
    ///   - moduleName: 组件 Bundle 名称 / Component bundle name
    ///   - dic: 参数字典，因使用 KVC 赋值，属性需标记 @objc / Parameter dictionary, properties must be marked @objc since KVC is used
    /// - Returns: 初始化后的 NSObject 实例 / Initialized NSObject instance, or nil if failed
    @discardableResult
    public func initObjc(_ objcName: String,
                         moduleName: String? = nil,
                         dic: [String : Any]? = nil) -> NSObject?{
        
        var namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        if let name = moduleName {
            namespace = name
        }
        
        let className = "\(namespace).\(objcName)"
        let cls: AnyClass? = NSClassFromString(className)
        guard let ob = cls as? NSObject.Type else {
            return nil
        }
        let objc = ob.init()
        setObjectParams(obj: objc, paramsDic: dic)
        return objc
    }
    
    /// 反射初始化 UIView 并赋值 / Reflect and initialize UIView with property assignment
    /// - Parameters:
    ///   - viewName: UIView 类名 / UIView class name
    ///   - moduleName: 组件 Bundle 名称，不传则使用默认命名空间 / Component bundle name, defaults to main namespace if not provided
    ///   - dic: 参数字典，因使用 KVC 赋值，属性需标记 @objc / Parameter dictionary, properties must be marked @objc since KVC is used
    /// - Returns: 初始化后的 UIView 实例 / Initialized UIView instance, or nil if failed
    @discardableResult
    public func initView(_ viewName: String,
                       moduleName: String? = nil,
                       dic: [String: Any]? = nil) -> UIView?{
        
        var namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        if let name = moduleName {
            namespace = name
        }
        
        let className = "\(namespace).\(viewName)"
        let cls: AnyClass? = NSClassFromString(className)
        guard let vc = cls as? UIView.Type else {
            return nil
        }
        let view = vc.init()
        setObjectParams(obj: view, paramsDic: dic)
        return view
    }

}
