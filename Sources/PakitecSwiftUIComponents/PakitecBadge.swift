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
            .padding(.horizontal, PakitecSpacing.small)
            .padding(.vertical, 2)
            .modifier(BadgeSurface(tint: foreground, enabled: tone != .neutral))
    }

    private var foreground: Color {
        switch tone { case .neutral: PakitecTheme.primaryText; case .accent: PakitecTheme.accent; case .success: PakitecTheme.success; case .warning: PakitecTheme.warning; case .danger: PakitecTheme.danger }
    }
}

/// Vidro `subtle` em capsula. O badge neutro nao tem fundo.
/// O texto de 12 pt mantem a cor do tom e fica fora do vidro (FR-005).
private struct BadgeSurface: ViewModifier {
    let tint: Color
    let enabled: Bool

    @ViewBuilder
    func body(content: Content) -> some View {
        if enabled {
            content.pakitecGlassSurface(.subtle, tint: tint, in: Capsule(), size: .small)
        } else {
            content
        }
    }
}
