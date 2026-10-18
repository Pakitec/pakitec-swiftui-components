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
                .buttonStyle(PakitecFilledButtonStyle(color: tint))
        case .secondary:
            Button(action: action) { label() }
                .buttonStyle(PakitecOutlinedButtonStyle(color: tint))
        case .ghost:
            Button(action: action) { label() }
                .buttonStyle(PakitecGhostButtonStyle(color: tint))
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

private struct PakitecFilledButtonStyle: ButtonStyle {
    let color: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body.weight(.semibold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, minHeight: PakitecMetrics.buttonHeight)
            .padding(.horizontal, PakitecSpacing.large)
            .background(configuration.isPressed ? PakitecTheme.accentPressed : color, in: RoundedRectangle(cornerRadius: PakitecMetrics.buttonCornerRadius, style: .continuous))
            .opacity(configuration.isPressed ? 0.92 : 1)
            .contentShape(RoundedRectangle(cornerRadius: PakitecMetrics.buttonCornerRadius, style: .continuous))
    }
}

private struct PakitecOutlinedButtonStyle: ButtonStyle {
    let color: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body.weight(.semibold))
            .foregroundStyle(color)
            .frame(maxWidth: .infinity, minHeight: PakitecMetrics.buttonHeight)
            .padding(.horizontal, PakitecSpacing.large)
            .background(color.opacity(configuration.isPressed ? 0.16 : 0.08), in: RoundedRectangle(cornerRadius: PakitecMetrics.buttonCornerRadius, style: .continuous))
            .overlay { RoundedRectangle(cornerRadius: PakitecMetrics.buttonCornerRadius, style: .continuous).stroke(color.opacity(0.35), lineWidth: 1) }
    }
}

private struct PakitecGhostButtonStyle: ButtonStyle {
    let color: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body.weight(.semibold))
            .foregroundStyle(color)
            .frame(maxWidth: .infinity, minHeight: PakitecMetrics.compactButtonHeight)
            .padding(.horizontal, PakitecSpacing.medium)
            .background(color.opacity(configuration.isPressed ? 0.12 : 0), in: RoundedRectangle(cornerRadius: PakitecMetrics.buttonCornerRadius, style: .continuous))
    }
}
