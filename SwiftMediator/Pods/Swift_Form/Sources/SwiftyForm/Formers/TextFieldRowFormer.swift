//
//  TextFieldRowFormer.swift
//  SwiftyForm
//
//  Created by iOS on 2020/6/5.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit

/// TextFieldForm协议
public protocol TextFieldFormableRow: FormableRow {
    
    func formTextField() -> UITextField
    func formTitleImageView() -> UIImageView?
    func formTitleLabel() -> UILabel?
}

/// TextFieldForm
open class TextFieldRowFormer<T: UITableViewCell>: BaseRowFormer<T>, Formable where T: TextFieldFormableRow {

    override open var canBecomeEditing: Bool {
        return enabled
    }

    public var text: String?
    public var placeholder: String?
    public var attributedPlaceholder: NSAttributedString?
    public var textDisabledColor: UIColor? = .lightGray
    public var titleEditingColor: UIColor?
    public var returnToNextRow = true
    public var onReturn: ((String) -> Void)?
    public var onTextChanged: ((String) -> Void)?
    public var onLimitAlert: ((Int) -> Void)?
    public var textColor: UIColor?
    public var textLimit: Int = 0
    
    private lazy var observer: Observer<T> = Observer<T>(textFieldRowFormer: self)
    
    /// TextFieldForm输入变化
    /// - Parameter handler: handler description
    /// - Returns: description
    @discardableResult public final func onTextChanged(_ handler: @escaping ((String) -> Void)) -> Self {
        onTextChanged = handler
        return self
    }

    
    /// TextFieldForm输入回车
    /// - Parameter handler: handler description
    /// - Returns: description
    @discardableResult public final func onReturn(_ handler: @escaping ((String) -> Void)) -> Self {
        onReturn = handler
        return self
    }
    
    @discardableResult public final func onLimitAlert(_ handler: @escaping ((Int) -> Void)) -> Self {
        onLimitAlert = handler
        return self
    }
    
    /// 初始化TextFieldForm
    open override func initialized() {
        rowHeight = 60
    }
    
    /// TextFieldForm初始化
    /// - Parameter cell: cell description
    open override func cellInitialized(_ cell: T) {
        let textField = cell.formTextField()
        textField.delegate = observer
        let events: [(Selector, UIControl.Event)] = [(#selector(TextFieldRowFormer.textChanged(textField:)), .editingChanged),
            (#selector(TextFieldRowFormer.editingDidBegin(textField:)), .editingDidBegin),
            (#selector(TextFieldRowFormer.editingDidEnd(textField:)), .editingDidEnd)]
        events.forEach {
            textField.addTarget(self, action: $0.0, for: $0.1)
        }
    }
    
    /// TextFieldForm数据更新
    open override func update() {
        super.update()
        
        cell.selectionStyle = .none
        let titleLabel = cell.formTitleLabel()
        let textField = cell.formTextField()
        _ = placeholder.map { textField.placeholder = $0 }
        _ = attributedPlaceholder.map { textField.attributedPlaceholder = $0 }
        textField.isUserInteractionEnabled = false

        let titleImageView = cell.formTitleImageView()
        titleImageView?.image = titleImage
        
        if let title = title {
            titleLabel?.text = title
        }
        
        if let attributedTitle = attributedTitle{
            titleLabel?.attributedText = attributedTitle
        }
        
        textField.text = text
        
        if enabled {
            if isEditing {
                if titleColor == nil { titleColor = titleLabel?.textColor ?? .black }
                _ = titleEditingColor.map { titleLabel?.textColor = $0 }
            } else {
                _ = titleColor.map { titleLabel?.textColor = $0 }
                titleColor = nil
            }
            _ = textColor.map { textField.textColor = $0 }
            textColor = nil
        } else {
            if titleColor == nil { titleColor = titleLabel?.textColor ?? .black }
            if textColor == nil { textColor = textField.textColor ?? .black }
            titleLabel?.textColor = titleDisabledColor
            textField.textColor = textDisabledColor
        }
    }
    
    /// TextFieldFormc cell被点击
    /// - Parameter indexPath: indexPath description
    open override func cellSelected(indexPath: IndexPath) {
        let textField = cell.formTextField()
        if !textField.isEditing {
            textField.isUserInteractionEnabled = true
            textField.becomeFirstResponder()
        }
    }
    
    @objc private dynamic func textChanged(textField: UITextField) {
        if enabled {
            if let positionRange = textField.markedTextRange , let _ = textField.position(from: positionRange.start, offset: 0) {
                //正在使用拼音，不进行校验
                
            } else {
                if let text = textField.text, textLimit > 0, text.count > textLimit{
                    textField.text = String(text.prefix(textLimit))
                    onLimitAlert?(textLimit)
                }
            }
            let text = textField.text ?? ""
            self.text = text
            onTextChanged?(text)
        }
    }
    
    @objc private dynamic func editingDidBegin(textField: UITextField) {
        let titleLabel = cell.formTitleLabel()
        if titleColor == nil { textColor = textField.textColor ?? .black }
        _ = titleEditingColor.map { titleLabel?.textColor = $0 }
    }
    
    @objc private dynamic func editingDidEnd(textField: UITextField) {
        let titleLabel = cell.formTitleLabel()
        if enabled {
            _ = titleColor.map { titleLabel?.textColor = $0 }
            titleColor = nil
        } else {
            if titleColor == nil { titleColor = titleLabel?.textColor ?? .black }
            _ = titleEditingColor.map { titleLabel?.textColor = $0 }
        }
        cell.formTextField().isUserInteractionEnabled = false
    }
}

private class Observer<T: UITableViewCell>: NSObject, UITextFieldDelegate where T: TextFieldFormableRow {
    
    fileprivate weak var textFieldRowFormer: TextFieldRowFormer<T>?
    
    init(textFieldRowFormer: TextFieldRowFormer<T>) {
        self.textFieldRowFormer = textFieldRowFormer
    }
    
    fileprivate dynamic func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let textFieldRowFormer = textFieldRowFormer else { return false }
        if let returnHandler = textFieldRowFormer.onReturn {
            returnHandler(textField.text ?? "")
            return false
        }
        if textFieldRowFormer.returnToNextRow {
            let returnToNextRow = (textFieldRowFormer.former?.canBecomeEditingNext() ?? false) ?
                textFieldRowFormer.former?.becomeEditingNext :
                textFieldRowFormer.former?.endEditing
            _ = returnToNextRow?()
        }
        return !textFieldRowFormer.returnToNextRow
    }
}
