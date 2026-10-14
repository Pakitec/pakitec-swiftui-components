import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

public enum PakitecTheme {
    public static let accent = Color(red: 0.31, green: 0.24, blue: 0.90)
    public static let accentSecondary = Color(red: 0.55, green: 0.35, blue: 0.96)

    public static let background = Color(light: Color(hex: 0xF7F7FA), dark: Color(hex: 0x17171A))
    public static let surface = Color(light: .white, dark: Color(hex: 0x232326))
    public static let surfaceElevated = Color(light: Color(hex: 0xF0F0F5), dark: Color(hex: 0x2C2C30))
    public static let primaryText = Color(light: Color(hex: 0x17171A), dark: Color(hex: 0xF7F7FA))
    public static let secondaryText = Color(light: Color(hex: 0x666672), dark: Color(hex: 0xA9A9B4))
    public static let divider = Color(light: Color(hex: 0xE5E5EA), dark: Color(hex: 0x39393F))
    public static let success = Color(hex: 0x25A46A)
    public static let warning = Color(hex: 0xD89116)
    public static let danger = Color(hex: 0xD94B4B)
}

private extension Color {
    init(light: Color, dark: Color) {
        #if canImport(UIKit)
        self.init(uiColor: .init { traits in
            traits.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
        #elseif canImport(AppKit)
        self.init(nsColor: .init(name: nil) { appearance in
            appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua ? NSColor(dark) : NSColor(light)
        } ?? NSColor(light))
        #else
        self = light
        #endif
    }

    init(hex: UInt, opacity: Double = 1) {
        self.init(.sRGB, red: Double((hex >> 16) & 0xff) / 255,
                  green: Double((hex >> 8) & 0xff) / 255,
                  blue: Double(hex & 0xff) / 255, opacity: opacity)
    }
}
