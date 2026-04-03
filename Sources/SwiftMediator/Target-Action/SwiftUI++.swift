//
//  SwiftUI++.swift
//  SwiftMediator
//
//  Created by iOS on 2023/5/25.
//
//  SwiftUI 视图导航扩展 / SwiftUI View Navigation Extension
//  支持 SwiftUI View 的 Push 和 Pop 操作
//  Supports Push and Pop operations for SwiftUI Views

import SwiftUI
import UIKit

//MARK:--SwiftUI 路由跳转 / SwiftUI Navigation Routing--Swift
@available(iOS 13.0, *)
extension SwiftMediator {
    
    /// Push SwiftUI View 到导航栈 / Push a SwiftUI View onto the navigation stack
    /// - Parameters:
    ///   - view: SwiftUI 视图 / SwiftUI View
    ///   - title: 导航栏标题 / Navigation bar title
    public func push<V: View>(_ view: V, title: String? = nil) {
        pushToView(view: view, title: title)
    }
    
    /// 当前导航跳转到指定标题页面 / Pop to view controller with specified title in current navigation
    /// - Parameter navigationBarTitle: 导航栏标题 / Navigation bar title
    /// - Returns: 是否跳转成功 / Whether the navigation was successful
    @discardableResult
    public func popToTitle(_ navigationBarTitle: String) -> Bool {
        return popTo(navigationBarTitle)
    }
 
    /// 内部方法：将 SwiftUI View 包装为 VC 并 Push / Internal method: Wrap SwiftUI View as VC and push
    fileprivate func pushToView<V: View>(view: V, title: String? = nil) {
        guard let navigationController = UIViewController.currentNavigationController() else {
            return
        }
        
        let targetVC = view.getVC()
        
        if let title {
            targetVC.title = title
        }
        
        if !navigationController.children.contains(targetVC) {
            navigationController.pushViewController(targetVC, animated: true)
        }
    }
    
}

/// SwiftUI View 扩展 / SwiftUI View Extension
/// 提供将 View 转换为 UIViewController 的能力 / Provides ability to convert View to UIViewController
@available(iOS 13.0, *)
public extension View {
    /// 将当前 View 转换为 UIHostingController / Convert current View to UIHostingController
    /// - Returns: 包含该 View 的 UIViewController / UIViewController containing this View
    func getVC() -> UIViewController {
        return UIHostingController(rootView: self)
    }
}
