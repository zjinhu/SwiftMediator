//
//  UIViewSnapExtension.swift
//  SwiftBrick
//
//  Created by iOS on 20/11/2019.
//  Copyright © 2019 狄烨 . All rights reserved.
//

import UIKit
import SnapKit
public extension UIView {
    
    struct AssociatedKeys {
        static var tapGestureKey: String = "TapGestureKey"
    }
    
    typealias tapGestureClosure = (_ view: UIView) -> Void
    
    @objc internal var snpTapGesture: tapGestureClosure? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.tapGestureKey) as? tapGestureClosure
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.tapGestureKey, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
    
    /// 快速初始化UIView 包含默认参数,初始化过程可以删除部分默认参数简化方法
    /// - Parameters:
    ///   - supView: 被添加的位置 有默认参数
    ///   - snapKitMaker: SnapKit 有默认参数
    ///   - snpTapGesture: 点击Block 有默认参数
    ///   - backColor: 背景色
    @discardableResult
    class func snpView(supView: UIView? = nil,
                       backColor: UIColor? = .clear,
                       tapGesture: tapGestureClosure? = nil,
                       snapKitMaker: ((ConstraintMaker) -> Void)? = nil) -> UIView {
        
        let view = UIView.init()
        view.backgroundColor = backColor

        guard let sv = supView, let maker = snapKitMaker else {
            return view
        }
        sv.addSubview(view)
        view.snp.makeConstraints { (make) in
            maker(make)
        }
        
        guard let ges = tapGesture else {
            return view
        }
        view.snpAddTapGestureWithCallback(tapGesture: ges)

        
        return view
    }
    
    @objc func snpAddTapGestureWithCallback(tapGesture closure : tapGestureClosure?){
        snpTapGesture = closure
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleTapGesture))
        addGestureRecognizer(tap)
    }
    
    
    @objc func handleTapGesture() {
        if let closure = snpTapGesture{
            closure(self)
        }
        
    }
    
}

// MARK: - 命名空间方案,废弃,没减少一行代码
//extension UIView: ViewMaker { }
//extension Maker where T: UIView {
//    public func adhere(toSuperView: UIView) -> T {
//        toSuperView.addSubview(makerValue)
//        return makerValue
//    }
//
//    @discardableResult
//    public func layout(snapKitMaker: (ConstraintMaker) -> Void) -> T {
//        makerValue.snp.makeConstraints { (make) in
//            snapKitMaker(make)
//        }
//        return makerValue
//    }
//
//    @discardableResult
//    public func config(_ config: (T) -> Void) -> T {
//        config(makerValue)
//        return makerValue
//    }
//}
