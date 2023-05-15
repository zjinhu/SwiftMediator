//
//  TapBuzz.swift
//  SwiftBrick
//
//  Created by iOS on 2020/11/20.
//  Copyright © 2020 狄烨 . All rights reserved.
//

import Foundation
import UIKit
// MARK: ===================================工具类:震动反馈=========================================
public class TapBuzz{
    public static func light() {
        TapticEngine.impact.feedback(.light)
    }
    
    public static func medium() {
        TapticEngine.impact.feedback(.medium)
    }
    
    public static func heavy() {
        TapticEngine.impact.feedback(.heavy)
    }
    
    public static func selection() {
        TapticEngine.selection.feedback()
    }
    
    public static func success() {
        TapticEngine.notification.feedback(.success)
    }
    
    public static func warning() {
        TapticEngine.notification.feedback(.warning)
    }
    
    public static func error() {
        TapticEngine.notification.feedback(.error)
    }
}

public class TapticEngine {
    public static let impact: Impact = .init()
    public static let selection: Selection = .init()
    public static let notification: Notification = .init()
    
    /// Wrapper of `UIImpactFeedbackGenerator`
    public class Impact {
        /// Impact feedback styles
        ///
        /// - light: A impact feedback between small, light user interface elements.
        /// - medium: A impact feedback between moderately sized user interface elements.
        /// - heavy: A impact feedback between large, heavy user interface elements.
        public enum ImpactStyle {
            case light, medium, heavy
        }
        
        private var style: ImpactStyle = .light
        private var generator: Any? = Impact.makeGenerator(.light)
        
        private static func makeGenerator(_ style: ImpactStyle) -> Any? {
            let feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle
            switch style {
            case .light:
                feedbackStyle = .light
            case .medium:
                feedbackStyle = .medium
            case .heavy:
                feedbackStyle = .heavy
            }
            let generator: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: feedbackStyle)
            generator.prepare()
            return generator
        }
        
        private func updateGeneratorIfNeeded(_ style: ImpactStyle) {
            guard self.style != style else { return }
            generator = Impact.makeGenerator(style)
            self.style = style
        }
        
        public func feedback(_ style: ImpactStyle) {
            updateGeneratorIfNeeded(style)
            guard let generator = generator as? UIImpactFeedbackGenerator else { return }
            generator.impactOccurred()
            generator.prepare()
        }
        
        public func prepare(_ style: ImpactStyle) {
            updateGeneratorIfNeeded(style)
            guard let generator = generator as? UIImpactFeedbackGenerator else { return }
            generator.prepare()
        }
    }
    
    
    /// Wrapper of `UISelectionFeedbackGenerator`
    public class Selection {
        private var generator: Any? = {
            let generator: UISelectionFeedbackGenerator = UISelectionFeedbackGenerator()
            generator.prepare()
            return generator
        }()
        
        public func feedback() {
            guard let generator = generator as? UISelectionFeedbackGenerator else { return }
            generator.selectionChanged()
            generator.prepare()
        }
        
        public func prepare() {
            guard let generator = generator as? UISelectionFeedbackGenerator else { return }
            generator.prepare()
        }
    }
    
    
    /// Wrapper of `UINotificationFeedbackGenerator`
    public class Notification {
        /// Notification feedback types
        ///
        /// - success: A notification feedback, indicating that a task has completed successfully.
        /// - warning: A notification feedback, indicating that a task has produced a warning.
        /// - error: A notification feedback, indicating that a task has failed.
        public enum NotificationType {
            case success, warning, error
        }
        
        private var generator: Any? = {
            let generator: UINotificationFeedbackGenerator = UINotificationFeedbackGenerator()
            generator.prepare()
            return generator
        }()
        
        public func feedback(_ type: NotificationType) {
            guard let generator = generator as? UINotificationFeedbackGenerator else { return }
            let feedbackType: UINotificationFeedbackGenerator.FeedbackType
            switch type {
            case .success:
                feedbackType = .success
            case .warning:
                feedbackType = .warning
            case .error:
                feedbackType = .error
            }
            generator.notificationOccurred(feedbackType)
            generator.prepare()
        }
        
        public func prepare() {
            guard let generator = generator as? UINotificationFeedbackGenerator else { return }
            generator.prepare()
        }
    }
}
