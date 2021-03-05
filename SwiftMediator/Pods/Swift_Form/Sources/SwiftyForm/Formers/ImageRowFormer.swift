//
//  ImageRowFormer.swift
//  SwiftyForm
//
//  Created by 张金虎 on 2020/6/6.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit

/// ImageForm协议
public protocol ImageFormableRow: FormableRow {
    func formTitleImageView() -> UIImageView?
    func formTitleLabel() -> UILabel?
    func formSubTitleLabel() -> UILabel?
    func formImageView() -> UIImageView?
}

/// ImageForm 顶部和LabelRorm一样,下边是图片
open class ImageRowFormer<T: UITableViewCell>: BaseRowFormer<T>, Formable where T: ImageFormableRow {

    public var subTitle: String?
    public var coverImage: UIImage?
    public var coverRadius: CGFloat = 10
    public var subTitleDisabledColor: UIColor? = .lightGray
    public var subTitleColor: UIColor?
 
    open override func initialized() {
        rowHeight = 190
    }
    
    open override func cellInitialized(_ cell: T) {
        let titleImageView = cell.formTitleImageView()
        titleImageView?.image = titleImage
    }
    
    open override func cellSelected(indexPath: IndexPath) {
        super.cellSelected(indexPath: indexPath)
        former?.deselect(animated: true)
    }
    
    open override func update() {
        super.update()

        let titleLabel = cell.formTitleLabel()
        let subTitleLabel = cell.formSubTitleLabel()
        if let title = title {
            titleLabel?.text = title
        }
        
        if let attributedTitle = attributedTitle{
            titleLabel?.attributedText = attributedTitle
        }
        subTitleLabel?.text = subTitle
        
        let coverImageView = cell.formImageView()
        coverImageView?.image = coverImage
        coverImageView?.layer.cornerRadius = coverRadius
        if enabled {
            _ = titleColor.map { titleLabel?.textColor = $0 }
            _ = subTitleColor.map { subTitleLabel?.textColor = $0 }
            titleColor = nil
            subTitleColor = nil
        } else {
            if titleColor == nil { titleColor = titleLabel?.textColor ?? .black }
            if subTitleColor == nil { subTitleColor = subTitleLabel?.textColor ?? .black }
            titleLabel?.textColor = titleDisabledColor
            subTitleLabel?.textColor = subTitleDisabledColor
        }
        
    }
}
