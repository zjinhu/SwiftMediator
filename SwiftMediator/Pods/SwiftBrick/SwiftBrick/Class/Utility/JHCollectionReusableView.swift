//
//  JHCollectionReusableView.swift
//  SwiftBrick
//
//  Created by iOS on 19/11/2019.
//  Copyright © 2019 狄烨 . All rights reserved.
//

import UIKit

open class JHCollectionReusableView: UICollectionReusableView {
    public enum ReusableViewType {
        case SectionHeader//UICollectionElementKindSectionHeader
        case SectionFooter//UICollectionElementKindSectionFooter
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configCellViews()
        self.backgroundColor = .clear
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - 继承 在内部实现布局
    open func configCellViews() {
        
    }
    // MARK: - cell赋值
    open func setCellModel(model: Any) {
        
    }
    // MARK: - 获取高度
    public func getCellHeightWithModel(model: Any) -> CGFloat {
        self.setCellModel(model: model)
        self.layoutIfNeeded()
        self.updateConstraintsIfNeeded()
        let height = self.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return height
    }
    // MARK: - 注册
    public class func registerHeaderFooterView(collectionView: UICollectionView, reuseIdentifier: String = String.init(describing: self), viewType: ReusableViewType) {
        
        var kind : String
        switch viewType {
        case .SectionHeader:
            kind = UICollectionView.elementKindSectionHeader
        case .SectionFooter:
            kind = UICollectionView.elementKindSectionFooter
        }
        
        collectionView.register(self, forSupplementaryViewOfKind: kind, withReuseIdentifier: reuseIdentifier)
    }
    // MARK: - 复用取值
    public class func dequeueReusableHeaderFooterView(collectionView: UICollectionView, reuseIdentifier: String = String.init(describing: self), viewType: ReusableViewType, indexPath: IndexPath) ->UICollectionReusableView{
        
        var kind : String
        switch viewType {
        case .SectionHeader:
            kind = UICollectionView.elementKindSectionHeader
        case .SectionFooter:
            kind = UICollectionView.elementKindSectionFooter
        }
        
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath)
    }
}
