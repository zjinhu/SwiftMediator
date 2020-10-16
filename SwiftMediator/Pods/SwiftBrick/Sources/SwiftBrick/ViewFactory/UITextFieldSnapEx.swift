//
//  UITextFieldSnapEx.swift
//  SwiftBrick
//
//  Created by iOS on 22/11/2019.
//  Copyright © 2019 狄烨 . All rights reserved.
//

import UIKit
import SnapKit
public extension UITextField {
    
    /// 快速初始化UITextField 包含默认参数,初始化过程可以删除部分默认参数简化方法
    /// - Parameters:
    ///   - holderFont: 占位字体 有默认参数
    ///   - holder: 占位文字 有默认参数
    ///   - holderColor: 占位文字颜色 有默认参数
    ///   - font: 输入字体 有默认参数
    ///   - text: 输入文字 有默认参数
    ///   - textColor: 输入文字颜色 有默认参数
    ///   - textAlignment: textAlignment 有默认参数
    ///   - supView: 被添加的位置 有默认参数
    ///   - snapKitMaker: SnapKit 有默认参数
    ///   - delegate: 代理
    ///   - backColor: 背景色
    @discardableResult
    class func snpTextField(supView: UIView? = nil,
                            backColor: UIColor? = .clear,
                            holderFont: UIFont = UIFont.systemFont(ofSize: 14),
                            holder: String = "",
                            holderColor: UIColor = .black,
                            font: UIFont = UIFont.systemFont(ofSize: 14),
                            text: String = "",
                            textColor: UIColor = .black,
                            textAlignment: NSTextAlignment = .left,
                            delegate: UITextFieldDelegate? = nil,
                            snapKitMaker : ((ConstraintMaker) -> Void)? = nil) -> UITextField {
        
        let field = UITextField.init()
        
        field.borderStyle = .none
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.spellCheckingType = .no

        if delegate != nil {
          field.delegate = delegate
        }
        
        field.attributedPlaceholder = NSAttributedString.init(string: holder, attributes: [NSAttributedString.Key.font : holderFont,NSAttributedString.Key.foregroundColor:holderColor])
        
        field.text = text
        field.font = font
        field.textColor = textColor
        field.textAlignment = textAlignment
        field.backgroundColor = backColor
        
        guard let sv = supView, let maker = snapKitMaker else {
            return field
        }
        
        sv.addSubview(field)
        field.snp.makeConstraints { (make) in
            maker(make)
        }
        return field
    }
}
