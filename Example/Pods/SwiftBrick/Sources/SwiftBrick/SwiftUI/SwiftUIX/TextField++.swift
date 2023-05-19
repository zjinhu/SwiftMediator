//
// Copyright (c) Vatsal Manot
//

import Swift
import SwiftUI

@available(iOS 13.0, *)
extension TextField where Label == Text {
    public init(
        _ title: LocalizedStringKey,
        text: Binding<String>,
        isEditing: Binding<Bool>,
        onCommit: @escaping () -> Void = { }
    ) {
        self.init(
            title,
            text: text,
            onEditingChanged: { isEditing.wrappedValue = $0 },
            onCommit: onCommit
        )
    }
    
    public init(
        _ title: LocalizedStringKey,
        text: Binding<String?>,
        onEditingChanged: @escaping (Bool) -> Void = { _ in },
        onCommit: @escaping () -> Void = { }
    ) {
        self.init(
            title,
            text: text.withDefaultValue(""),
            onEditingChanged: onEditingChanged,
            onCommit: onCommit
        )
    }
    
    public init(
        _ title: LocalizedStringKey,
        text: Binding<String?>,
        isEditing: Binding<Bool>,
        onCommit: @escaping () -> Void = { }
    ) {
        self.init(
            title,
            text: text,
            onEditingChanged: { isEditing.wrappedValue = $0 },
            onCommit: onCommit
        )
    }
}
