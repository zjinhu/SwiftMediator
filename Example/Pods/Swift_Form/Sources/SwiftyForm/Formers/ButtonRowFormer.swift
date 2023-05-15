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
    ///左侧按钮背景色
    public var leftButtonBGColor: UIColor? = .clear
    ///左侧按钮标题
    public var leftButtonTitle: String?
    ///左侧按钮字体
    public var leftButtonTitleFont: UIFont?
    ///左侧按钮标题 默认颜色
    public var leftButtonTitleNorColor: UIColor?
    ///左侧按钮标题 按下颜色
    public var leftButtonTitleHigColor: UIColor?
    ///左侧按钮 默认图片
    public var leftButtonNorImage: UIImage?
    ///左侧按钮 按下图片
    public var leftButtonHigImage: UIImage?
    ///左侧按钮 圆角
    public var leftButtonCornerRadius: CGFloat = 4
    ///左侧点击回调
    fileprivate var onLeftButtonClick: (() -> Void)?
    ///右侧按钮背景色
    public var rightButtonBGColor: UIColor?
    ///右侧按钮标题
    public var rightButtonTitle: String?
    ///右侧按钮字体
    public var rightButtonTitleFont: UIFont?
    ///右侧按钮标题 默认颜色
    public var rightButtonTitleNorColor: UIColor?
    ///右侧按钮标题 按下颜色
    public var rightButtonTitleHigColor: UIColor?
    ///右侧按钮 默认图片
    public var rightButtonNorImage: UIImage?
    ///右侧按钮 按下图片
    public var rightButtonHigImage: UIImage?
    ///右侧按钮 圆角
    public var rightButtonCornerRadius: CGFloat = 4
    ///右侧点击回调
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

