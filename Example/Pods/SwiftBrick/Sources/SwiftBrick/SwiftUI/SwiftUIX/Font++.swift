//
//  FontEx.swift
//  SwiftBrick
//
//  Created by iOS on 2023/5/9.
//  Copyright © 2023 狄烨 . All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
extension Text {
    @inlinable
    public func font(_ font: Font, weight: Font.Weight?) -> Text {
        if let weight {
            return self.font(font.weight(weight))
        } else {
            return self.font(font)
        }
    }
}

@available(iOS 13.0, *)
extension View {

    @inlinable
    @ViewBuilder
    public func font(_ font: Font, weight: Font.Weight?) -> some View {
        if let weight {
            self.font(font.weight(weight))
        } else {
            self.font(font)
        }
    }
}
