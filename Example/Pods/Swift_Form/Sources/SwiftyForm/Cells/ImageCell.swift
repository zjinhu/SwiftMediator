//
//  ImageCell.swift
//  SwiftyForm
//
//  Created by 张金虎 on 2020/6/6.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit
/// 图片cell 左侧titleImageView titleLabel 右侧subTitleLabel 下方coverImageView
public class ImageRow: ImageRowFormer<ImageCell> {

}

open class ImageCell: BaseCell, ImageFormableRow {
    
    public private(set) weak var titleLabel: UILabel!
    public private(set) weak var subTitleLabel: UILabel!
    public private(set) weak var titleImageView: UIImageView!
    public private(set) weak var coverImageView: UIImageView!
    /// 标题左侧图标(可修改属性)
    public func formTitleImageView() -> UIImageView? {
        return titleImageView
    }
    /// 标题Label(可修改属性)
    public func formTitleLabel() -> UILabel? {
        return titleLabel
    }
    ///获取UIImageView(可修改属性)
    public func formImageView() -> UIImageView? {
        return coverImageView
    }
    /// 右侧副标题/说明(可修改属性)
    public func formSubTitleLabel() -> UILabel? {
        return subTitleLabel
    }
    
    open override func setup() {
        super.setup()
        
        let titleImageView = UIImageView()
        titleImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        titleImageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        titleImageView.clipsToBounds = true
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
        
        let coverImageView = UIImageView()
        coverImageView.clipsToBounds = true
        coverImageView.backgroundColor = .lightGray
        contentView.addSubview(coverImageView)
        self.coverImageView = coverImageView
        
        titleImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.left.equalToSuperview().offset(20)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(60)
        }
        
        subTitleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.right.equalToSuperview().offset(-20)
        }
        
        coverImageView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(120)
        }
    }

    open override func updateWithRowFormer(_ rowFormer: RowFormer) {
        
        titleLabel.snp.remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.height.equalTo(60)
            if rowFormer.titleImage == nil{
                make.left.equalToSuperview().offset(20)
            }else{
                make.left.equalTo(titleImageView.snp.right).offset(5)
            }
        }
    }
}

