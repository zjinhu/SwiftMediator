//
// Copyright (c) Vatsal Manot
//

import Swift
import SwiftUI
// MARK: - View.background
@available(iOS 13.0, *)
extension View {
    @_disfavoredOverload
    @inlinable
    public func background<Background: View>(
        alignment: Alignment = .center,
        @ViewBuilder _ background: () -> Background
    ) -> some View {
        self.background(background(), alignment: alignment)
    }

}

// MARK: - View.overlay
@available(iOS 13.0, *)
extension View {
    @_disfavoredOverload
    @inlinable
    public func overlay<Overlay: View>(
        alignment: Alignment = .center,
        @ViewBuilder _ overlay: () -> Overlay
    ) -> some View {
        self.overlay(overlay(), alignment: alignment)
    }
}

// MARK: View.offset
@available(iOS 13.0, *)
extension View {
    @inlinable
    public func inset(_ point: CGPoint) -> some View {
        offset(x: -point.x, y: -point.y)
    }
    
    @inlinable
    public func inset(_ length: CGFloat) -> some View {
        offset(x: -length, y: -length)
    }
    
    @inlinable
    public func offset(_ point: CGPoint) -> some View {
        offset(x: point.x, y: point.y)
    }
    
    @inlinable
    public func offset(_ length: CGFloat) -> some View {
        offset(x: length, y: length)
    }
}

// MARK: - View.padding
@available(iOS 13.0, *)
extension View {
    /// A view that pads this view inside the specified edge insets with a system-calculated amount of padding and a color.
    @_disfavoredOverload
    @inlinable
    public func padding(_ color: Color) -> some View {
        padding().background(color)
    }
}

@available(iOS 13.0, *)
extension View {
    public func onTapGesture(
        count: Int = 1,
        disabled: Bool,
        perform: @escaping () -> Void
    ) -> some View {
        gesture(
            TapGesture(count: count).onEnded(perform),
            including: disabled ? .subviews : .all
        )
    }

    public func onTapGestureOnBackground(
        count: Int = 1,
        perform action: @escaping () -> Void
    ) -> some View {
        background {
            Color.almostClear
                .contentShape(Rectangle())
                .onTapGesture(count: count, perform: action)
        }
    }
}

@available(iOS 13.0, *)
extension View {
    @inlinable
    public func relativeHeight(
        _ ratio: CGFloat,
        alignment: Alignment = .center
    ) -> some View {
        GeometryReader { geometry in
            self.frame(
                height: geometry.size.height * ratio,
                alignment: alignment
            )
        }
    }
    
    @inlinable
    public func relativeWidth(
        _ ratio: CGFloat,
        alignment: Alignment = .center
    ) -> some View {
        GeometryReader { geometry in
            self.frame(
                width: geometry.size.width * ratio,
                alignment: alignment
            )
        }
    }
    
    @inlinable
    public func relativeSize(
        width widthRatio: CGFloat?,
        height heightRatio: CGFloat?,
        alignment: Alignment = .center
    ) -> some View {
        GeometryReader { geometry in
            self.frame(
                width: widthRatio.map({ $0 * geometry.size.width }),
                height: heightRatio.map({ $0 * geometry.size.height }),
                alignment: alignment
            )
        }
    }
}

@available(iOS 13.0, *)
extension View {

    @inlinable
    public func fill(alignment: Alignment = .center) -> some View {
        relativeSize(width: 1.0, height: 1.0, alignment: alignment)
    }
}

@available(iOS 13.0, *)
extension View {

    @inlinable
    public func fit() -> some View {
        GeometryReader { geometry in
            self.frame(
                width: geometry.size.minimumDimensionLength,
                height: geometry.size.minimumDimensionLength
            )
        }
    }
}

@available(iOS 13.0, *)
extension View {
    @inlinable
    public func width(_ width: CGFloat?) -> some View {
        frame(width: width)
    }
    
    @inlinable
    public func height(_ height: CGFloat?) -> some View {
        frame(height: height)
    }

    @inlinable
    public func frame(_ size: CGSize?, alignment: Alignment = .center) -> some View {
        frame(width: size?.width, height: size?.height, alignment: alignment)
    }

