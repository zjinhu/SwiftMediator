//
//  BaseCellFormer.swift
//  SwiftyForm
//
//  Created by iOS on 2020/6/5.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit

public protocol InlineDatePickerFormableRow: FormableRow {
    func formTitleImageView() -> UIImageView?
    func formTitleLabel() -> UILabel?
    func formDisplayLabel() -> UILabel?
}

open class InlineDatePickerRowFormer<T: UITableViewCell>: BaseRowFormer<T>, Formable, ConfigurableInlineForm where T: InlineDatePickerFormableRow {

    public typealias InlineCellType = DatePickerCell
    
    public let inlineRowFormer: RowFormer
    override open var canBecomeEditing: Bool {
        return enabled
    }

    public var date: Date = Date()
    public var displayDisabledColor: UIColor? = .lightGray
    public var displayEditingColor: UIColor?
    public var titleEditingColor: UIColor?
    
    public var onDateChanged: ((Date) -> Void)?
    public var onEditingBegin: ((Date, T) -> Void)?
    public var onEditingEnded: ((Date, T) -> Void)?
    public var displayTextFromDate: ((Date) -> String)?
    public var displayTextColor: UIColor?
    
    public override init() {
        inlineRowFormer = DatePickerRowFormer<InlineCellType>()
        super.init()
    }
    
    @discardableResult
    public final func onDateChanged(_ handler: @escaping ((Date) -> Void)) -> Self {
        onDateChanged = handler
        return self
    }
    
    public final func onEditingBegin(handler: @escaping ((Date, T) -> Void)) -> Self {
        onEditingBegin = handler
        return self
    }
    
    public final func onEditingEnded(handler: @escaping ((Date, T) -> Void)) -> Self {
        onEditingEnded = handler
        return self
    }

    @discardableResult
    public final func displayTextFromDate(_ handler: @escaping ((Date) -> String)) -> Self {
        displayTextFromDate = handler
        return self
    }
    
    open override func initialized() {
        rowHeight = 60
    }
    
    open override func cellInitialized(_ cell: T) {
        let titleImageView = cell.formTitleImageView()
        titleImageView?.image = titleImage
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
        displayLabel?.text = displayTextFromDate?(date) ?? "\(date)"
        let titleImageView = cell.formTitleImageView()
        titleImageView?.image = titleImage
        if enabled {
            if isEditing {
                if titleColor == nil { titleColor = titleLabel?.textColor ?? .black }
                if displayTextColor == nil { displayTextColor = displayLabel?.textColor ?? .black }
                _ = titleEditingColor.map { titleLabel?.textColor = $0 }
                _ = displayEditingColor.map { displayLabel?.textColor = $0 }
            } else {
                _ = titleColor.map { titleLabel?.textColor = $0 }
                _ = displayTextColor.map { displayLabel?.textColor = $0 }
                titleColor = nil
                displayTextColor = nil
            }
        } else {
            if titleColor == nil { titleColor = titleLabel?.textColor ?? .black }
            if displayTextColor == nil { displayTextColor = displayLabel?.textColor ?? .black }
            _ = titleDisabledColor.map { titleLabel?.textColor = $0 }
            _ = displayDisabledColor.map { displayLabel?.textColor = $0 }
        }
        
        let inlineRowFormer = self.inlineRowFormer as! DatePickerRowFormer<InlineCellType>
        inlineRowFormer.configure {
            $0.onDateChanged(dateChanged)
            $0.enabled = enabled
            $0.date = date
        }.update()
    }
    
    open override func cellSelected(indexPath: IndexPath) {
        former?.deselect(animated: true)
    }
    
    private func dateChanged(date: Date) {
        if enabled {
            self.date = date
            cell.formDisplayLabel()?.text = displayTextFromDate?(date) ?? "\(date)"
            onDateChanged?(date)
        }
    }
    
    public func editingDidBegin() {
        if enabled {
            let titleLabel = cell.formTitleLabel()
            let displayLabel = cell.formDisplayLabel()
            if titleColor == nil { titleColor = titleLabel?.textColor ?? .black }
            if displayTextColor == nil { displayTextColor = displayLabel?.textColor ?? .black }
            _ = titleEditingColor.map { titleLabel?.textColor = $0 }
            _ = displayEditingColor.map { displayLabel?.textColor = $0 }
            isEditing = true
        }
        onEditingBegin?(date, cell)
    }
    
    public func editingDidEnd() {
        let titleLabel = cell.formTitleLabel()
        let displayLabel = cell.formDisplayLabel()
        if enabled {
            _ = titleColor.map { titleLabel?.textColor = $0 }
            _ = displayTextColor.map { displayLabel?.textColor = $0 }
            titleColor = nil
            displayTextColor = nil
        } else {
            if titleColor == nil { titleColor = titleLabel?.textColor ?? .black }
            if displayTextColor == nil { displayTextColor = displayLabel?.textColor ?? .black }
            titleLabel?.textColor = titleDisabledColor
            displayLabel?.textColor = displayDisabledColor
        }
        isEditing = false
        onEditingEnded?(date, cell)
    }

}
