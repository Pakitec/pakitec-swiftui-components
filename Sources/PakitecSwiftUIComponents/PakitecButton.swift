import SwiftUI

public struct PakitecButton: View {
    public enum Style { case primary, secondary, ghost, destructive }
    private let title: String
    private let systemImage: String?
    private let style: Style
    private let action: () -> Void

    public init(_ title: String, systemImage: String? = nil, style: Style = .primary, action: @escaping () -> Void) {
        self.title = title; self.systemImage = systemImage; self.style = style; self.action = action
    }

    public var body: some View {
        switch style {
        case .primary, .destructive:
            Button(action: action) { label() }
                .buttonStyle(.borderedProminent)
                .tint(tint)
        case .secondary:
            Button(action: action) { label() }
                .buttonStyle(.bordered)
                .tint(tint)
        case .ghost:
            Button(action: action) { label() }
                .buttonStyle(.plain)
                .tint(tint)
        }
    }

    @ViewBuilder
    private func label() -> some View {
        if let systemImage {
            Label(title, systemImage: systemImage)
        } else {
            Text(title)
        }
    }

    private var tint: Color {
        switch style { case .primary: PakitecTheme.accent; case .secondary, .ghost: PakitecTheme.accent; case .destructive: PakitecTheme.danger }
    }
}
