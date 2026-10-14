import SwiftUI

public struct PakitecToggleRow: View {
    private let title: String
    private let subtitle: String?
    @Binding private var isOn: Bool

    public init(_ title: String, subtitle: String? = nil, isOn: Binding<Bool>) {
        self.title = title; self.subtitle = subtitle; self._isOn = isOn
    }

    public var body: some View {
        Toggle(isOn: $isOn) {
            VStack(alignment: .leading, spacing: 3) {
                Text(title).font(.body.weight(.medium)).foregroundStyle(PakitecTheme.primaryText)
                if let subtitle { Text(subtitle).font(.caption).foregroundStyle(PakitecTheme.secondaryText) }
            }
        }
        .tint(PakitecTheme.accent)
        .padding(.vertical, 6)
    }
}
