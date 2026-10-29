import SwiftUI
import XCTest
@testable import PakitecSwiftUIComponents

// Estes testes definem o contrato da superficie de vidro (SCRUM-1761, TASK-001).
// Eles falham na compilacao ate TASK-002 e TASK-003 criarem os simbolos
// `PakitecGlassSurfaceMode`, `PakitecGlassIntensity` e os tokens de `PakitecTheme`.

/// Cobre a funcao pura de decisao do modo da superficie (AC-002, AC-004, AC-006).
final class PakitecGlassSurfaceModeTests: XCTestCase {
    func testReduceTransparencyForcesSolidWhenGlassIsAvailable() {
        XCTAssertEqual(
            PakitecGlassSurfaceMode.resolve(reduceTransparency: true, increasedContrast: false, glassAvailable: true),
            .solid
        )
    }

    func testReduceTransparencyForcesSolidWhenGlassIsUnavailable() {
        XCTAssertEqual(
            PakitecGlassSurfaceMode.resolve(reduceTransparency: true, increasedContrast: false, glassAvailable: false),
            .solid
        )
    }

    func testReduceTransparencyWinsOverIncreasedContrastWithGlass() {
        XCTAssertEqual(
            PakitecGlassSurfaceMode.resolve(reduceTransparency: true, increasedContrast: true, glassAvailable: true),
            .solid
        )
    }

    func testReduceTransparencyWinsOverIncreasedContrastWithoutGlass() {
        XCTAssertEqual(
            PakitecGlassSurfaceMode.resolve(reduceTransparency: true, increasedContrast: true, glassAvailable: false),
            .solid
        )
    }

    func testIncreasedContrastUsesSolidWithStrokeWhenGlassIsAvailable() {
        XCTAssertEqual(
            PakitecGlassSurfaceMode.resolve(reduceTransparency: false, increasedContrast: true, glassAvailable: true),
            .solidWithStroke
        )
    }

    func testIncreasedContrastUsesSolidWithStrokeWhenGlassIsUnavailable() {
        XCTAssertEqual(
            PakitecGlassSurfaceMode.resolve(reduceTransparency: false, increasedContrast: true, glassAvailable: false),
            .solidWithStroke
        )
    }

    func testDefaultAccessibilityWithGlassAvailableUsesGlass() {
        XCTAssertEqual(
            PakitecGlassSurfaceMode.resolve(reduceTransparency: false, increasedContrast: false, glassAvailable: true),
            .glass
        )
    }

    func testDefaultAccessibilityWithoutGlassFallsBackToMaterial() {
        XCTAssertEqual(
            PakitecGlassSurfaceMode.resolve(reduceTransparency: false, increasedContrast: false, glassAvailable: false),
            .material
        )
    }
}

/// Cobre as faixas dos tokens de opacidade do tint (FR-006, FR-007, NFR-003).
final class PakitecGlassTokenTests: XCTestCase {
    private let schemes: [ColorScheme] = [.light, .dark]
    private let intensities: [PakitecGlassIntensity] = [.subtle, .regular, .strong]

    func testMinimumAndMaximumTokensMatchThePlan() {
        XCTAssertEqual(PakitecTheme.glassMinimumTintOpacity, 0.04, accuracy: 0.0001)
        XCTAssertEqual(PakitecTheme.glassMaximumTintOpacity, 0.30, accuracy: 0.0001)
    }

    func testEveryOpacityIsBetweenZeroAndOneExclusive() {
        for scheme in schemes {
            for intensity in intensities {
                let value = PakitecTheme.glassTintOpacity(intensity, colorScheme: scheme)
                XCTAssertGreaterThan(value, 0, "\(intensity) \(scheme) nao pode ser totalmente transparente")
                XCTAssertLessThan(value, 1, "\(intensity) \(scheme) nao pode ser cor chapada")
            }
        }
    }

    func testEveryOpacityRespectsFloorAndCeiling() {
        for scheme in schemes {
            for intensity in intensities {
                let value = PakitecTheme.glassTintOpacity(intensity, colorScheme: scheme)
                XCTAssertGreaterThanOrEqual(value, PakitecTheme.glassMinimumTintOpacity)
                XCTAssertLessThanOrEqual(value, PakitecTheme.glassMaximumTintOpacity)
            }
        }
    }

