//
//  ButtonHeaderFooterFormer.swift
//  SwiftyForm
//
//  Created by iOS on 2020/9/25.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit

public protocol ButtonFormableView: FormableHeaderFooter {
    func formButton() -> UIButton
}

open class ButtonHeaderFooterFormer<T: UITableViewHeaderFooterView>: BaseHeaderFooterFormer<T> where T: ButtonFormableView {
    ///按钮背景色
    public var buttonBGColor: UIColor? = .clear
    ///按钮标题
    public var buttonTitle: String?
    ///按钮字体
    public var buttonTitleFont: UIFont?
    ///按钮标题 默认颜色
    public var buttonTitleNorColor: UIColor?
    ///按钮标题 按下颜色
    public var buttonTitleHigColor: UIColor?
    ///按钮 默认图片
    public var buttonNorImage: UIImage?
    ///按钮 按下图片
    public var buttonHigImage: UIImage?
    ///按钮 圆角
    public var buttonCornerRadius: CGFloat = 4
    ///点击回调
    fileprivate var buttonClick: (() -> Void)?

    /// 右侧按钮点击
    /// - Parameter handler: handler description
    /// - Returns: description
    @discardableResult public func onButtonClick(_ handler: @escaping (() -> Void)) -> Self {
        buttonClick = handler
        return self
    }
    
    @objc private dynamic func buttonAction(_ sender: UIButton) {
        buttonClick?()
    }

    open override func initialized() {
        viewHeight = 60
    }
    
    open override func viewInitialized(_ view: T) {
        headerFooter.formButton().addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    }

    open override func update() {
        super.update()

        let button = headerFooter.formButton()
        button.backgroundColor = buttonBGColor
        button.titleLabel?.font = buttonTitleFont
        button.setTitle(buttonTitle, for: .normal)
        button.setTitleColor(buttonTitleNorColor, for: .normal)
        button.setTitleColor(buttonTitleHigColor, for: .highlighted)
        button.setImage(buttonNorImage, for: .normal)
        button.setImage(buttonHigImage, for: .highlighted)
        button.layer.cornerRadius = buttonCornerRadius
        button.clipsToBounds = true
    }

}
