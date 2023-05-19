//
// Copyright (c) Vatsal Manot
//

import Swift
import SwiftUI

@available(iOS 13.0, *)
extension Font.TextStyle {

    public var defaultMetrics: (weight: Font.Weight, size: CGFloat, leading: CGFloat) {
        switch self {
            case .largeTitle:
                return (.regular, 34, 41)
            case .title:
                return (.regular, 28, 34)
            case .headline:
                return (.semibold, 17, 22)
            case .subheadline:
                return (.regular, 15, 20)
            case .body:
                return (.regular, 17, 22)
            case .callout:
                return (.regular, 16, 21)
            case .footnote:
                return (.regular, 13, 18)
            case .caption:
                return (.regular, 12, 16)
                
            default: do {
                if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
                    switch self {
                        case .title2:
                            return (.regular, 22, 28)
                        case .title3:
                            return (.regular, 20, 25)
                        case .caption2:
                            return (.regular, 11, 13)
                        default: do {
                            assertionFailure()
                            
                            return Self.body.defaultMetrics
                        }
                    }
                } else {
                    assertionFailure()
                    
                    return Self.body.defaultMetrics
                }
            }
        }
    }
}
