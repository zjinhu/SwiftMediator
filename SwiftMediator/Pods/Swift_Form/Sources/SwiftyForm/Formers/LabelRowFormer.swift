//
//  LabelFormableRow.swift
//  SwiftyForm
//
//  Created by iOS on 2020/6/5.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit

/// LabelForm 协议
public protocol LabelFormableRow: FormableRow {
    
    func formTitleLabel() -> UILabel?
    func formTitleImageView() -> UIImageView?
    func formSubTitleLabel() -> UILabel?
}

/// LabelForm
open class LabelRowFormer<T: UITableViewCell> : BaseRowFormer<T>, Formable where T: LabelFormableRow {
 
    public var subTitle: String?
    public var subTitleDisabledColor: UIColor? = .lightGray
    public var subTitleColor: UIColor?
    
    /// LabelForm初始化
    open override func initialized() {
        rowHeight = 60
    }
    
    /// LabelForm初始化
    /// - Parameter cell: cell 泛型
    open override func cellInitialized(_ cell: T) {
        let titleImageView = cell.formTitleImageView()
        titleImageView?.image = titleImage
    }
    
    open override func cellSelected(indexPath: IndexPath) {
        super.cellSelected(indexPath: indexPath)
        former?.deselect(animated: true)
    }
    
    /// LabelForm数据更新
    open override func update() {
        super.update()
 
        let textLabel = cell.formTitleLabel()
        let subTitleLabel = cell.formSubTitleLabel()
        if let title = title {
            textLabel?.text = title
        }
        
        if let attributedTitle = attributedTitle{
            textLabel?.attributedText = attributedTitle
        }
        subTitleLabel?.text = subTitle
        
        if enabled {
            _ = titleColor.map { textLabel?.textColor = $0 }
            _ = subTitleColor.map { subTitleLabel?.textColor = $0 }
            titleColor = nil
            subTitleColor = nil
        } else {
            if titleColor == nil { titleColor = textLabel?.textColor ?? .black }
            if subTitleColor == nil { subTitleColor = subTitleLabel?.textColor ?? .black }
            textLabel?.textColor = titleDisabledColor
            subTitleLabel?.textColor = subTitleDisabledColor
        }
    }
}