    func testIntensityIsOrderedForEachColorScheme() {
        for scheme in schemes {
            let subtle = PakitecTheme.glassTintOpacity(.subtle, colorScheme: scheme)
            let regular = PakitecTheme.glassTintOpacity(.regular, colorScheme: scheme)
            let strong = PakitecTheme.glassTintOpacity(.strong, colorScheme: scheme)
            XCTAssertLessThan(subtle, regular, "subtle deve ser menor que regular em \(scheme)")
            XCTAssertLessThan(regular, strong, "regular deve ser menor que strong em \(scheme)")
        }
    }

    func testProposedValuesMatchThePlanTable() {
        XCTAssertEqual(PakitecTheme.glassTintOpacity(.subtle, colorScheme: .light), 0.06, accuracy: 0.0001)
        XCTAssertEqual(PakitecTheme.glassTintOpacity(.subtle, colorScheme: .dark), 0.08, accuracy: 0.0001)
        XCTAssertEqual(PakitecTheme.glassTintOpacity(.regular, colorScheme: .light), 0.10, accuracy: 0.0001)
        XCTAssertEqual(PakitecTheme.glassTintOpacity(.regular, colorScheme: .dark), 0.14, accuracy: 0.0001)
        XCTAssertEqual(PakitecTheme.glassTintOpacity(.strong, colorScheme: .light), 0.14, accuracy: 0.0001)
        XCTAssertEqual(PakitecTheme.glassTintOpacity(.strong, colorScheme: .dark), 0.18, accuracy: 0.0001)
    }
}

/// Garante que a API publica dos componentes segue construivel apos a troca de superficie (FR-004, FR-009).
/// O pacote tem 7 componentes visuais e 3 campos de entrada; o plano os conta como 8 itens de FR-004.
@MainActor
final class PakitecGlassComponentConstructionTests: XCTestCase {
    func testCardCanBeConstructed() {
        _ = PakitecCard { Text("Conteudo") }
    }

    func testAlertCardCanBeConstructedForEveryTone() {
        let tones: [PakitecAlertCard.Tone] = [.info, .success, .warning, .danger]
        for tone in tones {
            _ = PakitecAlertCard(title: "Titulo", message: "Mensagem", tone: tone)
        }
    }

    func testTabBarCanBeConstructed() {
        var selection = 0
        _ = PakitecTabBar(
            items: [PakitecTabItem(id: 0, title: "Inicio", systemImage: "house")],
            selection: .init(get: { selection }, set: { selection = $0 })
        )
        XCTAssertEqual(selection, 0)
    }

    func testNavigationHeaderCanBeConstructed() {
        _ = PakitecNavigationHeader("Titulo", subtitle: "Subtitulo", leading: { EmptyView() }, trailing: { EmptyView() })
    }

    func testToolbarButtonCanBeConstructed() {
        _ = PakitecToolbarButton("Adicionar", systemImage: "plus") {}
        _ = PakitecToolbarButton(systemImage: "plus") {}
    }

    func testButtonCanBeConstructedForEveryStyle() {
        let styles: [PakitecButton.Style] = [.primary, .secondary, .ghost, .destructive]
        for style in styles {
            _ = PakitecButton("Acao", systemImage: "bolt", style: style) {}
        }
    }

    func testBadgeCanBeConstructedForEveryTone() {
        let tones: [PakitecBadge.Tone] = [.neutral, .accent, .success, .warning, .danger]
        for tone in tones {
            _ = PakitecBadge("Rotulo", tone: tone)
        }
    }

    func testTextFieldCanBeConstructed() {
        var value = ""
        _ = PakitecTextField("Nome", text: .init(get: { value }, set: { value = $0 }), prompt: "Digite")
        XCTAssertEqual(value, "")
    }

    func testSecureFieldCanBeConstructed() {
        var value = ""
        _ = PakitecSecureField("Senha", text: .init(get: { value }, set: { value = $0 }), prompt: "Digite")
        XCTAssertEqual(value, "")
    }

    func testTextEditorCanBeConstructed() {
        var value = ""
        _ = PakitecTextEditor("Notas", text: .init(get: { value }, set: { value = $0 }))
        XCTAssertEqual(value, "")
    }
}
