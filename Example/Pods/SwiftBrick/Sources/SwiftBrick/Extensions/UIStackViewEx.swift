//
//  UIStackViewSnapEx.swift
//  SwiftBrick
//
//  Created by iOS on 2020/10/10.
//  Copyright © 2020 狄烨 . All rights reserved.
//

import UIKit
 
public extension UIStackView {

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
