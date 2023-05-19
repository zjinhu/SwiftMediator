//
//  ShareActivity.swift
//  SwiftBrick
//
//  Created by 狄烨 on 2023/4/20.
//  Copyright © 2023 狄烨 . All rights reserved.
//

import Foundation
import SwiftUI

@available(iOS 14.0, *)
public struct HapticButton<Content: View> : View{
    
    @AppStorage("isOpenHaptic") var isOpenHaptic: Bool = true
    
    var haptic:  UIImpactFeedbackGenerator.FeedbackStyle = .medium
    let content: Content
    var action: () -> () = {}
    
    public init(action: @escaping () -> Void, @ViewBuilder label: @escaping () -> Content) {
            self.content = label()
            self.action = action
    }
    
    public init(action: @escaping () -> Void,
                @ViewBuilder content: @escaping () -> Content,
                hapticIntensity: UIImpactFeedbackGenerator.FeedbackStyle) {
        self.content = content()
        self.action = action
        self.haptic = hapticIntensity
    }
    
    public var body: some View {
        Button {
            if isOpenHaptic {
                hapticFeedback()
            }
            action()
        } label: {
            content
        }
 
    }
}
 
@available(iOS 14.0, *)
public extension View {
 
    func haptics<V: Equatable>(onChangeOf value: V,
                               type: UINotificationFeedbackGenerator.FeedbackType,
                               isOpen: Bool = true) -> some View {
        onChange(of: value) { _ in
            if isOpen{
                let generator = UINotificationFeedbackGenerator()
                generator.prepare()
                generator.notificationOccurred(type)
            }
        }
    }
 
    func haptics<V: Equatable>(when property: V,
                               equalsTo value: V,
                               type: UINotificationFeedbackGenerator.FeedbackType,
                               isOpen: Bool = true) -> some View {
        onChange(of: property) { newValue in
            if newValue == value, isOpen{
                let generator = UINotificationFeedbackGenerator()
                generator.prepare()
                generator.notificationOccurred(type)
            }
        }
    }
 
    func haptics<V: Equatable>(onChangeOf value: V,
                               type: UIImpactFeedbackGenerator.FeedbackStyle,
                               isOpen: Bool = true) -> some View {
        onChange(of: value) { _ in
            if isOpen{
                let generator = UIImpactFeedbackGenerator(style: type)
                generator.prepare()
                generator.impactOccurred()
            }
        }
    }
 
    func haptics<V: Equatable>(when property: V,
                               equalsTo value: V,
                               type: UIImpactFeedbackGenerator.FeedbackStyle,
                               isOpen: Bool = true) -> some View {
        onChange(of: property) { newValue in
            if newValue == value, isOpen{
                let generator = UIImpactFeedbackGenerator(style: type)
                generator.prepare()
                generator.impactOccurred()
            }
        }
    }
 
    func haptics<V: Equatable>(onChangeOf value: V,
                               isOpen: Bool = true) -> some View {
        onChange(of: value) { _ in
            if isOpen{
                let generator = UISelectionFeedbackGenerator()
                generator.prepare()
                generator.selectionChanged()
            }
        }
    }
 
    func triggersHapticFeedbackWhenAppear() -> some View {
        onAppear {
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
    }
 
    /// You can also use ``.haptics(onChangeOf:)`` on your `View`.
    func hapticFeedback() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
 
    /// You can also use ``.haptics(onChangeOf:type:)`` on your `View`.
    func hapticFeedback(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
 
    /// You can also use ``.haptics(onChangeOf:type:)`` on your `View`.
    func hapticFeedback(type: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: type)
        generator.prepare()
        generator.impactOccurred()
    }
}

