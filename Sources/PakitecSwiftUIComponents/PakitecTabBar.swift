import SwiftUI

public struct PakitecTabItem<ID: Hashable>: Identifiable {
    public let id: ID
    public let title: String
    public let systemImage: String

    public init(id: ID, title: String, systemImage: String) {
        self.id = id; self.title = title; self.systemImage = systemImage
    }
}

public struct PakitecTabBar<ID: Hashable>: View {
    private let items: [PakitecTabItem<ID>]
    @Binding private var selection: ID

    public init(items: [PakitecTabItem<ID>], selection: Binding<ID>) {
        self.items = items; self._selection = selection
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(items) { item in
                Button { selection = item.id } label: {
                    VStack(spacing: 5) {
                        Image(systemName: item.systemImage).font(.body.weight(.semibold))
                        Text(item.title).font(.caption2.weight(.medium))
                    }
                    .foregroundStyle(selection == item.id ? PakitecTheme.accent : PakitecTheme.secondaryText)
                    .frame(maxWidth: .infinity, minHeight: 52)
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(selection == item.id ? .isSelected : [])
            }
        }
        .padding(.horizontal, 8)
        .background(PakitecTheme.surface)
        .overlay(alignment: .top) { Rectangle().fill(PakitecTheme.divider).frame(height: 1) }
    }
}
