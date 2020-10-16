//
//  UIStackViewSnapEx.swift
//  SwiftBrick
//
//  Created by iOS on 2020/10/10.
//  Copyright © 2020 狄烨 . All rights reserved.
//

import UIKit
import SnapKit
public extension UIStackView {
    
    /// 快速创建UIStackView
    /// - Parameters:
    ///   - supView: 被添加的位置 有默认参数
    ///   - backColor: 背景色
    ///   - cornerRadius: 圆角
    ///   - axis: 方向 横向或竖向
    ///   - spacing: 间距
    ///   - alignment: 主方向上以怎样的方式对齐
    ///   - distribution: 以怎样的方式存在
    ///   - autoLayout: 是否自适应大小
    ///   - snapKitMaker: 布局回调
    /// - Returns: UIStackView
    @discardableResult
    class func snpStackView(supView: UIView? = nil,
                            backColor: UIColor = .clear,
                            cornerRadius: CGFloat = 0.0,
                            axis: NSLayoutConstraint.Axis,
                            spacing: CGFloat = 0.0,
                            alignment: UIStackView.Alignment = .fill,
                            distribution: UIStackView.Distribution = .fill,
                            autoLayout: Bool = false,
                            snapKitMaker: ((ConstraintMaker) -> Void)? = nil) -> UIView {
        
        let view = UIStackView(axis: axis, spacing: spacing, alignment: alignment, distribution: distribution, autoLayout: autoLayout)
        view.addBackground(color: backColor, cornerRadius: cornerRadius)
        
        guard let sv = supView, let maker = snapKitMaker else {
            return view
        }
        sv.addSubview(view)
        view.snp.makeConstraints { (make) in
            maker(make)
        }
        
        return view
    }
    
    /// 创建UIStackView
    /// - Parameters:
    ///   - axis: 方向 横向或竖向
    ///   - spacing: 间距
    ///   - alignment: 主方向上以怎样的方式对齐
    ///   - distribution: 以怎样的方式存在
    ///   - autoLayout: 是否自适应大小
    convenience init(axis: NSLayoutConstraint.Axis,
                     spacing: CGFloat = 0.0,
                     alignment: UIStackView.Alignment = .fill,
                     distribution: UIStackView.Distribution = .fill,
                     autoLayout: Bool = false) {
        self.init()
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = distribution
        if !autoLayout {
            self.translatesAutoresizingMaskIntoConstraints = false
            self.setContentCompressionResistancePriority(UILayoutPriority.required, for: axis)
        }
        
    }
    
    func addBackground(color: UIColor = .clear, cornerRadius: CGFloat = 0) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
        
        subView.layer.cornerRadius = cornerRadius
        subView.layer.masksToBounds = true
        subView.clipsToBounds = true
    }
    
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { (view) in
            addArrangedSubview(view)
        }
    }
    
    func removeArrangedView(_ view: UIView){
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }
    
    func removeArrangedSubviews() {
        arrangedSubviews.forEach { (view) in
            removeArrangedView(view)
        }
    }
}
