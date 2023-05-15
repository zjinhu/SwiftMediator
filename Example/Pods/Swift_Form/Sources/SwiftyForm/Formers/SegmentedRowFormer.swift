//
//  BaseCellFormer.swift
//  SwiftyForm
//
//  Created by iOS on 2020/6/5.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit

/// SegmentedForm
public protocol SegmentedFormableRow: FormableRow {
    func formTitleImageView() -> UIImageView?
    func formSegmented() -> UISegmentedControl
    func formTitleLabel() -> UILabel?
}

/// SegmentedForm
open class SegmentedRowFormer<T: UITableViewCell>: BaseRowFormer<T>, Formable where T: SegmentedFormableRow {
    
    ///segment标题数组
    public var segmentTitles = [String]()
    ///segment默认选中
    public var selectedIndex: Int = 0
    ///segment切换回调
    public var onSegmentSelected: ((Int, String) -> Void)?
    
    /// SegmentedForm 选项卡变化回调
    /// - Parameter handler: handler description
    /// - Returns: description
    @discardableResult public final func onSegmentSelected(_ handler: @escaping ((Int, String) -> Void)) -> Self {
        onSegmentSelected = handler
        return self
    }
    
    /// SegmentedForm初始化
    /// - Parameter cell: cell description
    open override func cellInitialized(_ cell: T) {
        cell.formSegmented().addTarget(self, action: #selector(SegmentedRowFormer.valueChanged(segment:)), for: .valueChanged)
        let titleImageView = cell.formTitleImageView()
        titleImageView?.image = titleImage
    }
    
    /// SegmentedForm初始化
    open override func initialized() {
        rowHeight = 60
    }
    
    /// SegmentedForm 数据更新
    open override func update() {
        super.update()
        
        cell.selectionStyle = .none
        let titleLabel = cell.formTitleLabel()
        if let title = title {
            titleLabel?.text = title
        }
        
        if let attributedTitle = attributedTitle{
            titleLabel?.attributedText = attributedTitle
        }
        let segment = cell.formSegmented()
        segment.removeAllSegments()
        for (index, title) in segmentTitles.enumerated() {
            segment.insertSegment(withTitle: title, at: index, animated: false)
        }
        segment.selectedSegmentIndex = selectedIndex
        segment.isEnabled = enabled
 
        if enabled {
            _ = titleColor.map { titleLabel?.textColor = $0 }
            titleColor = nil
        } else {
            if titleColor == nil { titleColor = titleLabel?.textColor ?? .black }
            titleLabel?.textColor = titleDisabledColor
        }
    }
 
    @objc private dynamic func valueChanged(segment: UISegmentedControl) {
        if enabled {
            let index = segment.selectedSegmentIndex
            let selectedTitle = segment.titleForSegment(at: index)!
            selectedIndex = index
            onSegmentSelected?(selectedIndex, selectedTitle)
        }
    }
}
