//
//  BaseCellFormer.swift
//  SwiftyForm
//
//  Created by iOS on 2020/6/5.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit
/// UISwitch选择cell 左侧titleImageView titleLabel 右侧switchButton
public class SwitchRow: SwitchRowFormer<SwitchCell> {

}

open class SwitchCell: BaseCell, SwitchFormableRow {

    public private(set) weak var titleLabel: UILabel!
    public private(set) weak var switchButton: UISwitch!
    public private(set) weak var titleImageView: UIImageView!
    
    public func formTitleImageView() -> UIImageView? {
        return titleImageView
    }
    
    public func formTitleLabel() -> UILabel? {
        return titleLabel
    }
    
    public func formSwitch() -> UISwitch {
        return switchButton
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
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        self.titleLabel = titleLabel
        
        let switchButton = UISwitch()
        contentView.addSubview(switchButton)
        self.switchButton = switchButton

        titleLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
        
        switchButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-24)
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

    }
}
