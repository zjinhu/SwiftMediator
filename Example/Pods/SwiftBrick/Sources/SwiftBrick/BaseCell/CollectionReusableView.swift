//
//  JHCollectionReusableView.swift
//  SwiftBrick
//
//  Created by iOS on 19/11/2019.
//  Copyright © 2019 狄烨 . All rights reserved.
//

import UIKit
// MARK: ===================================Cell基类:UICollectionReusableView=========================================
open class CollectionReusableView: UICollectionReusableView, Reusable{
    
    /// 样式，header还是footer
    public enum ReusableViewType {
        case SectionHeader//UICollectionElementKindSectionHeader
        case SectionFooter//UICollectionElementKindSectionFooter
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellViews()
        backgroundColor = .clear
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 继承 在内部实现布局
    /// 子类重写，进行view布局
    open func setupCellViews() {
        
    }
    
}
