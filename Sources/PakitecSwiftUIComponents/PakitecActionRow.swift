import SwiftUI

public struct PakitecActionRow: View {
    public enum Tone { case normal, destructive }

    private let title: String
    private let subtitle: String?
    private let systemImage: String?
    private let tone: Tone
    private let action: () -> Void

    public init(
        _ title: String,
        subtitle: String? = nil,
        systemImage: String? = nil,
        tone: Tone = .normal,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.systemImage = systemImage
        self.tone = tone
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: PakitecSpacing.medium) {
                if let systemImage {
                    Image(systemName: systemImage)
                        .frame(width: 22)
                }
                VStack(alignment: .leading, spacing: PakitecSpacing.xSmall) {
                    Text(title)
                        .font(.body.weight(.medium))
                    if let subtitle {
                        Text(subtitle)
                            .font(PakitecTypography.caption)
                            .foregroundStyle(PakitecTheme.secondaryText)
                    }
                }
                Spacer(minLength: PakitecSpacing.small)
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(PakitecTheme.secondaryText)
            }
            .foregroundStyle(tone == .destructive ? PakitecTheme.danger : PakitecTheme.primaryText)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, PakitecSpacing.medium)
            .frame(minHeight: PakitecMetrics.compactButtonHeight)
            .contentShape(Rectangle())
        }
        .buttonStyle(PakitecActionRowButtonStyle(tone: tone))
        .accessibilityAddTraits(.isButton)
    }
}

private struct PakitecActionRowButtonStyle: ButtonStyle {
    let tone: PakitecActionRow.Tone

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                (tone == .destructive ? PakitecTheme.danger : PakitecTheme.accent)
                    .opacity(configuration.isPressed ? 0.12 : 0),
                in: RoundedRectangle(cornerRadius: PakitecMetrics.buttonCornerRadius, style: .continuous)
            )
    }
}
