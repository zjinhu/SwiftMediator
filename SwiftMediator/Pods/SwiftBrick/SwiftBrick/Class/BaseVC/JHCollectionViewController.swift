//
//  JHBaseCollectionViewController.swift
//  JHToolsModule_Swift
//
//  Created by iOS on 18/11/2019.
//  Copyright © 2019 HU. All rights reserved.
//

import UIKit
import SnapKit

open class JHCollectionViewController: JHViewController ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
//    deinit {
//        print("JHCollectionViewController out")
//    }
    // MARK: - 参数变量
    public enum ScrollDirectionType {
        case ScrollVertical
        case ScrollHorizontal
    }
    
    public var collectionView : UICollectionView?
    public var mainDatas : Array<Any> = []
    public var scrollDirectionType : ScrollDirectionType = .ScrollVertical
    public var flowLayout : UICollectionViewFlowLayout?
    
   // MARK: - 初始化
    public convenience init(scrollDirectionType: ScrollDirectionType = .ScrollVertical) {
        self.init()
        
        setupFlowLayout()
        switch scrollDirectionType {
        case .ScrollHorizontal:
            flowLayout?.scrollDirection = UICollectionView.ScrollDirection.horizontal
            
        case .ScrollVertical:
            flowLayout?.scrollDirection = UICollectionView.ScrollDirection.vertical
         
        }
    }
    
    public convenience init(flowLayout layout: UICollectionViewFlowLayout) {
         self.init()
        
         flowLayout = layout
     }
    
    open func setupFlowLayout() {
        flowLayout = UICollectionViewFlowLayout.init()
        flowLayout?.minimumLineSpacing = 0
        flowLayout?.minimumInteritemSpacing = 0 
        flowLayout?.scrollDirection = UICollectionView.ScrollDirection.vertical
    }
    
    // MARK: - 布局
    override open func viewDidLoad() {
        super.viewDidLoad()

        if flowLayout == nil  {
            setupFlowLayout()
        }
        
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout!)
        collectionView?.backgroundColor = .clear
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        collectionView?.delaysContentTouches = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        
        view.addSubview(collectionView!)
        collectionView?.snp.makeConstraints{ (make) in
            make.top.equalTo(view.safeAreaInsets.top)
            make.left.equalTo(view.safeAreaInsets.left)
            make.right.equalTo(view.safeAreaInsets.right)
            make.bottom.equalTo(view.safeAreaInsets.bottom)
        }
        
        extendedLayoutIncludesOpaqueBars = true
        collectionView?.contentInsetAdjustmentBehavior = .automatic
        
        // Do any additional setup after loading the view.
        let gestureArray : [UIGestureRecognizer]? = navigationController?.view.gestureRecognizers
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
        return isMultiDatas() ? mainDatas.count : 1
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
