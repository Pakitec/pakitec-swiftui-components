import SwiftUI

public struct PakitecProgressView: View {
    private let value: Double
    private let tint: Color

    public init(value: Double, tint: Color = PakitecTheme.accent) {
        self.value = min(max(value, 0), 1); self.tint = tint
    }

    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule().fill(PakitecTheme.surfaceElevated)
                Capsule().fill(tint).frame(width: proxy.size.width * value)
            }
        }
        .frame(height: 8)
        .accessibilityValue(Text("\(Int(value * 100)) por cento"))
    }
}
