import XCTest
@testable import PakitecSwiftUIComponents

final class PakitecSwiftUIComponentsTests: XCTestCase {
    func testThemeExposesCoreSemanticTokens() {
        XCTAssertNotNil(PakitecTheme.background)
        XCTAssertNotNil(PakitecTheme.surface)
        XCTAssertNotNil(PakitecTheme.accent)
    }

    func testThemeExposesInteractionMetrics() {
        XCTAssertEqual(PakitecMetrics.buttonHeight, 48)
        XCTAssertEqual(PakitecMetrics.compactButtonHeight, 40)
        XCTAssertEqual(PakitecMetrics.buttonCornerRadius, 14)
    }
}
