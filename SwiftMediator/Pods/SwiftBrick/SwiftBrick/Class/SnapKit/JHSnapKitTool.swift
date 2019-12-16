//
//  JHSnapKitTool.swift
//  SwiftBrick
//
//  Created by iOS on 20/11/2019.
//  Copyright © 2019 狄烨 . All rights reserved.
//

import UIKit
import SnapKit

public struct AssociatedKeys {
    static var TapGestureKey: String = "TapGestureKey"
    static var JHButtonTouchUpKey: String = "JHButtonTouchUpKey"
}

public class JHSnapKitTool: NSObject {

   public typealias JHSnapMaker = (_ make: ConstraintMaker) -> Void
    
   public typealias JHTapGestureBlock = (_ block: Any) -> Void

   public typealias JHButtonBlock = (_ sender: UIButton) -> Void
}

 // MARK: - 命名空间方案,废弃,没减少一行代码
//public protocol ViewMaker {
//    associatedtype HandType
//    var hand: HandType { get }
//    static var hand: HandType.Type { get }
//}
//
//public extension ViewMaker {
//    var hand: Maker<Self> {
//        return Maker(value: self)
//    }
//
//    static var hand: Maker<Self>.Type {
//        return Maker.self
//    }
//}
//
//public struct Maker<T> {
//    public let makerValue: T
//    public init(value: T) {
//        self.makerValue = value
//    }
//}
