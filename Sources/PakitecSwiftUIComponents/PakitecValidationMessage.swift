import SwiftUI

public struct PakitecValidationMessage: View {
    public enum Tone { case error, warning, success }
    private let message: String
    private let tone: Tone

    public init(_ message: String, tone: Tone = .error) { self.message = message; self.tone = tone }

    public var body: some View {
        Label(message, systemImage: icon)
            .font(.caption)
            .foregroundStyle(color)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var icon: String { switch tone { case .error: "exclamationmark.circle.fill"; case .warning: "exclamationmark.triangle.fill"; case .success: "checkmark.circle.fill" } }
    private var color: Color { switch tone { case .error: PakitecTheme.danger; case .warning: PakitecTheme.warning; case .success: PakitecTheme.success } }
}
