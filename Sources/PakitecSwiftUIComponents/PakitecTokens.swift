import SwiftUI

public enum PakitecSpacing {
    public static let xSmall: CGFloat = 4
    public static let small: CGFloat = 8
    public static let medium: CGFloat = 12
    public static let large: CGFloat = 16
    public static let xLarge: CGFloat = 24
    public static let xxLarge: CGFloat = 32
}

public enum PakitecMetrics {
    public static let buttonHeight: CGFloat = 48
    public static let compactButtonHeight: CGFloat = 40
    public static let buttonCornerRadius: CGFloat = 14
    public static let cardCornerRadius: CGFloat = 16
}

public enum PakitecTypography {
    public static let title = Font.largeTitle.bold()
    public static let headline = Font.headline
    public static let body = Font.body
    public static let caption = Font.caption
}
