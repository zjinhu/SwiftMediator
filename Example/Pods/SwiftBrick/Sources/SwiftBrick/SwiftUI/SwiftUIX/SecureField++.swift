//
// Copyright (c) Vatsal Manot
//

import Swift
import SwiftUI

@available(iOS 13.0, *)
extension SecureField where Label == Text {
    public init(
        _ title: LocalizedStringKey,
        text: Binding<String?>,
        onCommit: @escaping () -> Void = { }
    ) {
        self.init(
            title,
            text: text.withDefaultValue(""),
            onCommit: onCommit
        )
    }
    
    public init<S: StringProtocol>(
        _ title: S,
        text: Binding<String?>,
        onCommit: @escaping () -> Void = { }
    ) {
        self.init(
            title,
            text: text.withDefaultValue(""),
            onCommit: onCommit
        )
    }
}
