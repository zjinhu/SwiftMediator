//
//  BaseCellFormer.swift
//  SwiftyForm
//
//  Created by iOS on 2020/6/5.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit
/// 输入框样式cell 左侧titleImageView titleLabel 右侧subTitleLabel 下方textView(title为空则只展示textView)
public class TextViewRow: TextViewRowFormer<TextViewCell> {

}

open class TextViewCell: BaseCell, TextViewFormableRow {

    public private(set) weak var textView: UITextView!
    public private(set) weak var titleLabel: UILabel!
    public private(set) weak var titleImageView: UIImageView!
    public private(set) weak var subTitleLabel: UILabel!
    /// 标题左侧图标(可修改属性)
    public func formTitleImageView() -> UIImageView? {
        return titleImageView
    }
    /// 输入框(可修改属性)
    public func formTextView() -> UITextView {
        return textView
    }
    /// 标题Label(可修改属性)
    public func formTitleLabel() -> UILabel? {
        return titleLabel
    }
    /// 右侧副标题/说明(可修改属性)
    public func formSubTitleLabel() -> UILabel? {
        return subTitleLabel
    }
    
    open override func updateWithRowFormer(_ rowFormer: RowFormer) {

        titleLabel.snp.remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.height.equalTo(40)
            if rowFormer.titleImage == nil{
                make.left.equalToSuperview().offset(20)
            }else{
                make.left.equalTo(titleImageView.snp.right).offset(5)
            }
        }

        textView.snp.remakeConstraints { (make) in
            if let text = rowFormer.title, !text.isEmpty {
                make.top.equalTo(titleLabel.snp.bottom)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.bottom.equalToSuperview().offset(-15)
            }else if let attributedTitle = rowFormer.attributedTitle, !attributedTitle.string.isEmpty {
                make.top.equalTo(titleLabel.snp.bottom)
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.bottom.equalToSuperview().offset(-15)
            }else{
                make.top.equalToSuperview()
                make.left.equalToSuperview().offset(15)
                make.right.equalToSuperview().offset(-15)
                make.bottom.equalToSuperview().offset(-5)
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

        
        let titleLabel = UILabel()
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        contentView.addSubview(titleLabel)
        self.titleLabel = titleLabel
        
        let subTitleLabel = UILabel()
        subTitleLabel.textColor = .lightGray
        subTitleLabel.textAlignment = .right
        contentView.addSubview(subTitleLabel)
        self.subTitleLabel = subTitleLabel
        
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 17)
        textView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textView)
        self.textView = textView

        titleImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.left.equalToSuperview().offset(20)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(40)
        }
        subTitleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.left.equalTo(titleLabel.snp.right)
            make.right.equalToSuperview().offset(-20)
        }
        
        textView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-15)
        }
        
    }

}
