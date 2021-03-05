//
//  RowFormer.swift
//  SwiftyForm
//
//  Created by iOS on 2020/6/5.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit

public protocol FormableRow{
    
    func updateWithRowFormer(_ rowFormer: RowFormer)
}

open class RowFormer{
    
    public internal(set) final weak var former: Former?
    public final let cellType: UITableViewCell.Type
    
    /// cell高度
    public final var rowHeight: CGFloat = 44
    public final var isEditing = false
    
    
    /// cell 标题
    public final var title: String?
    public final var attributedTitle: NSMutableAttributedString?
    /// cell左侧小图片
    public final var titleImage: UIImage?
    
    public final var enabled = true { didSet { update() } }
    open var canBecomeEditing: Bool {
        return false
    }
    
    /// 闭包设置cell
    internal final var cellSetup: ((UITableViewCell) -> Void)?
    
    /// cell点击
    internal final var onSelected: ((RowFormer) -> Void)?
    
    /// cell更新
    internal final var onUpdate: ((RowFormer) -> Void)?
    
    /// cell动态高度
    internal final var dynamicRowHeight: ((UITableView, IndexPath) -> CGFloat)?
    
    public init<T: UITableViewCell>(withCellType type: T.Type) {
            cellType = type
            initialized()
    }
    
    @discardableResult
    public final func cellSetup(_ handler: @escaping ((UITableViewCell) -> Void)) -> Self {
        cellSetup = handler
        return self
    }
    
    @discardableResult
    public final func dynamicRowHeight(_ handler: @escaping ((UITableView, IndexPath) -> CGFloat)) -> Self {
        dynamicRowHeight = handler
        return self
    }
    
    open func initialized() {
        
    }
    
    open func update() {
        cellInstance.isUserInteractionEnabled = enabled
        onUpdate?(self)
        
        if let formableRow = cellInstance as? FormableRow {
            formableRow.updateWithRowFormer(self)
        }
        
        if let inlineRow = self as? InlineForm {
            let inlineRowFormer = inlineRow.inlineRowFormer
            inlineRowFormer.update()
            
            if let inlineFormableRow = inlineRowFormer.cellInstance as? FormableRow {
                inlineFormableRow.updateWithRowFormer(inlineRowFormer)
            }
        }
    }
    
    open func cellSelected(indexPath: IndexPath) {
        if enabled {
            onSelected?(self)
        }
    }
    
    private final var _cellInstance: UITableViewCell?
    
    var cellInstance: UITableViewCell {
        if _cellInstance == nil {
            _cellInstance = cellType.init(style: .default, reuseIdentifier: nil)
            cellInstanceInitialized(_cellInstance!)
            cellSetup?(_cellInstance!)
        }
        return _cellInstance!
    }
    
    func cellInstanceInitialized(_ cell: UITableViewCell) {
        
    }
    
}
