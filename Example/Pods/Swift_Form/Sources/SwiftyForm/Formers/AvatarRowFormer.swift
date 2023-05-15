//
//  AvatarRowFormer.swift
//  SwiftyForm
//
//  Created by iOS on 2020/6/5.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit

/// AvatarForm协议
public protocol AvatarFormableRow: FormableRow {
    
    func formTitleLabel() -> UILabel?
    func formTitleImageView() -> UIImageView?
    func formAvatarView() -> UIImageView?
}

/// AvatarForm
open class AvatarRowFormer<T: UITableViewCell> : BaseRowFormer<T>, Formable where T: AvatarFormableRow {
    ///头像图片
    public var avatarImage: UIImage?
    ///头像圆角
    public var avatarRadius: CGFloat = 4
    /// AvatarForm初始化
    open override func initialized() {
        rowHeight = 80
    }
    /// AvatarForm初始化
    open override func cellInitialized(_ cell: T) {
        let titleImageView = cell.formTitleImageView()
        titleImageView?.image = titleImage
    }
    
    open override func cellSelected(indexPath: IndexPath) {
        super.cellSelected(indexPath: indexPath)
        former?.deselect(animated: true)
    }
    
    /// AvatarForm数据更新
    open override func update() {
        super.update()

        let textLabel = cell.formTitleLabel()
        let avatarView = cell.formAvatarView()
        if let title = title {
            textLabel?.text = title
        }
        
        if let attributedTitle = attributedTitle{
            textLabel?.attributedText = attributedTitle
        }
        avatarView?.image = avatarImage
        avatarView?.layer.cornerRadius = avatarRadius
        if enabled {
            _ = titleColor.map { textLabel?.textColor = $0 }
            titleColor = nil
        } else {
            if titleColor == nil { titleColor = textLabel?.textColor ?? .black }
            textLabel?.textColor = titleDisabledColor
        }
    }
}
