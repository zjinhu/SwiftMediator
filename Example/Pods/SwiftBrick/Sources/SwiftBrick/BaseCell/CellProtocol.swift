//
//  CellProtocol.swift
//  SwiftBrick
//
//  Created by iOS on 2020/5/15.
//  Copyright © 2020 狄烨 . All rights reserved.
//

import Foundation
import UIKit
// MARK: ===================================Cell协议=========================================
/// 协议定义Cell
public protocol Reusable {
    static var reuseIdentifier: String { get }
}

public extension Reusable {
    static var reuseIdentifier: String { return String(describing: self) }
}

public extension UITableView {
    
    /// 注册UITableViewCell
    /// - Parameter cellType: UITableViewCell类
    func registerCell<T: UITableViewCell>(_ cellType: T.Type)
        where T: Reusable {
            register(cellType.self, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    /// 复用已注册的UITableViewCell
    /// - Parameter cellType: UITableViewCell
    /// - Returns: UITableViewCell
    func dequeueReusableCell<T: UITableViewCell>(_ cellType: T.Type = T.self) -> T
        where T: Reusable {
            guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseIdentifier) as? T else {
                fatalError(
                    "Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) matching type \(cellType.self). "
                )
            }
            return cell
    }
    
    /// 注册UITableViewHeaderFooterView
    /// - Parameter headerFooterViewType: UITableViewHeaderFooterView类
    func registerHeaderFooterView<T: UITableViewHeaderFooterView>(_ headerFooterViewType: T.Type)
        where T: Reusable {
            register(headerFooterViewType.self, forHeaderFooterViewReuseIdentifier: headerFooterViewType.reuseIdentifier)
    }
    
    /// 复用已注册的UITableViewHeaderFooterView
    /// - Parameter headerFooterViewType: UITableViewHeaderFooterView
    /// - Returns: UITableViewHeaderFooterView
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_ headerFooterViewType: T.Type = T.self) -> T?
        where T: Reusable {
            guard let view = dequeueReusableHeaderFooterView(withIdentifier: headerFooterViewType.reuseIdentifier) as? T? else {
                fatalError(
                    "Failed to dequeue a header/footer with identifier \(headerFooterViewType.reuseIdentifier) "
                )
            }
            return view
    }
    
}

public extension UICollectionView {
    
    /// 注册UICollectionViewCell
    /// - Parameter cellType: UICollectionViewCell
    func registerCell<T: UICollectionViewCell>(_ cellType: T.Type)
        where T: Reusable {
            register(cellType.self, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }
    
    /// 复用已经注册的UICollectionViewCell
    /// - Parameters:
    ///   - cellType: UICollectionViewCell
    ///   - indexPath: indexPath
    /// - Returns: UICollectionViewCell
    func dequeueReusableCell<T: UICollectionViewCell>(_ cellType: T.Type = T.self, indexPath: IndexPath) -> T
        where T: Reusable {
            let bareCell = dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath)
            guard let cell = bareCell as? T else {
                fatalError(
                    "Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) matching type \(cellType.self). "
                )
            }
            return cell
    }
    
    /// 样式，header还是footer
    enum ReusableViewKindType {
        case sectionHeader//UICollectionElementKindSectionHeader
        case sectionFooter//UICollectionElementKindSectionFooter
    }
    
    /// 注册UICollectionReusableView，用于header、footer
    /// - Parameters:
    ///   - headerFooterViewType: UICollectionReusableView
    ///   - kindType: ReusableViewKindType
    func registerHeaderFooterView<T: UICollectionReusableView>(_ headerFooterViewType: T.Type, kindType: ReusableViewKindType)
        where T: Reusable {
            
            var kind: String
            switch kindType {
            case .sectionHeader:
                kind = UICollectionView.elementKindSectionHeader
            case .sectionFooter:
                kind = UICollectionView.elementKindSectionFooter
            }
            register(
                headerFooterViewType.self,
                forSupplementaryViewOfKind: kind,
                withReuseIdentifier: headerFooterViewType.reuseIdentifier
            )
    }
    
    /// 复用已经注册的UICollectionReusableView
    /// - Parameters:
    ///   - headerFooterViewType: UICollectionReusableView
    ///   - kindType: ReusableViewKindType
    ///   - indexPath: indexPath
    /// - Returns: UICollectionReusableView
    func dequeueReusableHeaderFooterView<T: UICollectionReusableView>
        (_ headerFooterViewType: T.Type = T.self, kindType: ReusableViewKindType, indexPath: IndexPath) -> T
        where T: Reusable {
            
            var kind: String
            switch kindType {
            case .sectionHeader:
                kind = UICollectionView.elementKindSectionHeader
            case .sectionFooter:
                kind = UICollectionView.elementKindSectionFooter
            }
            
            let view = dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: headerFooterViewType.reuseIdentifier,
                for: indexPath
            )
            guard let typedView = view as? T else {
                fatalError(
                    "Failed to dequeue a supplementary view with identifier \(headerFooterViewType.reuseIdentifier) "
                )
            }
            return typedView
    }
    
}

