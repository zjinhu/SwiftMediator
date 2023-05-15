//
//  BaseCellFormer.swift
//  SwiftyForm
//
//  Created by iOS on 2020/6/5.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit
/// 一般样式cell 左侧titleImageView titleLabel 右侧subTitleLabel mark箭头(cell自带)
public class LabelRow: LabelRowFormer<LabelCell> {

}

open class LabelCell: BaseCell, LabelFormableRow {

    public private(set) weak var titleLabel: UILabel!
    public private(set) weak var subTitleLabel: UILabel!
    public private(set) weak var titleImageView: UIImageView!
    /// 标题左侧图标(可修改属性)
    public func formTitleImageView() -> UIImageView? {
        return titleImageView
    }
    /// 标题Label(可修改属性)
    public func formTitleLabel() -> UILabel? {
        return titleLabel
    }
    /// 右侧副标题/说明(可修改属性)
    public func formSubTitleLabel() -> UILabel? {
        return subTitleLabel
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
        contentView.addSubview(titleLabel)
        self.titleLabel = titleLabel
        
        let subTitleLabel = UILabel()
        subTitleLabel.textColor = .lightGray
        subTitleLabel.textAlignment = .right
        contentView.addSubview(subTitleLabel)
        self.subTitleLabel = subTitleLabel
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
        
        subTitleLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(titleLabel.snp.right)
            make.right.equalToSuperview().offset(-20)
        }
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

        subTitleLabel.snp.updateConstraints { (make) in
            make.right.equalToSuperview().offset((accessoryType == .none) ? -20 : -5)
        }
    }
}
