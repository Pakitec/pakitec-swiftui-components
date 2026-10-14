import SwiftUI

public struct PakitecLoadingView: View {
    private let message: String?

    public init(message: String? = nil) { self.message = message }

    public var body: some View {
        VStack(spacing: 12) {
            ProgressView().tint(PakitecTheme.accent).controlSize(.regular)
            if let message { Text(message).font(.subheadline).foregroundStyle(PakitecTheme.secondaryText) }
        }
        .padding(PakitecSpacing.xLarge)
    }
}
