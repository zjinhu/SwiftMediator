//
//  BaseCellFormer.swift
//  SwiftyForm
//
//  Created by iOS on 2020/6/5.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit

public protocol DatePickerFormableRow: FormableRow {
    
    func formDatePicker() -> UIDatePicker
}

open class DatePickerRowFormer<T: UITableViewCell>: BaseRowFormer<T>, Formable where T: DatePickerFormableRow {
    ///初始日期数据
    public var date: Date = Date()
    ///选择日期后回调
    public var onDateChanged: ((Date) -> Void)?
    
    @discardableResult
    public final func onDateChanged(_ handler: @escaping ((Date) -> Void)) -> Self {
        onDateChanged = handler
        return self
    }
    
    open override func initialized() {
        rowHeight = 216
    }
    
    open override func cellInitialized(_ cell: T) {
        cell.formDatePicker().addTarget(self, action: #selector(DatePickerRowFormer.dateChanged(datePicker:)), for: .valueChanged)
    }
    
    open override func update() {
        super.update()
        
        cell.selectionStyle = .none
        let datePicker = cell.formDatePicker()
        datePicker.setDate(date, animated: false)
        datePicker.isUserInteractionEnabled = enabled
        datePicker.layer.opacity = enabled ? 1 : 0.5
    }
 
    @objc private dynamic func dateChanged(datePicker: UIDatePicker) {
        if enabled {
            let date = datePicker.date
            self.date = date
            onDateChanged?(date)
        }
    }
}
