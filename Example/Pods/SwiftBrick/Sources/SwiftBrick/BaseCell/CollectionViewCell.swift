//
//  JHCollectionViewCell.swift
//  SwiftBrick
//
//  Created by iOS on 19/11/2019.
//  Copyright © 2019 狄烨 . All rights reserved.
//

import UIKit
// MARK: ===================================Cell基类:UICollectionViewCell=========================================
open class CollectionViewCell: UICollectionViewCell, Reusable{

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellViews()
        contentView.backgroundColor = .clear
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 继承 在内部实现布局
    /// 子类重写，进行view布局
    open func setupCellViews() {
        
    }

}
