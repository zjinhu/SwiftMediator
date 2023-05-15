//
//  ButtonFooterView.swift
//  SwiftyForm
//
//  Created by iOS on 2020/9/25.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit

public class ButtonFooter: ButtonHeaderFooterFormer<ButtonFooterView> {

}

open class ButtonFooterView: BaseHeaderFooterView,ButtonFormableView{
    ///获取按钮(可修改属性)
    public func formButton() -> UIButton {
        return button
    }
    
    weak var button: UIButton!


    override open func setup() {
        super.setup()

        let button = UIButton()
        contentView.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(190)
        }
        self.button = button
    }
    
}
