//
//  JHCollectionViewCell.swift
//  SwiftBrick
//
//  Created by iOS on 19/11/2019.
//  Copyright © 2019 狄烨 . All rights reserved.
//

import UIKit

open class JHCollectionViewCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configCellViews()
        self.contentView.backgroundColor = .clear
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
        let height = self.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return height
    }
    
    // MARK: - 注册
    public class func registerCell(collectionView: UICollectionView, reuseIdentifier: String = String.init(describing: self)) {
        collectionView.register(self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    // MARK: - 复用取值
    public class func dequeueReusableCell(collectionView: UICollectionView, reuseIdentifier: String = String.init(describing: self), indexPath: IndexPath) ->UICollectionViewCell{
        return collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    }
}
