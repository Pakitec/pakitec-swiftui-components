import SwiftUI

public struct PakitecTextField: View {
    private let title: String
    private let prompt: String
    @Binding private var text: String

    public init(_ title: String, text: Binding<String>, prompt: String = "") {
        self.title = title; self._text = text; self.prompt = prompt
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).font(.subheadline).foregroundStyle(PakitecTheme.secondaryText)
            TextField(prompt, text: $text)
                .textFieldStyle(.roundedBorder)
        }
    }
}
