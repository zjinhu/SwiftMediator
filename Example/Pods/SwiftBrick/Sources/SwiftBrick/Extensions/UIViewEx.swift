//
//  UIViewEx.swift
//  ClassTable
//
//  Created by iOS on 2020/7/30.
//  Copyright © 2020 iOS. All rights reserved.
//

import Foundation
import UIKit
// MARK: ===================================扩展: 渐变色背景色=========================================
public enum GradientPoint{
    case left
    case top
    case right
    case bottom
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    
    public var point: CGPoint {
        switch self {
        case .left:         return CGPoint(x: 0.0, y: 0.5)
        case .top:          return CGPoint(x: 0.5, y: 0.0)
        case .right:        return CGPoint(x: 1.0, y: 0.5)
        case .bottom:       return CGPoint(x: 0.5, y: 1.0)
        case .topLeft:      return CGPoint(x: 0.0, y: 0.0)
        case .topRight:     return CGPoint(x: 1.0, y: 0.0)
        case .bottomLeft:   return CGPoint(x: 0.0, y: 1.0)
        case .bottomRight:  return CGPoint(x: 1.0, y: 1.0)
        }
    }
}

public extension UIView{
    
    /// 添加背景色,主要是渐变色背景
    /// - Parameters:
    ///   - colors: 背景色数组,一个的话仅仅是设置背景色,多个的话会设置渐变色
    ///   - size: 视图大小,默认self.bounds,snap的需要注意layoutifneed
    ///   - startPoint: 渐变色起点
    ///   - endPoint: 渐变色终点
    func setBackColor(_ colors: [UIColor],
                      size: CGSize? = nil,
                      startPoint: CGPoint = GradientPoint.topLeft.point,
                      endPoint: CGPoint = GradientPoint.bottomLeft.point){

        guard colors.count >= 1 else {
            return
        }
        
        removeGradients()
        
        if colors.count < 2 {
            backgroundColor = colors.first
        }else{
            
            let gradient: CAGradientLayer = colors.gradient { gradient in
                gradient.startPoint = startPoint
                gradient.endPoint = endPoint
                return gradient
            }
            
            gradient.drawsAsynchronously = true
            layer.insertSublayer(gradient, at: 0)
            if let s = size{
                gradient.frame = .init(x: 0, y: 0, width: s.width, height: s.height)
            }else{
              gradient.frame = self.bounds
            }
        }
    }
    
    func addGradient(_ gradient: CAGradientLayer,
                     size: CGSize? = nil){
        
        removeGradients()
        
        gradient.drawsAsynchronously = true
        layer.insertSublayer(gradient, at: 0)
        if let s = size{
            gradient.frame = .init(x: 0, y: 0, width: s.width, height: s.height)
        }else{
            gradient.frame = self.bounds
        }
        
    }
    
    /// 移除渐变色背景
    func removeGradients() {
        if let sl = self.layer.sublayers {
            for layer in sl {
                if layer.isKind(of: CAGradientLayer.self) {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
}

public extension UIView {
    //返回该view所在VC,方便埋点查找
    func firstViewController() -> UIViewController? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let responder = view?.next {
                if responder.isKind(of: UIViewController.self){
                    return responder as? UIViewController
                }
            }
        }
        return nil
    }
}

public extension UIView {
    ///初始化View闭包--方便快速
    static func inits<T: UIView>(_ builder: ((T) -> Void)? = nil) -> T {
        let view = T()
        view.translatesAutoresizingMaskIntoConstraints = false
        builder?(view)
        return view
    }
}

public extension UIView {
    
    struct AssociatedKeys {
        static var tapGestureKey: String = "TapGestureKey"
    }
    
    typealias tapGestureClosure = (_ view: UIView) -> Void
    
    @objc internal var tapGesture: tapGestureClosure? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.tapGestureKey) as? tapGestureClosure
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.tapGestureKey, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
    
    @objc func addTapGestureWithCallback(tapGesture closure: tapGestureClosure?){
        tapGesture = closure
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        addGestureRecognizer(tap)
    }
    
    
    @objc func handleTapGesture() {
        if let closure = tapGesture{
            closure(self)
        }
        
    }
    
}

@propertyWrapper
public struct UsesAutoLayout<T: UIView> {
    public var wrappedValue: T {
        didSet {
            wrappedValue.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        wrappedValue.translatesAutoresizingMaskIntoConstraints = false
    }
}
