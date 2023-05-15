//
//  LabelHeaderFooterFormer.swift
//  SwiftyForm
//
//  Created by iOS on 2020/6/5.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit

/// 图文header footer Form协议
public protocol LabelFormableView: FormableHeaderFooter {
    func formTitleImageView() -> UIImageView?
    func formTitleLabel() -> UILabel
}
/// 图文header footer Form
open class LabelHeaderFooterFormer<T: UITableViewHeaderFooterView>: BaseHeaderFooterFormer<T> where T: LabelFormableView {
    /// HeaderFooter 标题
    public var title: String?
    /// HeaderFooter 左侧小图片
    public var titleImage: UIImage?

    open override func initialized() {
        viewHeight = 30
    }
    
    open override func viewInitialized(_ view: T) {
        headerFooter.formTitleImageView()?.image = titleImage
    }
    open override func update() {
        super.update() 
        headerFooter.formTitleLabel().text = title
    }
}
