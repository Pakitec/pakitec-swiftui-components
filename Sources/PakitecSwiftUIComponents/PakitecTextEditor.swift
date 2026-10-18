import SwiftUI

public struct PakitecTextEditor: View {
    private let title: String
    @Binding private var text: String
    private let minHeight: CGFloat

    public init(_ title: String, text: Binding<String>, minHeight: CGFloat = 120) {
        self.title = title
        self._text = text
        self.minHeight = minHeight
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: PakitecSpacing.xSmall) {
            Text(title)
                .font(PakitecTypography.caption)
                .foregroundStyle(PakitecTheme.secondaryText)
            TextEditor(text: $text)
                .frame(minHeight: minHeight)
                .scrollContentBackground(.hidden)
                .padding(PakitecSpacing.small)
                .background(PakitecTheme.surfaceElevated, in: RoundedRectangle(cornerRadius: PakitecMetrics.buttonCornerRadius, style: .continuous))
        }
    }
}
