//
//  UIGestureRecognizerExtension.swift
//  SwiftBrick
//
//  Created by iOS on 21/11/2019.
//  Copyright © 2019 狄烨 . All rights reserved.
//

import UIKit
import Foundation
// MARK: ===================================扩展: UIGestureRecognizer 点击手势闭包=========================================
public extension UIGestureRecognizer {
    private class GestureAction {
        var action: (UIGestureRecognizer) -> Void
        
        init(action closure: @escaping (UIGestureRecognizer) -> Void) {
            action = closure
        }
    }
    
    private struct AssociatedKeys {
        static var ActionName = "action"
    }
    
    private var gestureAction: GestureAction? {
        set { objc_setAssociatedObject(self, &AssociatedKeys.ActionName, newValue, .OBJC_ASSOCIATION_RETAIN) }
        get { return objc_getAssociatedObject(self, &AssociatedKeys.ActionName) as? GestureAction }
    }

    convenience init(action: @escaping (UIGestureRecognizer) -> Void) {
        self.init()
        gestureAction = GestureAction(action: action)
        addTarget(self, action: #selector(handleAction(_:)))
    }
    
    @objc dynamic private func handleAction(_ recognizer: UIGestureRecognizer) {
        gestureAction?.action(recognizer)
    }
}
