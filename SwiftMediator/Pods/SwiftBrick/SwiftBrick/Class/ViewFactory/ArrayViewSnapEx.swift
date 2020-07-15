//
//  ArrayViewSnapEx.swift
//  SwiftBrick
//
//  Created by iOS on 2020/7/3.
//  Copyright © 2020 狄烨 . All rights reserved.
//

import SnapKit

public extension Array {
    var snp: ConstraintArrayDSL {
        return ConstraintArrayDSL(array: self as! Array<ConstraintView>)
    }
}

public struct ConstraintArrayDSL {
    @discardableResult
    public func prepareConstraints(_ closure: (_ make: ConstraintMaker) -> Void) -> [Constraint] {
        var constraints = Array<Constraint>()
        for view in self.array {
            constraints.append(contentsOf: view.snp.prepareConstraints(closure))
        }
        return constraints
    }
    
    public func makeConstraints(_ closure: (_ make: ConstraintMaker) -> Void) {
        for view in self.array {
            view.snp.makeConstraints(closure)
        }
    }
    
    public func remakeConstraints(_ closure: (_ make: ConstraintMaker) -> Void) {
        for view in self.array {
            view.snp.remakeConstraints(closure)
        }
    }
    
    public func updateConstraints(_ closure: (_ make: ConstraintMaker) -> Void) {
        for view in self.array {
            view.snp.updateConstraints(closure)
        }
    }
    
    public func removeConstraints() {
        for view in self.array {
            view.snp.removeConstraints()
        }
    }
    
    /// 固定排版样式,不会撑开主视图,
    /// - Parameters:
    ///   - fixedItemWidth: 固定宽度
    ///   - fixedItemHeight: 固定高度
    ///   - fixedInteritemSpacing: 固定间距
    ///   - fixedLineSpacing: 固定行距
    ///   - warpCount: 每行个数
    ///   - edgeInset: 修订边距
    public func distributeViewsForm(fixedItemWidth: CGFloat,
                                    fixedItemHeight: CGFloat,
                                    fixedInteritemSpacing:CGFloat,
                                    fixedLineSpacing:CGFloat,
                                    warpCount: Int,
                                    edgeInset: UIEdgeInsets = UIEdgeInsets.zero) {

        guard self.array.count > 0, warpCount >= 1 else {
            return
        }
        let leftSpacing = edgeInset.left
        let topSpacing = edgeInset.top
        
        let columnCount = warpCount
        let rowCount = self.array.count % warpCount == 0 ? self.array.count / warpCount : self.array.count / warpCount + 1;
        
        var prev : ConstraintView?
        
        for (i,v) in self.array.enumerated() {
            
            let currentRow = i / warpCount
            let currentColumn = i % warpCount
            
            v.snp.makeConstraints({ (make) in
                make.width.equalTo(fixedItemWidth)
                make.height.equalTo(fixedItemHeight)
                if currentRow == 0 {//fisrt row
                    make.top.equalToSuperview().offset(topSpacing)
                }
                if currentRow == rowCount - 1 {//last row
                    if currentRow != 0 && i - columnCount >= 0 {
                        make.top.equalTo(self.array[i-columnCount].snp.bottom).offset(fixedLineSpacing)
                    }
                }
                
                if currentRow != 0 && currentRow != rowCount - 1 {//other row
                    make.top.equalTo(self.array[i-columnCount].snp.bottom).offset(fixedLineSpacing);
                }
                
                if currentColumn == 0 {//first col
                    make.left.equalToSuperview().offset(leftSpacing)
                }
                if currentColumn == warpCount - 1 {//last col
                    if currentColumn != 0 {
                        make.left.equalTo(prev!.snp.right).offset(fixedInteritemSpacing)
                    }
                }
                
                if currentColumn != 0 && currentColumn != warpCount - 1 {//other col
                    make.left.equalTo(prev!.snp.right).offset(fixedInteritemSpacing);
                }
            })
            prev = v
        }
    }
    
