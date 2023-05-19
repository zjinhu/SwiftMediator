//
//  JHBaseTableViewController.swift
//  JHToolsModule_Swift
//
//  Created by iOS on 18/11/2019.
//  Copyright © 2019 HU. All rights reserved.
//

import UIKit
// MARK: ===================================VC基类:UITableViewController=========================================
open class TableViewController: ViewController ,UITableViewDelegate,UITableViewDataSource{
    
    // MARK: - 参数变量
    public enum TableViewStyleType {
        case stylePlain
        case styleGrouped
        case styleInsetGrouped
    }
    
    public var tableView: UITableView?
    public var mainDatas: Array<Any> = []
    public var tableViewStyleType: TableViewStyleType = .stylePlain
    
    // MARK: - 初始化
    public convenience init(tableViewStyle: TableViewStyleType = .stylePlain) {
        self.init()
        tableViewStyleType = tableViewStyle
    }
    
    /// 子类继承时重写此方法可设置Table样式：self.tableViewStyleType =  .StyleGrouped，或者Init时候设置
    open func setupTableViewStyleType(){
        //        tableViewStyleType = tableViewStyleType
    }
    
    // MARK: - 布局
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewStyleType()
        
        switch tableViewStyleType {
            
        case .styleInsetGrouped:
            if #available(iOS 13.0, *) {
                tableView = UITableView(frame: .zero, style: .insetGrouped)
            }else{
                tableView = UITableView(frame: .zero, style: .grouped)
            }
            
        case .styleGrouped:
            tableView = UITableView(frame: .zero, style: .grouped)
            
        case .stylePlain:
            tableView = UITableView(frame: .zero, style: .plain)
            
        }
        
        if #available(iOS 15.0, *) {
            tableView?.sectionHeaderTopPadding = 0
            tableView?.isPrefetchingEnabled = false
        }
        
        tableView?.backgroundColor = .clear
        tableView?.delegate = self
        tableView?.dataSource = self
        
        tableView?.separatorStyle = .none
        //        tableView?.separatorColor = .lightGray
        tableView?.showsVerticalScrollIndicator = false
        tableView?.showsHorizontalScrollIndicator = false
        tableView?.estimatedRowHeight = 100
        tableView?.rowHeight = UITableView.automaticDimension
        tableView?.estimatedSectionHeaderHeight = CGFloat.leastNormalMagnitude
        tableView?.estimatedSectionFooterHeight = CGFloat.leastNormalMagnitude
        tableView?.translatesAutoresizingMaskIntoConstraints = false
        //头角需要自适应高度的话请设置
        //    tableView.estimatedSectionHeaderHeight = 200;
        //    tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        //    tableView.estimatedSectionFooterHeight = 200;
        //    tableView.sectionFooterHeight = UITableViewAutomaticDimension;
        tableView?.delaysContentTouches = true
        
        if let tableView = tableView{
            view.addSubview(tableView)
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: view.topAnchor),
                tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            ])
        }
        
        tableView?.contentInsetAdjustmentBehavior = .automatic
        
        let gestureArray: [UIGestureRecognizer]? = navigationController?.view.gestureRecognizers
        
        gestureArray?.forEach({ (gesture) in
            if gesture.isEqual(UIScreenEdgePanGestureRecognizer.self) {
                tableView?.panGestureRecognizer.require(toFail: gesture)
            }
        })
        tableView?.registerCell(TableViewCell.self)
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
    
    // MARK: - tableView代理
    open func numberOfSections(in tableView: UITableView) -> Int {
        return isMultiDatas() ? mainDatas.count: 1
    }
    
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isMultiDatas() {
            let data  = mainDatas[section] as! Array<Any>
            return data.count
        }else{
            return mainDatas.count
        }
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(TableViewCell.self)
        cell.textLabel?.text = String(describing: indexPath.row)
        return cell
    }
}
