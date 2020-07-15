//
//  UIImageViewSnapEx.swift
//  SwiftBrick
//
//  Created by iOS on 22/11/2019.
//  Copyright © 2019 狄烨 . All rights reserved.
//

import UIKit
import SnapKit
public extension UIImageView {

    /// 快速初始化UIImageView 包含默认参数,初始化过程可以删除部分默认参数简化方法
    /// - Parameters:
    ///   - supView: 被添加的位置 有默认参数
    ///   - image: 图片对象 有默认参数
    ///   - contentMode: contentMode 有默认参数
    ///   - snapKitMaker: SnapKit 有默认参数
    ///   - snpTapGesture: 点击Block 有默认参数
    ///   - backColor: 背景色
    @discardableResult
    class func snpImageView(supView : UIView? = nil,
                            backColor: UIColor? = .clear,
                            image : UIImage? = nil,
                            contentMode : UIView.ContentMode  = .scaleAspectFill,
                            snpTapGesture : tapGestureClosure? = nil,
                            snapKitMaker : ((_ make: ConstraintMaker) -> Void)? = nil) -> UIImageView {
        
        let imageView = UIImageView.init()
        imageView.backgroundColor = backColor
        imageView.contentMode = contentMode
        
        imageView.image = image
        
        guard let sv = supView, let maker = snapKitMaker else {
            return imageView
        }
        sv.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            maker(make)
        }
        
        guard let ges = snpTapGesture else {
            return imageView
        }
        imageView.snpAddTapGestureWithCallback(tapGesture: ges)
        
        
        return imageView
    }
    
}