    /// 固定间距,可变大小 撑开主视图
    /// - Parameters:
    ///   - axisType: 垂直或水平
    ///   - fixedSpacing: 固定间距
    ///   - leadSpacing: 左边距(上边距)
    ///   - tailSpacing: 右边距(下边距)
    public func distributeViewsAlong(axisType:NSLayoutConstraint.Axis,
                                     fixedSpacing:CGFloat,
                                     leadSpacing:CGFloat = 0,
                                     tailSpacing:CGFloat = 0) {
        
        guard self.array.count > 1 else {
            return
        }
        
        if axisType == .horizontal {
            var prev : ConstraintView?
            for (i, v) in self.array.enumerated() {
                v.snp.makeConstraints({ (make) in
                    if prev != nil {
                        make.width.equalTo(prev!)
                        make.left.equalTo((prev?.snp.right)!).offset(fixedSpacing)
                        if (i == self.array.count - 1) {//last one
                            make.right.equalToSuperview().offset(-tailSpacing);
                        }
                    }else {
                        make.left.equalToSuperview().offset(leadSpacing);
                    }
                })
                prev = v;
            }
        }else {
            var prev : ConstraintView?
            for (i, v) in self.array.enumerated() {
                v.snp.makeConstraints({ (make) in
                    if prev != nil {
                        make.height.equalTo(prev!)
                        make.top.equalTo((prev?.snp.bottom)!).offset(fixedSpacing)
                        if (i == self.array.count - 1) {//last one
                            make.bottom.equalToSuperview().offset(-tailSpacing);
                        }
                    }else {
                        make.top.equalToSuperview().offset(leadSpacing);
                    }
                })
                prev = v;
            }
        }
    }
    
    /// 固定大小,可变间距 撑开主视图
    /// - Parameters:
    ///   - axisType: 垂直或水平
    ///   - fixedItemLength: item对应方向的宽或者高 垂直时，是每个view的固定高度, 默认为 nil, 可不传，
    ///   - leadSpacing: 左边距(上边距)
    ///   - tailSpacing: 右边距(下边距)
    public func distributeViewsAlong(axisType:NSLayoutConstraint.Axis,
                                     fixedItemLength:CGFloat,
                                     leadSpacing:CGFloat = 0,
                                     tailSpacing:CGFloat = 0) {
        
        guard self.array.count > 1 else {
            return
        }
        
        if axisType == .horizontal {
            var prev : ConstraintView?
            for (i, v) in self.array.enumerated() {
                v.snp.makeConstraints({ (make) in
                    make.width.equalTo(fixedItemLength)
                    if prev != nil {
                        if (i == self.array.count - 1) {//last one
                            make.right.equalToSuperview().offset(-tailSpacing);
                        }else {
                            let offset = (CGFloat(1) - (CGFloat(i) / CGFloat(self.array.count - 1))) *
                                (fixedItemLength + leadSpacing) - CGFloat(i) *
                                tailSpacing /
                                CGFloat(self.array.count - 1)
                            make.right
                                .equalToSuperview()
                                .multipliedBy(CGFloat(i) / CGFloat(self.array.count - 1))
                                .offset(offset)
                        }
                    }else {
                        make.left.equalToSuperview().offset(leadSpacing);
                    }
                })
                prev = v;
            }
        }else {
            var prev : ConstraintView?
            for (i, v) in self.array.enumerated() {
                v.snp.makeConstraints({ (make) in
                    make.height.equalTo(fixedItemLength)
                    if prev != nil {
                        if (i == self.array.count - 1) {//last one
                            make.bottom.equalToSuperview().offset(-tailSpacing);
                        }else {
                            let offset = (CGFloat(1) - (CGFloat(i) / CGFloat(self.array.count - 1))) *
                                (fixedItemLength + leadSpacing) - CGFloat(i) *
                                tailSpacing /
                                CGFloat(self.array.count - 1)
                            
                            make.bottom
                                .equalToSuperview()
                                .multipliedBy(CGFloat(i) / CGFloat(self.array.count-1))
                                .offset(offset)
                        }
                    }else {
                        make.top.equalToSuperview().offset(leadSpacing);
                    }
                })
                prev = v;
            }
        }
    }
    
