//
//  UITextViewSnapEx.swift
//  SwiftBrick
//
//  Created by iOS on 22/11/2019.
//  Copyright © 2019 狄烨 . All rights reserved.
//

import UIKit
import SnapKit

fileprivate var kTextViewPlaceholderLabel : Int = 0x2019_00
fileprivate var kTextViewPlaceholder      : Int = 0x2019_01
fileprivate var kTextViewPlaceholderColor : Int = 0x2019_02
fileprivate var kTextViewPlaceholderFont  : Int = 0x2019_03
fileprivate var kTextViewPlaceholderKeys  : Int = 0x2019_04


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
            var _holderLabel = UILabel.init()
            _holderLabel.font = font ?? UIFont.systemFont(ofSize: 12)
            _holderLabel.textColor = .darkText
            _holderLabel.textAlignment = .left
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
        label.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 7, left: 2, bottom: 0, right: 0))
        }
    }
    
    /// 编辑事件
    @objc fileprivate func jh_textChange(noti: NSNotification) {
        let isEmpty = text.isEmpty
        print("text:\(String(describing: text))\nisEmpty:\(isEmpty)")
        holderLabel.text = isEmpty ? placeholder : ""
        holderLabel.isHidden = !isEmpty
    }
    
    
    /// 快速初始化UITextView 包含默认参数,初始化过程可以删除部分默认参数简化方法
    /// - Parameters:
    ///   - holderFont: 占位字体  有默认参数
    ///   - holder: 占位文字  有默认参数
    ///   - holderColor: 占位文字颜色  有默认参数
    ///   - font: 正文字体  有默认参数
    ///   - text: 正文  有默认参数
    ///   - textColor: 正文字体颜色  有默认参数
    ///   - textAlignment: textAlignment  有默认参数
    ///   - supView: 被添加的位置 有默认参数
    ///   - snapKitMaker: SnapKit 有默认参数
    ///   - delegate: 代理
    ///   - backColor: 背景色
    @discardableResult
    class func snpTextView(supView: UIView? = nil,
                           backColor: UIColor? = .clear,
                           holderFont: UIFont = UIFont.systemFont(ofSize: 14),
                           holder: String = "",
                           holderColor: UIColor = .black,
                           font: UIFont = UIFont.systemFont(ofSize: 14),
                           text: String = "",
                           textColor: UIColor = .black,
                           textAlignment: NSTextAlignment = .left,
                           delegate: UITextViewDelegate? = nil,
                           snapKitMaker : ((ConstraintMaker) -> Void)? = nil) -> UITextView {
        
        let textView = UITextView.init()
        textView.holderFont = holderFont
        textView.holderColor = holderColor
        textView.placeholder = holder
        
        textView.text = text
        textView.textColor = textColor
        textView.font = font
        
        textView.textAlignment = textAlignment
        
        if delegate != nil {
          textView.delegate = delegate
        }
        
        textView.backgroundColor = backColor
        
        guard let sv = supView, let maker = snapKitMaker else {
            return textView
        }
        sv.addSubview(textView)
        textView.snp.makeConstraints { (make) in
            maker(make)
        }
        
        return textView
    }
    
}
