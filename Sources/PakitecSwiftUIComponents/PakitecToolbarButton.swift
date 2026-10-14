import SwiftUI

public struct PakitecToolbarButton: View {
    private let title: String?
    private let systemImage: String
    private let action: () -> Void

    public init(_ title: String? = nil, systemImage: String, action: @escaping () -> Void) {
        self.title = title; self.systemImage = systemImage; self.action = action
    }

    public var body: some View {
        Button(action: action) {
            if let title { Label(title, systemImage: systemImage) } else { Image(systemName: systemImage) }
        }
        .font(.body.weight(.semibold))
        .tint(PakitecTheme.accent)
        .accessibilityLabel(title ?? systemImage)
    }
}
