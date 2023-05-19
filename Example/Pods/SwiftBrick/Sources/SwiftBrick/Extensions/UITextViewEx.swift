//
//  UITextViewSnapEx.swift
//  SwiftBrick
//
//  Created by iOS on 22/11/2019.
//  Copyright © 2019 狄烨 . All rights reserved.
//

import UIKit

fileprivate var kTextViewPlaceholderLabel: Int = 0x2019_00
fileprivate var kTextViewPlaceholder     : Int = 0x2019_01
fileprivate var kTextViewPlaceholderColor: Int = 0x2019_02
fileprivate var kTextViewPlaceholderFont : Int = 0x2019_03
fileprivate var kTextViewPlaceholderKeys : Int = 0x2019_04

public extension UITextView {
    
    /// 占位符
    var placeholder: String {
        get {
            if let placeholder = objc_getAssociatedObject(self, &kTextViewPlaceholder) as? String {
                return placeholder
            } else {
                return ""
            }
        }
        set {
            objc_setAssociatedObject(self, &kTextViewPlaceholder, newValue, .OBJC_ASSOCIATION_RETAIN)
            holderLabel.text = newValue
        }
    }
    
    /// 占位符颜色
    var holderColor: UIColor {
        get {
            if let placeholderColor = objc_getAssociatedObject(self, &kTextViewPlaceholderColor) as? UIColor {
                return placeholderColor
            } else {
                return .darkText
            }
        }
        set {
            objc_setAssociatedObject(self, &kTextViewPlaceholderColor, newValue, .OBJC_ASSOCIATION_RETAIN)
            holderLabel.textColor = newValue
        }
    }
    
    /// 占位符字体
    var holderFont: UIFont {
        get {
            if let placeholderFont = objc_getAssociatedObject(self, &kTextViewPlaceholderColor) as? UIFont {
                return placeholderFont
            } else {
                return UIFont.systemFont(ofSize: 12)
            }
        }
        set {
            objc_setAssociatedObject(self, &kTextViewPlaceholderColor, newValue, .OBJC_ASSOCIATION_RETAIN)
            holderLabel.font = newValue
        }
    }
    
    /// 占位符 标签
    var holderLabel: UILabel {
        get {
            var _holderLabel = UILabel()
            _holderLabel.font = font ?? UIFont.systemFont(ofSize: 12)
            _holderLabel.textColor = .darkText
            _holderLabel.textAlignment = .left
            
            _holderLabel.translatesAutoresizingMaskIntoConstraints = false

            if let label = objc_getAssociatedObject(self, &kTextViewPlaceholderLabel) as? UILabel {
                _holderLabel = label
            } else {
                objc_setAssociatedObject(self, &kTextViewPlaceholderLabel, _holderLabel, .OBJC_ASSOCIATION_RETAIN)
            }
            
            addPlaceholderLabelToSuperView(label: _holderLabel)
            
            return _holderLabel
        }
        set {
            objc_setAssociatedObject(self, &kTextViewPlaceholderLabel, newValue, .OBJC_ASSOCIATION_RETAIN)
            addPlaceholderLabelToSuperView(label: newValue)
        }
    }
    
    /// 是否需要添加占位符到父视图
    fileprivate var holderNeedAddToSuperView: Bool {
        get {
            if let isAdded = objc_getAssociatedObject(self, &kTextViewPlaceholderKeys) as? Bool {
                return isAdded
            }
            return true
        }
        set {
            objc_setAssociatedObject(self, &kTextViewPlaceholderKeys, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// 添加占位符到父视图
    ///
    /// - Parameter label: 占位符 标签
    fileprivate func addPlaceholderLabelToSuperView(label: UILabel) {
        
        guard holderNeedAddToSuperView else { return }
        holderNeedAddToSuperView = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(jh_textChange(noti:)), name: UITextView.textDidChangeNotification, object: nil)

        addSubview(label)

        let constraints = [
            label.topAnchor.constraint(equalTo: topAnchor, constant: 7),
            label.leftAnchor.constraint(equalTo: leftAnchor, constant: 2),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.rightAnchor.constraint(equalTo: rightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)

    }
    
    /// 编辑事件
    @objc fileprivate func jh_textChange(noti: NSNotification) {
        let isEmpty = text.isEmpty
        print("text:\(String(describing: text))\nisEmpty:\(isEmpty)")
        holderLabel.text = isEmpty ? placeholder: ""
        holderLabel.isHidden = !isEmpty
    }
    
}
