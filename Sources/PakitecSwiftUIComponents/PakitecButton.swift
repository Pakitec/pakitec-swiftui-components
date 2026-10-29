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

/// Botao secundario: vidro `regular` com tint do botao. O vidro cobre so o fundo (FR-005).
private struct PakitecOutlinedButtonStyle: ButtonStyle {
    let color: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body.weight(.semibold))
            .foregroundStyle(color)
            .frame(maxWidth: .infinity, minHeight: PakitecMetrics.buttonHeight)
            .padding(.horizontal, PakitecSpacing.large)
            .pakitecGlassSurface(
                configuration.isPressed ? .strong : .regular,
                tint: color,
                in: RoundedRectangle(cornerRadius: PakitecMetrics.buttonCornerRadius, style: .continuous),
                size: .small
            )
            .opacity(configuration.isPressed ? 0.92 : 1)
            .contentShape(RoundedRectangle(cornerRadius: PakitecMetrics.buttonCornerRadius, style: .continuous))
    }
}

/// Botao ghost: sem fundo em repouso. O vidro `subtle` aparece so durante o toque.
private struct PakitecGhostButtonStyle: ButtonStyle {
    let color: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body.weight(.semibold))
            .foregroundStyle(color)
            .frame(maxWidth: .infinity, minHeight: PakitecMetrics.compactButtonHeight)
            .padding(.horizontal, PakitecSpacing.medium)
            .modifier(GhostPressedGlass(isPressed: configuration.isPressed, color: color))
            .contentShape(RoundedRectangle(cornerRadius: PakitecMetrics.buttonCornerRadius, style: .continuous))
    }
}

private struct GhostPressedGlass: ViewModifier {
    let isPressed: Bool
    let color: Color

    @ViewBuilder
    func body(content: Content) -> some View {
        if isPressed {
            content.pakitecGlassSurface(
                .subtle,
                tint: color,
                in: RoundedRectangle(cornerRadius: PakitecMetrics.buttonCornerRadius, style: .continuous),
                size: .small
            )
        } else {
            content
        }
    }
}
