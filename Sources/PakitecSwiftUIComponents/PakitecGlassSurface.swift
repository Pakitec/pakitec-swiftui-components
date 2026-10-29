import SwiftUI

/// Intensidade do tint aplicado a uma superficie de vidro.
enum PakitecGlassIntensity: Equatable, CaseIterable {
    case subtle
    case regular
    case strong
}

/// Tamanho da superficie. Define o material de fallback usado antes do OS 26.
enum PakitecGlassSize: Equatable {
    /// Card, TabBar, NavigationHeader e campos: usa `.regularMaterial`.
    case large
    /// Badge, Button e ToolbarButton: usa `.thinMaterial`.
    case small
}

/// Modo de renderizacao de uma superficie Pakitec.
enum PakitecGlassSurfaceMode: Equatable {
    /// Fundo solido sem stroke ("Reduzir transparencia").
    case solid
    /// Fundo solido com stroke `divider` ("Aumentar contraste", D7).
    case solidWithStroke
    /// Liquid Glass (OS 26 ou superior).
    case glass
    /// Material do sistema (OS anterior ao 26).
    case material

    /// Decide o modo da superficie. A funcao e pura e testavel sem OS 26.
    ///
    /// Ordem de prioridade: Reduzir transparencia, Aumentar contraste, vidro, material.
    ///
    /// - Parameters:
    ///   - reduceTransparency: opcao de acessibilidade "Reduzir transparencia" ligada.
    ///   - increasedContrast: opcao de acessibilidade "Aumentar contraste" ligada.
    ///   - glassAvailable: o OS atual suporta Liquid Glass.
    /// - Returns: o modo que o modificador deve aplicar.
    static func resolve(
        reduceTransparency: Bool,
        increasedContrast: Bool,
        glassAvailable: Bool
    ) -> PakitecGlassSurfaceMode {
        if reduceTransparency { return .solid }
        if increasedContrast { return .solidWithStroke }
        return glassAvailable ? .glass : .material
    }
}

/// Forca ramos de renderizacao para previews e capturas visuais.
///
/// Cada campo `nil` mantem o valor real do ambiente. Uso interno: o preview define o valor
/// para exibir "Reduzir transparencia", "Aumentar contraste" ou o ramo Material no OS 26.
struct PakitecGlassOverrides: Equatable {
    var reduceTransparency: Bool?
    var increasedContrast: Bool?
    var forceMaterial: Bool = false
}

private struct PakitecGlassOverridesKey: EnvironmentKey {
    static let defaultValue = PakitecGlassOverrides()
}

extension EnvironmentValues {
    var pakitecGlassOverrides: PakitecGlassOverrides {
        get { self[PakitecGlassOverridesKey.self] }
        set { self[PakitecGlassOverridesKey.self] = newValue }
    }
}

/// Aplica a superficie de vidro Pakitec ao fundo da view.
///
/// O vidro cobre apenas o fundo, nunca o texto (FR-005). Com acessibilidade ligada,
/// a superficie vira solida usando `solidFill`.
struct PakitecGlassSurface<S: InsettableShape>: ViewModifier {
    let intensity: PakitecGlassIntensity
    let tint: Color
    let shape: S
    let size: PakitecGlassSize
    let solidFill: Color

    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.pakitecGlassOverrides) private var overrides

    private var mode: PakitecGlassSurfaceMode {
        var glassAvailable = false
        if #available(iOS 26, macOS 26, *) { glassAvailable = !overrides.forceMaterial }
        return .resolve(
            reduceTransparency: overrides.reduceTransparency ?? reduceTransparency,
            increasedContrast: overrides.increasedContrast ?? (colorSchemeContrast == .increased),
            glassAvailable: glassAvailable
        )
    }

    @ViewBuilder
    func body(content: Content) -> some View {
        let opacity = PakitecTheme.glassTintOpacity(intensity, colorScheme: colorScheme)
        switch mode {
        case .solid:
            content.background(solidFill, in: shape)
        case .solidWithStroke:
            content
                .background(solidFill, in: shape)
                .overlay(shape.strokeBorder(PakitecTheme.divider, lineWidth: 1))
        case .glass:
            glass(content, opacity: opacity)
        case .material:
            content
                .background(size == .large ? Material.regularMaterial : Material.thinMaterial, in: shape)
                .background(tint.opacity(opacity), in: shape)
        }
    }

    @ViewBuilder
    private func glass(_ content: Content, opacity: Double) -> some View {
        if #available(iOS 26, macOS 26, *) {
            content.glassEffect(.regular.tint(tint.opacity(opacity)), in: shape)
        } else {
            content.background(solidFill, in: shape)
        }
    }
}

extension View {
    /// Aplica a superficie de vidro Pakitec como fundo.
    ///
    /// - Parameters:
    ///   - intensity: intensidade do tint.
    ///   - tint: cor base do tint. Usa o accent por padrao.
    ///   - shape: forma que recorta a superficie.
    ///   - size: define o material de fallback antes do OS 26.
    ///   - solidFill: fundo usado com acessibilidade ligada.
    func pakitecGlassSurface<S: InsettableShape>(
        _ intensity: PakitecGlassIntensity = .regular,
        tint: Color = PakitecTheme.accent,
        in shape: S,
        size: PakitecGlassSize = .large,
        solidFill: Color = PakitecTheme.surface
    ) -> some View {
        modifier(PakitecGlassSurface(
            intensity: intensity, tint: tint, shape: shape, size: size, solidFill: solidFill
        ))
    }
}
