//
//  CGSizeEx.swift
//  SwiftBrick
//
//  Created by iOS on 2023/5/9.
//  Copyright © 2023 狄烨 . All rights reserved.
//

import Foundation
extension CGSize {
    public static var greatestFiniteSize: CGSize {
        .init(
            width: CGFloat.greatestFiniteMagnitude,
            height: CGFloat.greatestFiniteMagnitude
        )
    }
        
    public var minimumDimensionLength: CGFloat {
        min(width, height)
    }
    
    public var maximumDimensionLength: CGFloat {
        max(width, height)
    }
    
    var isAreaZero: Bool {
        minimumDimensionLength.isZero
    }
}
