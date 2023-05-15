//
//  JHBaseCollectionViewController.swift
//  JHToolsModule_Swift
//
//  Created by iOS on 18/11/2019.
//  Copyright © 2019 HU. All rights reserved.
//

import UIKit
import SnapKit
// MARK: ===================================VC基类:UICollectionViewController=========================================
open class JHCollectionViewController: JHViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    public var collectionView: UICollectionView?
    public var mainDatas: Array<Any> = []
    public var flowLayout: UICollectionViewLayout?
    
    public convenience init(flowLayout layout: UICollectionViewFlowLayout) {
         self.init()
         flowLayout = layout
     }
    
    open func setupFlowLayout() -> UICollectionViewLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        return flowLayout
    }
    
    // MARK: - 布局
    override open func viewDidLoad() {
        super.viewDidLoad()

        if flowLayout == nil  {
            flowLayout = setupFlowLayout()
        }
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout!)
        collectionView?.backgroundColor = .clear
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        collectionView?.delaysContentTouches = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        
        view.addSubview(collectionView!)
        collectionView?.snp.makeConstraints{ (make) in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
        }

        collectionView?.contentInsetAdjustmentBehavior = .automatic
        
        // Do any additional setup after loading the view.
        let gestureArray: [UIGestureRecognizer]? = navigationController?.view.gestureRecognizers
        gestureArray?.forEach({ (gesture) in
            if gesture.isEqual(UIScreenEdgePanGestureRecognizer.self) {
                collectionView?.panGestureRecognizer.require(toFail: gesture)
            }
        })
        collectionView?.registerCell(JHCollectionViewCell.self)
    }
    
    // MARK: - 数据源判断
    func isMultiDatas() -> Bool {
        let data = mainDatas.first
        if data is Array<Any> && mainDatas.count > 0{
            return true
        }else{
            return false
        }
    }

    // MARK: - UICollectionView
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return isMultiDatas() ? mainDatas.count: 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isMultiDatas() {
            let data  = mainDatas[section] as! Array<Any>
            return data.count
        }else{
            return mainDatas.count
        }
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(JHCollectionViewCell.self, indexPath: indexPath)
        return cell
    }
    
}
