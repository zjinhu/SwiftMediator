//
//  SwiftMediator+Modal.swift
//  SwiftMediator
//
//  Created by iOS on 2023/5/25.
//
//  页面模态弹出扩展 / Modal Presentation Extension
//  支持 present/dismiss 操作及模态样式配置
//  Supports present/dismiss operations with modal style configuration

import Foundation
import UIKit

//MARK:--模态弹出 / Modal Presentation--Swift
extension SwiftMediator {
    /// 路由弹出 Present / Route and present a view controller modally
    /// - Parameters:
    ///   - vcName: 目标 VC 类名 / Target view controller class name
    ///   - moduleName: 目标 VC 所在组件名称 / Component name where target VC resides
    ///   - paramsDic: 参数字典 / Parameter dictionary
    ///   - fromVC: 从哪个页面弹出，不传则默认取最顶层 VC / Source view controller, defaults to top VC if not provided
    ///   - needNav: 是否需要导航栏 / Whether to wrap in navigation controller
    ///   - modelStyle: 模态样式 / Modal presentation style
    ///   - animated: 是否显示动画 / Whether to show animation
    public func present(_ vcName: String,
                        moduleName: String? = nil,
                        paramsDic: [String: Any]? = nil,
                        fromVC: UIViewController? = nil,
                        needNav: Bool = false,
                        modelStyle: UIModalPresentationStyle = .fullScreen,
                        animated: Bool = true) {
        
        guard let vc = initVC(vcName, moduleName: moduleName, dic: paramsDic) else { return }
        presentVC(needNav: needNav, animated: animated, modelStyle: modelStyle, vc: vc, fromVC: fromVC)
        
    }
    
    /// 简易 Present，需提前初始化 VC / Simple present, VC must be initialized beforehand
    /// - Parameters:
    ///   - vc: 已初始化的 VC 对象，可传 Nav 对象（自定义导航栏）/ Initialized VC object, can pass Nav object for custom navigation bar
    ///   - fromVC: 从哪个页面弹出，不传则路由取最顶层 VC / Source view controller, defaults to top VC if not provided
    ///   - needNav: 是否需要导航栏 / Whether to wrap in navigation controller
    ///   - modelStyle: 模态样式 / Modal presentation style
    ///   - animated: 是否显示动画 / Whether to show animation
    public func present(_ vc: UIViewController?,
                        fromVC: UIViewController? = nil,
                        needNav: Bool = false,
                        modelStyle: UIModalPresentationStyle = .fullScreen,
                        animated: Bool = true) {
        guard let vc = vc else { return }
        presentVC(needNav: needNav, animated: animated, modelStyle: modelStyle, vc: vc, fromVC: fromVC)
    }
    
    /// 内部方法：执行 Present 操作 / Internal method: Perform present operation
    fileprivate func presentVC(needNav: Bool,
                               animated: Bool,
                               modelStyle: UIModalPresentationStyle,
                               vc: UIViewController,
                               fromVC: UIViewController? = nil){
        var container = vc
        
        if needNav {
            let nav = UINavigationController(rootViewController: vc)
            container = nav
        }
 
        container.modalPresentationStyle = modelStyle
 
        guard let from = fromVC else {
            UIViewController.currentViewController()?.present(container, animated: animated, completion: nil)
            return
        }
        from.present(container, animated: animated, completion: nil)
    }
    
    /// 退出当前页面 / Dismiss current view controller
    /// 自动判断是 pop 还是 dismiss / Automatically determines whether to pop or dismiss
    /// - Parameter animated: 是否显示动画 / Whether to show animation
    public func dismissVC(animated: Bool = true) {
        let current = UIViewController.currentViewController()
        if let viewControllers: [UIViewController] = current?.navigationController?.viewControllers {
            guard viewControllers.count <= 1 else {
                current?.navigationController?.popViewController(animated: animated)
                return
            }
        }
        
        if let _ = current?.presentingViewController {
            current?.dismiss(animated: animated, completion: nil)
        }
    }
}
