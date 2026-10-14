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
        Button(action: action) {
            Label(title, systemImage: systemImage ?? "")
                .font(.headline)
                .frame(maxWidth: .infinity, minHeight: 48)
        }
        .buttonStyle(.borderedProminent)
        .tint(tint)
        .foregroundStyle(foreground)
        .opacity(style == .ghost ? 0.9 : 1)
    }

    private var tint: Color {
        switch style { case .primary: PakitecTheme.accent; case .secondary: PakitecTheme.surfaceElevated; case .ghost: .clear; case .destructive: PakitecTheme.danger }
    }
    private var foreground: Color { style == .secondary || style == .ghost ? PakitecTheme.primaryText : .white }
}
