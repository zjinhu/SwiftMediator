//
//  UICollectionViewSnapEx.swift
//  SwiftBrick
//
//  Created by iOS on 22/11/2019.
//  Copyright © 2019 狄烨 . All rights reserved.
//

import UIKit

public extension UICollectionView {
    
    /// 快速初始化UICollectionView 包含默认参数,初始化过程可以删除部分默认参数简化方法
    /// - Parameters:
    ///   - supView: 被添加的位置 有默认参数
    ///   - snapKitMaker: SnapKit 有默认参数
    ///   - scrollDirectionType: 滚动方向
    ///   - delegate: delegate
    ///   - dataSource: dataSource
    ///   - backColor: 背景色
    class func snpCollectionView(supView: UIView? = nil,
                                 snapKitMaker : JHSnapKitTool.JHSnapMaker? = nil,
                                 scrollDirectionType: UICollectionView.ScrollDirection = .vertical,
                                 delegate: UICollectionViewDelegate,
                                 dataSource: UICollectionViewDataSource,
                                 backColor: UIColor) -> UICollectionView{
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = scrollDirectionType
        
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
        collectionView.backgroundColor = backColor
        
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.delaysContentTouches = true
        collectionView.contentInsetAdjustmentBehavior = .automatic
        
        if supView != nil{
            supView?.addSubview(collectionView)
            collectionView.snp.makeConstraints { (make) in
                snapKitMaker!(make)
            }
        }
        
        return collectionView
    }
    
}