    @inlinable
    public func frame(min size: CGSize?, alignment: Alignment = .center) -> some View {
        frame(minWidth: size?.width, minHeight: size?.height, alignment: alignment)
    }

    @inlinable
    public func frame(max size: CGSize?, alignment: Alignment = .center) -> some View {
        frame(maxWidth: size?.width, maxHeight: size?.height, alignment: alignment)
    }

    @inlinable
    public func frame(
        min minSize: CGSize?,
        max maxSize: CGSize?,
        alignment: Alignment = .center
    ) -> some View {
        frame(
            minWidth: minSize?.width,
            maxWidth: maxSize?.width,
            minHeight: minSize?.height,
            maxHeight: maxSize?.height,
            alignment: alignment
        )
    }
    
    @_disfavoredOverload
    public func frame(
        width: ClosedRange<CGFloat>? = nil,
        idealWidth: CGFloat? = nil,
        height: ClosedRange<CGFloat>? = nil,
        idealHeight: CGFloat? = nil
    ) -> some View {
        frame(
            minWidth: width?.lowerBound,
            idealWidth: idealWidth,
            maxWidth: width?.upperBound,
            minHeight: height?.lowerBound,
            idealHeight: idealHeight,
            maxHeight: height?.upperBound
        )
    }
}

@available(iOS 13.0, *)
extension View {
    @inlinable
    public func minWidth(_ width: CGFloat?) -> some View {
        frame(minWidth: width)
    }
    
    @inlinable
    public func maxWidth(_ width: CGFloat?) -> some View {
        frame(maxWidth: width)
    }
    
    @inlinable
    public func minHeight(_ height: CGFloat?) -> some View {
        frame(minHeight: height)
    }
    
    @inlinable
    public func maxHeight(_ height: CGFloat?) -> some View {
        frame(maxHeight: height)
    }
    
    @inlinable
    public func frame(min dimensionLength: CGFloat, axis: Axis) -> some View {
        switch axis {
            case .horizontal:
                return frame(minWidth: dimensionLength)
            case .vertical:
                return frame(minWidth: dimensionLength)
        }
    }
}

@available(iOS 13.0, *)
extension View {

    @inlinable
    public func idealFrame(width: CGFloat?, height: CGFloat?) -> some View {
        frame(idealWidth: width, idealHeight: height)
    }

    @inlinable
    public func idealMinFrame(
        width: CGFloat?,
        maxWidth: CGFloat? = nil,
        height: CGFloat?,
        maxHeight: CGFloat? = nil
    ) -> some View {
        frame(
            minWidth: width,
            idealWidth: width,
            maxWidth: maxWidth,
            minHeight: height,
            idealHeight: height,
            maxHeight: maxHeight
        )
    }
}

@available(iOS 13.0, *)
extension View {
    @inlinable
    public func squareFrame(sideLength: CGFloat?, alignment: Alignment = .center) -> some View {
        frame(width: sideLength, height: sideLength, alignment: alignment)
    }
    
    @inlinable
    public func squareFrame() -> some View {
        GeometryReader { geometry in
            self.frame(width: geometry.size.minimumDimensionLength, height: geometry.size.minimumDimensionLength)
        }
    }
}

@available(iOS 13.0, *)
extension View {
    @inlinable
    public func frameZeroClipped(_ clipped: Bool = true) -> some View {
        frame(clipped ? .zero : nil)
            .clipped()
    }
}

@available(iOS 13.0, *)
extension EnvironmentValues {
    private struct TintColor: EnvironmentKey {
        static let defaultValue: Color? = nil
    }
    
    public var tintColor: Color? {
        get {
            self[TintColor.self]
        } set {
            self[TintColor.self] = newValue
        }
    }
}

@available(iOS 13.0, *)
extension View {
    /// Sets the tint color of the elements displayed by this view.
    @ViewBuilder
    public func tintColor(_ color: Color?) -> some View {
        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
            self.tint(color).environment(\.tintColor, color)
        } else {
            self.environment(\.tintColor, color)
        }
    }
}
