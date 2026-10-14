import XCTest
@testable import PakitecSwiftUIComponents

final class PakitecSwiftUIComponentsTests: XCTestCase {
    func testThemeExposesCoreSemanticTokens() {
        XCTAssertNotNil(PakitecTheme.background)
        XCTAssertNotNil(PakitecTheme.surface)
        XCTAssertNotNil(PakitecTheme.accent)
    }
}
