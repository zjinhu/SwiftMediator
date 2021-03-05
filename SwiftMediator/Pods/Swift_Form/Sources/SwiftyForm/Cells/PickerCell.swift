//
//  BaseCellFormer.swift
//  SwiftyForm
//
//  Created by iOS on 2020/6/5.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit
/// picker cell 
public class PickerRow: PickerRowFormer<PickerCell, Any> {

}

open class PickerCell: BaseCell, PickerFormableRow {

    public private(set) weak var pickerView: UIPickerView!
    
    public func formPickerView() -> UIPickerView {
        return pickerView
    }
    
    open override func setup() {
        super.setup()
        
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(pickerView)
        self.pickerView = pickerView
        pickerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
}
