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
    public var buttonBGColor: UIColor? = .clear
    public var buttonTitle: String?
    public var buttonTitleFont: UIFont?
    public var buttonTitleNorColor: UIColor?
    public var buttonTitleHigColor: UIColor?
    public var buttonNorImage: UIImage?
    public var buttonHigImage: UIImage?
    public var buttonCornerRadius: CGFloat = 4
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
