//
//  SwiftUI++.swift
//  SwiftMediator
//
//  Created by iOS on 2023/5/25.
//

import SwiftUI
import UIKit
//MARK:--route jump--code jump SwiftUI
@available(iOS 13.0, *)
extension SwiftMediator {
    
    /// push SwiftUI View
    /// - Parameters:
    ///   - view: View
    ///   - title: title
    public func push<V: View>(_ view: V, title: String? = nil) {
        pushToView(view: view, title: title)
    }
    
    /// The current SwiftUI View pops to the specified title
    /// - Parameter navigationBarTitle
    /// - Returns: Bool
    @discardableResult
    public func popToTitle(_ navigationBarTitle: String) -> Bool {
        return popTo(navigationBarTitle)
    }
 
    /// Set the current View to Navigation Root
    /// - Parameter view: View
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

@available(iOS 13.0, *)
public extension View {
    func getVC() -> UIViewController {
        return UIHostingController(rootView: self)
    }
}

