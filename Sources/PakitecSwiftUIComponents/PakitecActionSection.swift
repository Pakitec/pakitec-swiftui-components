import SwiftUI

public struct PakitecActionSection<Content: View>: View {
    private let title: String
    private let subtitle: String?
    private let content: Content

    public init(
        _ title: String,
        subtitle: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: PakitecSpacing.small) {
            VStack(alignment: .leading, spacing: PakitecSpacing.xSmall) {
                Text(title)
                    .font(PakitecTypography.headline)
                    .foregroundStyle(PakitecTheme.primaryText)
                if let subtitle {
                    Text(subtitle)
                        .font(PakitecTypography.caption)
                        .foregroundStyle(PakitecTheme.secondaryText)
                }
            }
            .padding(.horizontal, PakitecSpacing.xSmall)

            VStack(spacing: 0) {
                content
            }
            .padding(.vertical, PakitecSpacing.xSmall)
            .background(PakitecTheme.surface, in: RoundedRectangle(cornerRadius: PakitecMetrics.cardCornerRadius, style: .continuous))
        }
    }
}
