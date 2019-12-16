//
//  UIViewSnapExtension.swift
//  SwiftBrick
//
//  Created by iOS on 20/11/2019.
//  Copyright © 2019 狄烨 . All rights reserved.
//

import UIKit

public extension UIView {
    
    @objc internal var snpTapGesture: JHSnapKitTool.JHTapGestureBlock? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.TapGestureKey) as? JHSnapKitTool.JHTapGestureBlock
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.TapGestureKey, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
    
    /// 快速初始化UIView 包含默认参数,初始化过程可以删除部分默认参数简化方法
    /// - Parameters:
    ///   - supView: 被添加的位置 有默认参数
    ///   - snapKitMaker: SnapKit 有默认参数
    ///   - snpTapGesture: 点击Block 有默认参数
    ///   - backColor: 背景色
    class func snpView(supView : UIView? = nil,
                       snapKitMaker : JHSnapKitTool.JHSnapMaker? = nil,
                       snpTapGesture : JHSnapKitTool.JHTapGestureBlock? = nil,
                       backColor: UIColor) -> UIView{
        
        let view = UIView.init()
        view.backgroundColor = backColor
        
        if supView != nil{
            supView?.addSubview(view)
            view.snp.makeConstraints { (make) in
                snapKitMaker!(make)
            }
        }
        
        if snpTapGesture != nil {
            view.snpAddTapGestureWithCallback(snpTapGesture: snpTapGesture)
        }
        
        return view
    }
    
    @objc func snpAddTapGestureWithCallback(snpTapGesture : JHSnapKitTool.JHTapGestureBlock?){
        self.snpTapGesture = snpTapGesture
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tap)
    }
    
    
    @objc func handleTapGesture() {
        if let snpTapGesture =  self.snpTapGesture{
            snpTapGesture(self)
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
