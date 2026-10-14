import SwiftUI

public struct PakitecEmptyState: View {
    private let title: String
    private let message: String
    private let systemImage: String
    private let action: (() -> Void)?

    public init(title: String, message: String, systemImage: String = "tray", action: (() -> Void)? = nil) {
        self.title = title; self.message = message; self.systemImage = systemImage; self.action = action
    }

    public var body: some View {
        VStack(spacing: 14) {
            Image(systemName: systemImage).font(.system(size: 34)).foregroundStyle(PakitecTheme.accent)
            Text(title).font(.title3.bold()).foregroundStyle(PakitecTheme.primaryText)
            Text(message).font(.subheadline).multilineTextAlignment(.center).foregroundStyle(PakitecTheme.secondaryText)
            if let action { PakitecButton("Tentar novamente", style: .secondary, action: action).fixedSize() }
        }.padding(24).frame(maxWidth: 360)
    }
}
