import SwiftUI

public struct PakitecAlertCard: View {
    public enum Tone { case info, success, warning, danger }
    private let title: String
    private let message: String
    private let tone: Tone

    public init(title: String, message: String, tone: Tone = .info) {
        self.title = title; self.message = message; self.tone = tone
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon).foregroundStyle(color)
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.subheadline.weight(.semibold)).foregroundStyle(PakitecTheme.primaryText)
                Text(message).font(.caption).foregroundStyle(PakitecTheme.secondaryText)
            }
            Spacer(minLength: 0)
        }
        .padding(14)
        .background(color.opacity(0.10), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(color.opacity(0.25), lineWidth: 1))
    }

    private var icon: String { switch tone { case .info: "info.circle.fill"; case .success: "checkmark.circle.fill"; case .warning: "exclamationmark.triangle.fill"; case .danger: "xmark.octagon.fill" } }
    private var color: Color { switch tone { case .info: PakitecTheme.accent; case .success: PakitecTheme.success; case .warning: PakitecTheme.warning; case .danger: PakitecTheme.danger } }
}
