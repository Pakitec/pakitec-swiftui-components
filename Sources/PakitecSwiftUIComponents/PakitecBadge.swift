import SwiftUI

public struct PakitecBadge: View {
    public enum Tone { case neutral, accent, success, warning, danger }
    private let title: String
    private let tone: Tone

    public init(_ title: String, tone: Tone = .neutral) {
        self.title = title
        self.tone = tone
    }

    public var body: some View {
        Text(title)
            .font(.caption)
            .foregroundStyle(foreground)
            .padding(.horizontal, 2)
            .padding(.vertical, 2)
            .background(background, in: Capsule())
    }

    private var foreground: Color {
        switch tone { case .neutral: PakitecTheme.primaryText; case .accent: PakitecTheme.accent; case .success: PakitecTheme.success; case .warning: PakitecTheme.warning; case .danger: PakitecTheme.danger }
    }
    private var background: Color { tone == .neutral ? .clear : foreground.opacity(0.08) }
}
