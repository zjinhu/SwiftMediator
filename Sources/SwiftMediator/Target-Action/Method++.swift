//
//  SwiftMediator+Method.swift
//  SwiftMediator
//
//  Created by iOS on 2023/5/25.
//
//  方法路由调用扩展 / Method Routing Invocation Extension
//  支持实例方法和类方法的动态调用
//  Supports dynamic invocation of instance methods and class methods

import Foundation

//MARK:--方法路由调用 / Method Routing Invocation--Swift
extension SwiftMediator {
    /// 路由调用实例对象方法 / Route and invoke instance method
    /// - 注意: 方法必须标记 @objc，例如: @objc func methodName(_ param: Any) / Method must be marked @objc
    /// - Parameters:
    ///   - objc: 已初始化的对象实例 / Initialized object instance
    ///   - selName: 方法名 / Method name
    ///   - param: 第一个参数 / First parameter
    ///   - otherParam: 第二个参数 / Second parameter
    /// - Returns: 方法执行结果 / Execution result, or nil if method not found
    @discardableResult
    public func callObjcMethod(objc: AnyObject,
                               selName: String,
                               param: Any? = nil,
                               otherParam: Any? = nil ) -> Unmanaged<AnyObject>?{
        
        let sel = NSSelectorFromString(selName)
        guard let _ = class_getInstanceMethod(type(of: objc), sel) else {
            return nil
        }
        return objc.perform(sel, with: param, with: otherParam)
    }
    
    /// 路由调用类方法 / Route and invoke class method
    /// - 注意: 方法必须标记 @objc，例如: @objc class func methodName(_ param: Any) / Method must be marked @objc
    /// - Parameters:
    ///   - className: 类名 / Class name
    ///   - selName: 方法名 / Method name
    ///   - moduleName: 组件名称 / Component bundle name
    ///   - param: 第一个参数 / First parameter
    ///   - otherParam: 第二个参数 / Second parameter
    /// - Returns: 方法执行结果 / Execution result, or nil if class or method not found
    @discardableResult
    public func callClassMethod(className: String,
                                selName: String,
                                moduleName: String? = nil,
                                param: Any? = nil,
                                otherParam: Any? = nil ) -> Unmanaged<AnyObject>?{
        let namespace = resolvedNamespace(moduleName)
        let className = "\(namespace).\(className)"
        guard let cls: AnyObject? = NSClassFromString(className) else {
            return nil
        }
        
        let sel = NSSelectorFromString(selName)
        guard let _ = class_getClassMethod(cls as? AnyClass, sel) else {
            return nil
        }
        
        return cls?.perform(sel, with: param, with: otherParam)
    }
    
}
