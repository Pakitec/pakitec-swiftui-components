import SwiftUI

public struct PakitecListRow<Accessory: View>: View {
    private let title: String
    private let subtitle: String?
    private let systemImage: String?
    private let accessory: Accessory

    public init(_ title: String, subtitle: String? = nil, systemImage: String? = nil, @ViewBuilder accessory: () -> Accessory) {
        self.title = title; self.subtitle = subtitle; self.systemImage = systemImage; self.accessory = accessory()
    }

    public var body: some View {
        HStack(spacing: PakitecSpacing.medium) {
            if let systemImage { Image(systemName: systemImage).foregroundStyle(PakitecTheme.accent).frame(width: 24) }
            VStack(alignment: .leading, spacing: 3) {
                Text(title).font(.body.weight(.medium)).foregroundStyle(PakitecTheme.primaryText)
                if let subtitle { Text(subtitle).font(.caption).foregroundStyle(PakitecTheme.secondaryText) }
            }
            Spacer()
            accessory
        }
        .padding(.vertical, 10)
    }
}

public extension PakitecListRow where Accessory == EmptyView {
    init(_ title: String, subtitle: String? = nil, systemImage: String? = nil) {
        self.init(title, subtitle: subtitle, systemImage: systemImage) { EmptyView() }
    }
}
