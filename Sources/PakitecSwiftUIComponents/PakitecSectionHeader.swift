import SwiftUI

public struct PakitecSectionHeader: View {
    private let title: String
    private let subtitle: String?
    private let actionTitle: String?
    private let action: (() -> Void)?

    public init(_ title: String, subtitle: String? = nil, actionTitle: String? = nil, action: (() -> Void)? = nil) {
        self.title = title; self.subtitle = subtitle; self.actionTitle = actionTitle; self.action = action
    }

    public var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.headline).foregroundStyle(PakitecTheme.primaryText)
                if let subtitle { Text(subtitle).font(.subheadline).foregroundStyle(PakitecTheme.secondaryText) }
            }
            Spacer()
            if let actionTitle, let action { Button(actionTitle, action: action).font(.subheadline.weight(.semibold)).tint(PakitecTheme.accent) }
        }
    }
}
