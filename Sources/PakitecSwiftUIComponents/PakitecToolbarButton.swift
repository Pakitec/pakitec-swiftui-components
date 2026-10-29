import SwiftUI

public struct PakitecToolbarButton: View {
    private let title: String?
    private let systemImage: String
    private let inToolbar: Bool
    private let action: () -> Void

    /// - Parameter inToolbar: use `true` dentro de `ToolbarItem`. No OS 26 o sistema desenha o vidro,
    ///   entao o botao nao aplica superficie propria (evita vidro duplicado, D6).
    public init(_ title: String? = nil, systemImage: String, inToolbar: Bool = false, action: @escaping () -> Void) {
        self.title = title; self.systemImage = systemImage; self.inToolbar = inToolbar; self.action = action
    }

    public var body: some View {
        Button(action: action) {
            if let title { Label(title, systemImage: systemImage) } else { Image(systemName: systemImage) }
        }
        .font(.body.weight(.semibold))
        .tint(PakitecTheme.accent)
        .accessibilityLabel(title ?? systemImage)
        .modifier(ToolbarGlass(enabled: !inToolbar))
    }
}

/// Vidro `subtle` em capsula para o botao fora de toolbar.
private struct ToolbarGlass: ViewModifier {
    let enabled: Bool

    @ViewBuilder
    func body(content: Content) -> some View {
        if enabled {
            content
                .padding(.horizontal, PakitecSpacing.small)
                .padding(.vertical, 6)
                .pakitecGlassSurface(.subtle, in: Capsule(), size: .small)
        } else {
            content
        }
    }
}
