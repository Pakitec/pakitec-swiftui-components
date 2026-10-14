import SwiftUI

public struct PakitecNavigationHeader<Leading: View, Trailing: View>: View {
    private let title: String
    private let subtitle: String?
    private let leading: Leading
    private let trailing: Trailing

    public init(_ title: String, subtitle: String? = nil, @ViewBuilder leading: () -> Leading, @ViewBuilder trailing: () -> Trailing) {
        self.title = title; self.subtitle = subtitle; self.leading = leading(); self.trailing = trailing()
    }

    public var body: some View {
        HStack(spacing: PakitecSpacing.medium) {
            leading
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.headline).foregroundStyle(PakitecTheme.primaryText)
                if let subtitle { Text(subtitle).font(.caption).foregroundStyle(PakitecTheme.secondaryText) }
            }
            Spacer()
            trailing
        }
        .frame(minHeight: 44)
    }
}

public extension PakitecNavigationHeader where Leading == EmptyView, Trailing == EmptyView {
    init(_ title: String, subtitle: String? = nil) {
        self.init(title, subtitle: subtitle) { EmptyView() } trailing: { EmptyView() }
    }
}
