//
//  FormLabelFooterView.swift
//  SwiftyForm
//
//  Created by iOS on 2020/6/5.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit

public class LabelFooter: LabelHeaderFooterFormer<LabelFooterView> {

}

open class LabelFooterView: BaseHeaderFooterView, LabelFormableView {

    public private(set) weak var titleLabel: UILabel!
    public private(set) weak var titleImageView: UIImageView!
    
    public func formTitleLabel() -> UILabel {
        return titleLabel
    }
    
    public func formTitleImageView() -> UIImageView? {
        return titleImageView
    }
    
    override open func setup() {
        super.setup()
        
        let titleImageView = UIImageView()
        titleImageView.clipsToBounds = true
        contentView.addSubview(titleImageView)
        self.titleImageView = titleImageView
        titleImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
        
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        contentView.insertSubview(titleLabel, at: 0)
        titleLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        self.titleLabel = titleLabel
    }
    
    open override func updateHeaderFooterFormer(_ headerFooterFormer: ViewFormer) {
        
        titleLabel.snp.updateConstraints { (make) in
            if titleImageView.image == nil{
                make.left.equalToSuperview().offset(20)
            }else{
                make.left.equalToSuperview().offset(50)
            }
        }
    }
}
