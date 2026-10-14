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
            .font(.caption.weight(.semibold))
            .foregroundStyle(foreground)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(background, in: Capsule())
    }

    private var foreground: Color {
        switch tone { case .neutral: PakitecTheme.primaryText; case .accent: PakitecTheme.accent; case .success: PakitecTheme.success; case .warning: PakitecTheme.warning; case .danger: PakitecTheme.danger }
    }
    private var background: Color { foreground.opacity(0.14) }
}
