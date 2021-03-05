//
//  BaseCellFormer.swift
//  SwiftyForm
//
//  Created by iOS on 2020/6/5.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit
/// 输入框样式cell 左侧titleImageView titleLabel 右侧textField
public class TextFieldRow: TextFieldRowFormer<TextFieldCell> {

}

open class TextFieldCell: BaseCell, TextFieldFormableRow {

    public private(set) weak var textField: UITextField!
    public private(set) weak var titleLabel: UILabel!
    public private(set) weak var titleImageView: UIImageView!
    
    public func formTitleImageView() -> UIImageView? {
        return titleImageView
    }
    
    public func formTextField() -> UITextField {
        return textField
    }
    
    public func formTitleLabel() -> UILabel? {
        return titleLabel
    }
    
    open override func updateWithRowFormer(_ rowFormer: RowFormer) {
        
        titleLabel.snp.remakeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            if rowFormer.titleImage == nil{
                make.left.equalToSuperview().offset(20)
            }else{
                make.left.equalTo(titleImageView.snp.right).offset(5)
            }
        }
        
        textField.snp.remakeConstraints { (make) in
            if let text = rowFormer.title, !text.isEmpty{
                make.left.equalTo(titleLabel.snp.right)
                make.right.equalToSuperview().offset(-20)
                make.top.bottom.equalToSuperview()
            }else if let attributedTitle = rowFormer.attributedTitle, !attributedTitle.string.isEmpty {
                make.left.equalTo(titleLabel.snp.right)
                make.right.equalToSuperview().offset(-20)
                make.top.bottom.equalToSuperview()
            }else{
                make.left.equalToSuperview().offset(20)
                make.right.equalToSuperview().offset(-20)
                make.top.bottom.equalToSuperview()
            }
        }
    }
    
    open override func setup() {
        super.setup()
        
        let titleImageView = UIImageView()
        titleImageView.clipsToBounds = true
        titleImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        titleImageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        contentView.addSubview(titleImageView)
        self.titleImageView = titleImageView
        titleImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
        
        let titleLabel = UILabel()
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(titleImageView.snp.right).offset(5)
        }
        self.titleLabel = titleLabel
        
        let textField = UITextField()
        textField.backgroundColor = .clear
        textField.textAlignment = .right
        contentView.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(titleLabel.snp.right)
            make.right.equalToSuperview().offset(-20)
        }
        self.textField = textField
    }
}
