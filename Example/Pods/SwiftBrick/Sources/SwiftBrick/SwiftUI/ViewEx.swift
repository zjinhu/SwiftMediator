//
//  ViewEx.swift
//  SwiftBrick
//
//  Created by iOS on 2023/4/20.
//  Copyright © 2023 狄烨 . All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
public struct RoundedCorner: Shape {
    
    public var radius: CGFloat = .infinity
    public var corners: UIRectCorner = .allCorners
    
    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

@available(iOS 13.0, *)
public extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

@available(iOS 13.0, *)
public extension Spacer {
    @ViewBuilder static func width(_ value: CGFloat?) -> some View {
        switch value {
            case .some(let value): Spacer().frame(width: max(value, 0))
            case nil: Spacer()
        }
    }
    
    @ViewBuilder static func height(_ value: CGFloat?) -> some View {
        switch value {
            case .some(let value): Spacer().frame(height: max(value, 0))
            case nil: Spacer()
        }
    }
}

@available(iOS 13.0, *)
public extension View {
    func readHeight(onChange action: @escaping (CGFloat) -> ()) -> some View {
        background(heightReader)
            .onPreferenceChange(HeightPreferenceKey.self, perform: action)
    }
}

@available(iOS 13.0, *)
private extension View {
    var heightReader: some View {
        GeometryReader {
            Color.clear
                .preference(key: HeightPreferenceKey.self, value: $0.size.height)
        }
    }
}

fileprivate struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}
