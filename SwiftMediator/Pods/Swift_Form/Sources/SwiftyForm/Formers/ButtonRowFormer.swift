//
//  ButtonRowFormer.swift
//  SwiftyForm
//
//  Created by 张金虎 on 2020/6/6.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit

/// ButtonForm协议
public protocol ButtonFormableRow: FormableRow {
    func formLeftButton() -> UIButton
    func formRightButton() -> UIButton
}

/// ButtonForm 隐藏左侧按钮会只展示一个大按钮RightButton
open class ButtonRowFormer<T: UITableViewCell>: BaseRowFormer<T>, Formable where T: ButtonFormableRow {

    public var leftButtonBGColor: UIColor? = .clear
    public var leftButtonTitle: String?
    public var leftButtonTitleFont: UIFont?
    public var leftButtonTitleNorColor: UIColor?
    public var leftButtonTitleHigColor: UIColor?
    public var leftButtonNorImage: UIImage?
    public var leftButtonHigImage: UIImage?
    public var leftButtonCornerRadius: CGFloat = 4
    fileprivate var onLeftButtonClick: (() -> Void)?
    
    public var rightButtonBGColor: UIColor?
    public var rightButtonTitle: String?
    public var rightButtonTitleFont: UIFont?
    public var rightButtonTitleNorColor: UIColor?
    public var rightButtonTitleHigColor: UIColor?
    public var rightButtonNorImage: UIImage?
    public var rightButtonHigImage: UIImage?
    public var rightButtonCornerRadius: CGFloat = 4
    fileprivate var onRightButtonClick: (() -> Void)?
    
    /// 左侧按钮点击
    /// - Parameter handler: handler description
    /// - Returns: description
    @discardableResult public final func onLeftButtonClick(_ handler: @escaping (() -> Void)) -> Self {
        onLeftButtonClick = handler
        return self
    }
    
    /// 右侧按钮点击
    /// - Parameter handler: handler description
    /// - Returns: description
    @discardableResult public final func onRightButtonClick(_ handler: @escaping (() -> Void)) -> Self {
        onRightButtonClick = handler
        return self
    }
    
    
    /// 初始化
    open override func initialized() {
        rowHeight = 60
    }
    
    /// 初始化
    open override func cellInitialized(_ cell: T) {
        cell.formLeftButton().addTarget(self, action: #selector(ButtonRowFormer.leftButtonAction(_:)), for: .touchUpInside)
        cell.formRightButton().addTarget(self, action: #selector(ButtonRowFormer.rightButtonAction(_:)), for: .touchUpInside)
    }
    
    
    /// 数据更新
    open override func update() {
        super.update()
        cell.selectionStyle = .none
        
        let leftButton = cell.formLeftButton()
        leftButton.backgroundColor = leftButtonBGColor
        leftButton.titleLabel?.font = leftButtonTitleFont
        leftButton.setTitle(leftButtonTitle, for: .normal)
        leftButton.setTitleColor(leftButtonTitleNorColor, for: .normal)
        leftButton.setTitleColor(leftButtonTitleHigColor, for: .highlighted)
        leftButton.setImage(leftButtonNorImage, for: .normal)
        leftButton.setImage(leftButtonHigImage, for: .highlighted)
        leftButton.layer.cornerRadius = leftButtonCornerRadius
        leftButton.clipsToBounds = true
        let rightButton = cell.formRightButton()
        rightButton.backgroundColor = rightButtonBGColor
        rightButton.titleLabel?.font = rightButtonTitleFont
        rightButton.setTitle(rightButtonTitle, for: .normal)
        rightButton.setTitleColor(rightButtonTitleNorColor, for: .normal)
        rightButton.setTitleColor(rightButtonTitleHigColor, for: .highlighted)
        rightButton.setImage(rightButtonNorImage, for: .normal)
        rightButton.setImage(rightButtonHigImage, for: .highlighted)
        rightButton.layer.cornerRadius = rightButtonCornerRadius
        rightButton.clipsToBounds = true
        leftButton.isEnabled = enabled
        rightButton.isEnabled = enabled
    }

    @objc private dynamic func leftButtonAction(_ sender: UIButton) {
        onLeftButtonClick?()
    }
    
    @objc private dynamic func rightButtonAction(_ sender: UIButton) {
        onRightButtonClick?()
    }
}

