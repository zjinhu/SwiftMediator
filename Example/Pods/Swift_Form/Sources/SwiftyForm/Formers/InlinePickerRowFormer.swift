//
//  BaseCellFormer.swift
//  SwiftyForm
//
//  Created by iOS on 2020/6/5.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit

public protocol InlinePickerFormableRow: FormableRow {
    func formTitleImageView() -> UIImageView?
    func formTitleLabel() -> UILabel?
    func formDisplayLabel() -> UILabel?
}

open class InlinePickerItem<S>: PickerItem<S> {
    /// 右侧副标题/说明
    public let displayTitle: NSAttributedString?
    public init(title: String, displayTitle: NSAttributedString? = nil, value: S? = nil) {
        self.displayTitle = displayTitle
        super.init(title: title, value: value)
    }
}

open class InlinePickerRowFormer<T: UITableViewCell, S>: BaseRowFormer<T>, Formable, ConfigurableInlineForm where T: InlinePickerFormableRow {

    public typealias InlineCellType = PickerCell
    
    public let inlineRowFormer: RowFormer
    override open var canBecomeEditing: Bool {
        return enabled
    }
    /// picker数据源
    public var pickerItems: [InlinePickerItem<S>] = []
    ///默认选中
    public var selectedRow: Int = 0
    ///副标题颜色
    public var displayTextColor: UIColor?
    ///不可用时副标题颜色
    public var displayDisabledColor: UIColor? = .lightGray
    ///标题颜色
    public var titleEditingColor: UIColor?
    ///副标题编辑中颜色
    public var displayEditingColor: UIColor?
    ///数据变化时回调
    public var onValueChanged: ((InlinePickerItem<S>) -> Void)?
    ///开始数据变化回调
    public var onEditingBegin: ((InlinePickerItem<S>, T) -> Void)?
    ///数据变化结束回调
    public var onEditingEnded: ((InlinePickerItem<S>, T) -> Void)?
    
    
    public override init() {
        inlineRowFormer = PickerRowFormer<InlineCellType, S>()
        super.init()
    }
    @discardableResult
    public final func onValueChanged(_ handler: @escaping ((InlinePickerItem<S>) -> Void)) -> Self {
        onValueChanged = handler
        return self
    }

    public final func onEditingBegin(handler: @escaping ((InlinePickerItem<S>, T) -> Void)) -> Self {
        onEditingBegin = handler
        return self
    }

    public final func onEditingEnded(handler: @escaping ((InlinePickerItem<S>, T) -> Void)) -> Self {
        onEditingEnded = handler
        return self
    }
    
    open override func cellInitialized(_ cell: T) {
        let titleImageView = cell.formTitleImageView()
        titleImageView?.image = titleImage
    }
    
    open override func initialized() {
        rowHeight = 60
    }

    open override func update() {
        super.update()
        
        let titleLabel = cell.formTitleLabel()
        if let title = title {
            titleLabel?.text = title
        }
        
        if let attributedTitle = attributedTitle{
            titleLabel?.attributedText = attributedTitle
        }
        let displayLabel = cell.formDisplayLabel()
        if pickerItems.isEmpty {
            displayLabel?.text = ""
        } else {

            // Sets selected row to 0 to avoid 'index out of range' error. This is in case the updated picker items array count
            // is less than the prior array count.
            if pickerItems.count <= selectedRow {
                selectedRow = 0
            }
            
            displayLabel?.text = pickerItems[selectedRow].title
            _ = pickerItems[selectedRow].displayTitle.map { displayLabel?.attributedText = $0 }
        }

        if enabled {
            if isEditing {
                if titleColor == nil { titleColor = titleLabel?.textColor }
                _ = titleEditingColor.map { titleLabel?.textColor = $0 }
                
                if pickerItems[selectedRow].displayTitle == nil {
                    if displayTextColor == nil { displayTextColor = displayLabel?.textColor ?? .black }
                    _ = displayEditingColor.map { displayLabel?.textColor = $0 }
                }
            } else {
                _ = titleColor.map { titleLabel?.textColor = $0 }
                _ = displayTextColor.map { displayLabel?.textColor = $0 }
                titleColor = nil
                displayTextColor = nil
            }
        } else {
            if titleColor == nil { titleColor = titleLabel?.textColor ?? .black }
            titleLabel?.textColor = titleDisabledColor
            if displayTextColor == nil { displayTextColor = displayLabel?.textColor ?? .black }
            displayLabel?.textColor = displayDisabledColor
        }
        
        let inlineRowFormer = self.inlineRowFormer as! PickerRowFormer<InlineCellType, S>
        inlineRowFormer.configure {
            $0.pickerItems = pickerItems
            $0.selectedRow = selectedRow
            $0.enabled = enabled
        }.onValueChanged(valueChanged).update()
    }

    open override func cellSelected(indexPath: IndexPath) {
        former?.deselect(animated: true)
    }
    
    public func editingDidBegin() {
        if enabled {
            let titleLabel = cell.formTitleLabel()
            let displayLabel = cell.formDisplayLabel()
            
            if titleColor == nil { titleColor = titleLabel?.textColor ?? .black }
            _ = titleEditingColor.map { titleLabel?.textColor = $0 }
            
            if pickerItems[selectedRow].displayTitle == nil {
                if displayTextColor == nil { displayTextColor = displayLabel?.textColor ?? .black }
                _ = displayEditingColor.map { displayLabel?.textColor = $0 }
            }
            isEditing = true
        }
        onEditingBegin?(pickerItems[selectedRow], cell)
    }
    
    public func editingDidEnd() {
        isEditing = false
        let titleLabel = cell.formTitleLabel()
        let displayLabel = cell.formDisplayLabel()
        
        if enabled {
            _ = titleColor.map { titleLabel?.textColor = $0 }
            titleColor = nil
            
            if pickerItems[selectedRow].displayTitle == nil {
                _ = displayTextColor.map { displayLabel?.textColor = $0 }
            }
            displayTextColor = nil
        } else {
            if titleColor == nil { titleColor = titleLabel?.textColor ?? .black }
            if displayTextColor == nil { displayTextColor = displayLabel?.textColor ?? .black }
            titleLabel?.textColor = titleDisabledColor
            displayLabel?.textColor = displayDisabledColor
        }
        onEditingEnded?(pickerItems[selectedRow], cell)
    }

    private func valueChanged(pickerItem: PickerItem<S>) {
        if enabled {
            let inlineRowFormer = self.inlineRowFormer as! PickerRowFormer<InlineCellType, S>
            let inlinePickerItem = pickerItem as! InlinePickerItem
            let displayLabel = cell.formDisplayLabel()
            
            selectedRow = inlineRowFormer.selectedRow
            displayLabel?.text = inlinePickerItem.title
            if let displayTitle = inlinePickerItem.displayTitle {
                displayLabel?.attributedText = displayTitle
            } else {
                if displayTextColor == nil { displayTextColor = displayLabel?.textColor ?? .black }
                _ = displayEditingColor.map { displayLabel?.textColor = $0 }
            }
            onValueChanged?(inlinePickerItem)
        }
    }
}
