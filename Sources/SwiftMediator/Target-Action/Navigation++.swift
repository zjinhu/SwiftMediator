//
//  SwiftMediator+Navigation.swift
//  SwiftMediator
//
//  Created by iOS on 2023/5/25.
//
//  页面导航跳转扩展 / Navigation Routing Extension
//  支持 Push、Pop、PopTo 等导航操作
//  Supports Push, Pop, PopTo and other navigation operations

import UIKit
import Foundation

//MARK:--路由跳转 / Navigation Routing--Swift
extension SwiftMediator {
    
    /// 路由 Push 页面 / Route and push a view controller
    /// - Parameters:
    ///   - vcName: 目标 VC 类名 / Target view controller class name
    ///   - moduleName: 目标 VC 所在组件名称 / Component name where target VC resides
    ///   - fromVC: 从哪个页面跳转，不传则默认取最顶层 VC / Source view controller, defaults to top VC if not provided
    ///   - paramsDic: 参数字典 / Parameter dictionary
    ///   - animated: 是否显示动画 / Whether to show animation
    public func push(_ vcName: String,
                     moduleName: String? = nil,
                     fromVC: UIViewController? = nil,
                     paramsDic:[String:Any]? = nil,
                     animated: Bool = true) {
        
        guard let vc = initVC(vcName, moduleName: moduleName, dic: paramsDic) else { return }
        pushVC(animated: animated, vc: vc, fromVC: fromVC)
    }
    
    /// 简易 Push，需提前初始化 VC / Simple push, VC must be initialized beforehand
    /// - Parameters:
    ///   - vc: 已初始化的 VC 对象 / Initialized view controller object
    ///   - fromVC: 从哪个页面跳转，不传则路由取最顶层 VC / Source view controller, defaults to top VC if not provided
    ///   - animated: 是否显示动画 / Whether to show animation
    public func push(_ vc: UIViewController?,
                     fromVC: UIViewController? = nil,
                     animated: Bool = true) {
        guard let vc = vc else { return }
        pushVC(animated: animated, vc: vc, fromVC: fromVC)
    }
    
    
    /// 当前导航返回上一页 / Pop to previous page in current navigation stack
    /// - Parameter animated: 是否显示动画 / Whether to show animation
    public func pop(animated: Bool = true){
        guard let nav = UIViewController.currentNavigationController() else { return }
        nav.popViewController(animated: animated)
    }
    
    
    /// 当前导航返回根页面 / Pop to root page in current navigation stack
    /// - Parameter animated: 是否显示动画 / Whether to show animation
    public func popToRoot(animated: Bool = true){
        guard let nav = UIViewController.currentNavigationController() else { return }
        nav.popToRootViewController(animated: animated)
    }
    
    /// 当前导航跳转到指定页面 / Pop to specified view controller in current navigation stack
    /// - Parameter vc: 目标页面 / Target view controller
    /// - Returns: 是否跳转成功 / Whether the navigation was successful
    @discardableResult
    public func popTo(_ vc: UIViewController) -> Bool {
        guard let navigationController = UIViewController.currentNavigationController() else {
            return false
        }
        
        if navigationController.children.contains(vc){
            navigationController.popToViewController(vc, animated: true)
            return true
        }
        
        return false
    }
    
    /// 当前导航跳转到指定索引页面 / Pop to view controller at specified index in current navigation stack
    /// - Parameter index: 页面索引 / Page index
    /// - Returns: 是否跳转成功 / Whether the navigation was successful
    @discardableResult
    public func popTo(_ index: Int) -> Bool {
        guard let navigationController = UIViewController.currentNavigationController(), index >= 0 else {
            return false
        }
        
        if index < navigationController.children.count - 1{
            let vc = navigationController.children[index]
            navigationController.popToViewController(vc, animated: true)
        }
        return false
    }
    
    /// 当前导航跳转到指定标题页面 / Pop to view controller with specified title in current navigation stack
    /// - Parameter navigationBarTitle: 导航栏标题 / Navigation bar title
    /// - Returns: 是否跳转成功 / Whether the navigation was successful
    @discardableResult
    public func popTo(_ navigationBarTitle: String) -> Bool {
        guard let navigationController = UIViewController.currentNavigationController() else {
            return false
        }
        
        for vc in navigationController.children {
            if vc.navigationItem.title == navigationBarTitle {
                navigationController.popToViewController(vc, animated: true)
                return true
            }
        }
        
        return false
    }
    
    /// 内部方法：执行 Push 操作 / Internal method: Perform push operation
    fileprivate func pushVC(animated: Bool,
                            vc: UIViewController,
                            fromVC: UIViewController? = nil){
        
        vc.hidesBottomBarWhenPushed = true
        guard let from = fromVC else {
            UIViewController.currentNavigationController()?.pushViewController(vc, animated: animated)
            return
        }
        from.navigationController?.pushViewController(vc, animated: animated)
    }
    
    
    /// 创建导航栈 / Create a new navigation stack with specified view controllers
    /// - Parameter controllers: 视图控制器数组 / Array of view controllers
    fileprivate func createNavigationStack(controllers: [UIViewController]) {
        guard let window = UIWindow.keyWindow else { return }
        
        let navigationController = UINavigationController()
        navigationController.viewControllers = controllers
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
    }
    
    /// 清空当前导航栈所有页面 / Remove all pages from current navigation stack
    fileprivate func removeNavigationStack() {
        guard let navigationController = UIViewController.currentNavigationController() else {
            return
        }
        navigationController.children.forEach({
            $0.willMove(toParent: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        })
    }
}

//MARK:--获取对象所在命名空间 / Get Object's Namespace--Swift
public extension NSObject {
    
    /// 获取对象所在的模块命名空间 / Get the module namespace where the object resides
    /// - Returns: 命名空间字符串 / Namespace string
    func getModuleName() -> String{
        let name = type(of: self).description()
        guard let module : String = name.components(separatedBy: ".").first else {
            return Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        }
        return module
    }
}
