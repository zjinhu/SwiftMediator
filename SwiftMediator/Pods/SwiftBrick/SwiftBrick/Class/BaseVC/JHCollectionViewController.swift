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
        
        self.configFlowLayout()
        switch scrollDirectionType {
        case .ScrollHorizontal:
            self.flowLayout?.scrollDirection = UICollectionView.ScrollDirection.horizontal
            
        case .ScrollVertical:
            self.flowLayout?.scrollDirection = UICollectionView.ScrollDirection.vertical
         
        }
    }
    
    public convenience init(flowLayout: UICollectionViewFlowLayout) {
         self.init()
        
         self.flowLayout = flowLayout
     }
    
    func configFlowLayout() {
        self.flowLayout = UICollectionViewFlowLayout.init()
        self.flowLayout?.minimumLineSpacing = 0
        self.flowLayout?.minimumInteritemSpacing = 0
        self.flowLayout?.minimumLineSpacing = 0
    }
    
    // MARK: - 布局
    override open func viewDidLoad() {
        super.viewDidLoad()

        if self.flowLayout == nil  {
            self.configFlowLayout()
            self.flowLayout?.scrollDirection = UICollectionView.ScrollDirection.vertical
        }
        
        self.collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: self.flowLayout!)
        self.collectionView?.backgroundColor = .clear
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        
        self.collectionView?.delaysContentTouches = true
        self.collectionView?.showsVerticalScrollIndicator = false
        self.collectionView?.showsHorizontalScrollIndicator = false
        
        self.view.addSubview(self.collectionView!)
        self.collectionView?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.view.safeAreaInsets.top );
            make.left.equalTo(self.view.safeAreaInsets.left);
            make.right.equalTo(self.view.safeAreaInsets.right);
            make.bottom.equalTo(self.view.safeAreaInsets.bottom);
        })
        
        self.extendedLayoutIncludesOpaqueBars = true
        self.collectionView?.contentInsetAdjustmentBehavior = .automatic
        
        // Do any additional setup after loading the view.
        let gestureArray : [UIGestureRecognizer] = (self.navigationController?.view.gestureRecognizers)!
        for gesture in gestureArray {
            if gesture.isEqual(UIScreenEdgePanGestureRecognizer.self) {
                self.collectionView?.panGestureRecognizer.require(toFail: gesture)
            }
        }
        
        JHCollectionViewCell.registerCell(collectionView: self.collectionView!)
    }
    // MARK: - 数据源判断
    func isMultiDatas() -> Bool {
        let data = self.mainDatas.first
        if data is Array<Any> && self.mainDatas.count > 0{
            return true
        }else{
            return false
        }
    }

    // MARK: - UICollectionView
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.isMultiDatas() ? self.mainDatas.count : 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.isMultiDatas() {
            let data  = self.mainDatas[section] as! Array<Any>
            return data.count
        }else{
            return self.mainDatas.count
        }
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = JHCollectionViewCell.dequeueReusableCell(collectionView: collectionView, indexPath: indexPath)
        return cell
    }
    
}
