//
//  BaseCellFormer.swift
//  SwiftyForm
//
//  Created by iOS on 2020/6/5.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit

/// CheckForm协议
public protocol CheckFormableRow: FormableRow {
    func formTitleLabel() -> UILabel?
    func formTitleImageView() -> UIImageView?
}


/// CheckFormer
open class CheckRowFormer<T: UITableViewCell>: BaseRowFormer<T>, Formable where T: CheckFormableRow {
    
    ///是否选中
    public var checked = false
    ///自定义选中样式
    public var customCheckView: UIView?
    ///默认状态下选中标记颜色
    public var checkColor: UIColor?
    ///点击选中回调
    public var onCheckChanged: ((Bool) -> Void)?
    
    /// CheckForm状态变化
    /// - Parameter handler: handler description
    /// - Returns: description
    @discardableResult public final func onCheckChanged(_ handler: @escaping ((Bool) -> Void)) -> Self {
        onCheckChanged = handler
        return self
    }
    
    /// CheckForm初始化 继承可重写
    /// - Parameter cell: cell泛型
    open override func cellInitialized(_ cell: T) {
        let titleImageView = cell.formTitleImageView()
        titleImageView?.image = titleImage
    }
    
    /// 初始化CheckForm
    open override func initialized() {
        rowHeight = 60
    }
    
    /// CheckForm数据更新
    open override func update() {
        super.update()
        if let customCheckView = customCheckView {
            cell.accessoryView = customCheckView
            customCheckView.isHidden = checked ? false : true
        } else {
            cell.accessoryType = checked ? .checkmark : .none
        }
        
        let titleLabel = cell.formTitleLabel()
        
        if let title = title {
            titleLabel?.text = title
        }
        
        if let attributedTitle = attributedTitle{
            titleLabel?.attributedText = attributedTitle
        }
        
        if enabled {
            _ = titleColor.map { titleLabel?.textColor = $0 }
            titleColor = nil
        } else {
            if titleColor == nil { titleColor = titleLabel?.textColor ?? .black }
            titleLabel?.textColor = titleDisabledColor
        }
        
        if let color = checkColor {
            cell.tintColor = color
        }
    }
    
    /// CheckForm点击选中
    /// - Parameter indexPath: indexPath description
    open override func cellSelected(indexPath: IndexPath) {
        former?.deselect(animated: true)
        if enabled {
            checked = !checked
            onCheckChanged?(checked)
            if let customCheckView = customCheckView {
                cell.accessoryView = customCheckView
                customCheckView.isHidden = checked ? false : true
            } else {
                cell.accessoryType = checked ? .checkmark : .none
            }
        }
    }
}
