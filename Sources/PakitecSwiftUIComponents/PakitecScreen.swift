import SwiftUI

public struct PakitecScreen<Content: View>: View {
    private let title: String?
    private let showsScroll: Bool
    private let content: Content

    public init(title: String? = nil, showsScroll: Bool = true, @ViewBuilder content: () -> Content) {
        self.title = title; self.showsScroll = showsScroll; self.content = content()
    }

    public var body: some View {
        Group {
            if showsScroll {
                ScrollView { pageContent }
            } else {
                pageContent
            }
        }
        .background(PakitecTheme.background.ignoresSafeArea())
    }

    @ViewBuilder private var pageContent: some View {
        VStack(alignment: .leading, spacing: PakitecSpacing.xLarge) {
            if let title { Text(title).font(PakitecTypography.title).foregroundStyle(PakitecTheme.primaryText) }
            content
        }
        .padding(.horizontal, PakitecSpacing.large)
        .padding(.vertical, PakitecSpacing.xLarge)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
