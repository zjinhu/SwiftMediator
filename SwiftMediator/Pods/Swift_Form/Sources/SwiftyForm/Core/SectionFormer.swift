//
//  SectionFormer.swift
//  SwiftyForm
//
//  Created by iOS on 2020/6/5.
//  Copyright © 2020 iOS. All rights reserved.
//

import UIKit

public final class SectionFormer{

    public init(_ rowFormer: RowFormer...) {
        self.rowFormers = rowFormer
    }
    
    public init(_ rowFormers: [RowFormer] = []) {
        self.rowFormers = rowFormers
    }
    
    /// All RowFormers. Default is empty.
    public private(set) var rowFormers = [RowFormer]()
    
    /// ViewFormer of applying section header. Default is applying simply 10px spacing section header.
    public private(set) var headerViewFormer: ViewFormer? = ViewFormer.init(withViewType: BaseHeaderFooterView.self)
    
    /// ViewFormer of applying section footer. Default is nil.
    public private(set) var footerViewFormer: ViewFormer?
    
    /// Return all row count.
    public var numberOfRows: Int {
        return rowFormers.count
    }
    
    /// Returns the first element of RowFormers, or `nil` if `self.rowFormers` is empty.
    public var firstRowFormer: RowFormer? {
        return rowFormers.first
    }
    
    /// Returns the last element of RowFormers, or `nil` if `self.rowFormers` is empty.
    public var lastRowFormer: RowFormer? {
        return rowFormers.last
    }
    
    public subscript(index: Int) -> RowFormer {
        return rowFormers[index]
    }
    
    public subscript(range: Range<Int>) -> [RowFormer] {
        return Array<RowFormer>(rowFormers[range])
    }
    
    /// 添加一行RowFormer
    @discardableResult
    public func append(rowFormer: RowFormer) -> Self {
        self.rowFormers.append(rowFormer)
        return self
    }
    
    /// 添加一个RowFormer数组
    @discardableResult
    public func add(rowFormers: [RowFormer]) -> Self {
        self.rowFormers += rowFormers
        return self
    }
    
    /// 在指定位置插入一个RowFormer
    @discardableResult
    public func insert(rowFormer: RowFormer, toIndex: Int) -> Self {
        let count = self.rowFormers.count
        if count == 0 ||  toIndex >= count {
            append(rowFormer: rowFormer)
            return self
        }
        self.rowFormers.insert(rowFormer, at: toIndex)
        return self
    }
    
    /// 在指定位置插入一个RowFormer数组
    @discardableResult
    public func insert(rowFormers: [RowFormer], toIndex: Int) -> Self {
        let count = self.rowFormers.count
        if count == 0 ||  toIndex >= count {
            add(rowFormers: rowFormers)
            return self
        }
        self.rowFormers.insert(contentsOf: rowFormers, at: toIndex)
        return self
    }
    
    /// 在特定的RowFormer之前插入一个RowFormer
    @discardableResult
    public func insert(rowFormer: RowFormer, above: RowFormer) -> Self {
        for (row, rowFormer) in self.rowFormers.enumerated() {
            if rowFormer === above {
                insert(rowFormer: rowFormer, toIndex: row)
                return self
            }
        }
        append(rowFormer: rowFormer)
        return self
    }
    
    /// 在特定的RowFormer之前插入一个RowFormer数组
    @discardableResult
    public func insert(rowFormers: [RowFormer], above: RowFormer) -> Self {
        for (row, rowFormer) in self.rowFormers.enumerated() {
            if rowFormer === above {
                insert(rowFormers: rowFormers, toIndex: row)
                return self
            }
        }
        add(rowFormers: rowFormers)
        return self
    }
    
    /// 在特定的RowFormer之后插入一个RowFormer
    @discardableResult
    public func insert(rowFormer: RowFormer, below: RowFormer) -> Self {
        for (row, rowFormer) in self.rowFormers.enumerated() {
            if rowFormer === below {
                insert(rowFormer: rowFormer, toIndex: row + 1)
                return self
            }
        }
        append(rowFormer: rowFormer)
        return self
    }
    
    /// 在特定的RowFormer之后插入一个RowFormer数组
    @discardableResult
    public func insert(rowFormers: [RowFormer], below: RowFormer) -> Self {
        for (row, rowFormer) in self.rowFormers.enumerated() {
            if rowFormer === below {
                insert(rowFormers: rowFormers, toIndex: row + 1)
                return self
            }
        }
        add(rowFormers: rowFormers)
        return self
    }
    
    /// 移除特定RowFormer
    @discardableResult
    public func remove(rowFormer: RowFormer) -> Self {
        var removedCount = 0
        for (index, _) in self.rowFormers.enumerated() {
            if rowFormers.contains(where: { $0 === rowFormer }) {
                remove(atIndex: index)
                removedCount += 1
                if removedCount >= rowFormers.count {
                    return self
                }
            }
        }
        return self
    }
    /// Remove RowFormers from instances of RowFormer.
    @discardableResult
    public func remove(rowFormers: [RowFormer]) -> Self {
        var removedCount = 0
        for (index, rowFormer) in self.rowFormers.enumerated() {
            if rowFormers.contains(where: { $0 === rowFormer }) {
                remove(atIndex: index)
                removedCount += 1
                if removedCount >= rowFormers.count {
                    return self
                }
            }
        }
        return self
    }
    
    /// 移除特定行数的RowFormer
    @discardableResult
    public func remove(atIndex: Int) -> Self {
        rowFormers.remove(at: atIndex)
        return self
    }
    
    ///移除特定范围的RowFormer
    @discardableResult
    public func remove(range: Range<Int>) -> Self {
        rowFormers.removeSubrange(range)
        return self
    }
    
    /// Set ViewFormer to apply section header.
    @discardableResult
    public func set(headerViewFormer viewFormer: ViewFormer?) -> Self {
        headerViewFormer = viewFormer
        return self
    }
    
    /// Set ViewFormer to apply section footer.
    @discardableResult
    public func set(footerViewFormer viewFormer: ViewFormer?) -> Self {
        footerViewFormer = viewFormer
        return self
    }

}