    /// 固定大小,可变中间间距,上下左右间距默认为0,可以设置 撑开主视图
    /// - Parameters:
    ///   - fixedItemWidth: 固定宽度
    ///   - fixedItemHeight: 固定高度
    ///   - warpCount: 每行多少列
    ///   - edgeInset: 修订边距 整个布局的 上下左右边距，默认为 .zero
    public func distributeSudokuViews(fixedItemWidth: CGFloat,
                                      fixedItemHeight: CGFloat,
                                      warpCount: Int,
                                      edgeInset: UIEdgeInsets = UIEdgeInsets.zero) {
        
        guard self.array.count > 1, warpCount >= 1 else {
            return
        }
        
        let rowCount = self.array.count % warpCount == 0 ? self.array.count / warpCount : self.array.count / warpCount + 1;
        let columnCount = warpCount
        
        for (i,v) in self.array.enumerated() {
            
            let currentRow = i / warpCount
            let currentColumn = i % warpCount
            
            v.snp.makeConstraints({ (make) in
                make.width.equalTo(fixedItemWidth)
                make.height.equalTo(fixedItemHeight)
                if currentRow == 0 {//fisrt row
                    make.top.equalToSuperview().offset(edgeInset.top)
                }
                if currentRow == rowCount - 1 {//last row
                    make.bottom.equalToSuperview().offset(-edgeInset.bottom)
                }
                
                if currentRow != 0 && currentRow != rowCount - 1 {//other row
                    let offset = (CGFloat(1) - CGFloat(currentRow) / CGFloat(rowCount - 1)) * (fixedItemHeight + edgeInset.top) - CGFloat(currentRow) * edgeInset.bottom / CGFloat(rowCount - 1)
                    make.bottom
                        .equalToSuperview()
                        .multipliedBy(CGFloat(currentRow) / CGFloat(rowCount - 1))
                        .offset(offset);
                }
                
                if currentColumn == 0 {//first col
                    make.left.equalToSuperview().offset(edgeInset.left)
                }
                if currentColumn == columnCount - 1 {//last col
                    make.right.equalToSuperview().offset(-edgeInset.right)
                }
                
                if currentColumn != 0 && currentColumn != columnCount - 1 {//other col
                    let offset = (CGFloat(1) - CGFloat(currentColumn) / CGFloat(columnCount - 1)) * (fixedItemWidth + edgeInset.left) - CGFloat(currentColumn) * edgeInset.right / CGFloat(columnCount - 1)
                    make.right
                        .equalToSuperview()
                        .multipliedBy(CGFloat(currentColumn) / CGFloat(columnCount - 1))
                        .offset(offset);
                }
            })
        }
    }
    
    /// 固定间距,可变大小,上下左右间距默认为0,可以设置 撑开主视图
    /// - Parameters:
    ///   - fixedLineSpacing: 固定行距
    ///   - fixedInteritemSpacing: 固定间距
    ///   - warpCount: 每行多少列
    ///   - edgeInset: 修订边距 整个布局的 上下左右边距，默认为 .zero
    public func distributeSudokuViews(fixedLineSpacing: CGFloat,
                                      fixedInteritemSpacing: CGFloat,
                                      warpCount: Int,
                                      edgeInset: UIEdgeInsets = UIEdgeInsets.zero) {
        
        guard self.array.count > 1, warpCount >= 1 else {
            return
        }
        
        let columnCount = warpCount
        let rowCount = self.array.count % warpCount == 0 ? self.array.count / warpCount : self.array.count / warpCount + 1;
        
        var prev : ConstraintView?
        
        for (i,v) in self.array.enumerated() {
            
            let currentRow = i / warpCount
            let currentColumn = i % warpCount
            
            v.snp.makeConstraints({ (make) in
                if prev != nil {
                    make.width.height.equalTo(prev!)
                }
                if currentRow == 0 {//fisrt row
                    make.top.equalToSuperview().offset(edgeInset.top)
                }
                if currentRow == rowCount - 1 {//last row
                    if currentRow != 0 && i - columnCount >= 0 {
                        make.top.equalTo(self.array[i-columnCount].snp.bottom).offset(fixedLineSpacing)
                    }
                    make.bottom.equalToSuperview().offset(-edgeInset.bottom)
                }
                
                if currentRow != 0 && currentRow != rowCount - 1 {//other row
                    make.top.equalTo(self.array[i-columnCount].snp.bottom).offset(fixedLineSpacing);
                }
                
                if currentColumn == 0 {//first col
                    make.left.equalToSuperview().offset(edgeInset.left)
                }
                if currentColumn == warpCount - 1 {//last col
                    if currentColumn != 0 {
                        make.left.equalTo(prev!.snp.right).offset(fixedInteritemSpacing)
                    }
                    make.right.equalToSuperview().offset(-edgeInset.right)
                }
                
                if currentColumn != 0 && currentColumn != warpCount - 1 {//other col
                    make.left.equalTo(prev!.snp.right).offset(fixedInteritemSpacing);
                }
            })
            prev = v
        }
    }
    
    public var target: AnyObject? {
        return self.array as AnyObject
    }
    
    internal let array: Array<ConstraintView>
    
    internal init(array: Array<ConstraintView>) {
        self.array = array
        
    }
    
}
