import SwiftUI

public struct PakitecSecureField: View {
    private let title: String
    private let prompt: String
    @Binding private var text: String

    public init(_ title: String, text: Binding<String>, prompt: String = "") {
        self.title = title; self._text = text; self.prompt = prompt
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.subheadline.weight(.semibold)).foregroundStyle(PakitecTheme.primaryText)
            SecureField(prompt, text: $text)
                .textFieldStyle(.plain)
                .padding(.horizontal, 14).frame(minHeight: 48)
                .background(PakitecTheme.surfaceElevated, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(PakitecTheme.divider, lineWidth: 1))
        }
    }
}
