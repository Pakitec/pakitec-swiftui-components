import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

public enum PakitecTheme {
    /// Pakitec's semantic accent. Apps can still override the view tint locally.
    public static let accent = Color(light: Color(hex: 0x4F46E5), dark: Color(hex: 0x6366F1))
    public static let accentPressed = Color(light: Color(hex: 0x4338CA), dark: Color(hex: 0x818CF8))
    public static let accentSecondary = Color(light: Color(hex: 0x7C3AED), dark: Color(hex: 0xA78BFA))

    public static let background = Color(light: Color(hex: 0xF2F2F7), dark: Color(hex: 0x1C1C1E))
    public static let surface = Color(light: .white, dark: Color(hex: 0x2C2C2E))
    public static let surfaceElevated = Color(light: Color(hex: 0xF7F7F8), dark: Color(hex: 0x3A3A3C))
    public static let primaryText = Color.primary
    public static let secondaryText = Color.secondary
    public static let divider = Color(light: Color(hex: 0xD1D1D6), dark: Color(hex: 0x48484A))
    public static let success = Color.green
    public static let warning = Color.orange
    public static let danger = Color.red
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
