import SwiftUI

public struct PakitecPicker<SelectionValue: Hashable, Content: View>: View {
    private let title: String
    private let options: [SelectionValue]
    @Binding private var selection: SelectionValue
    private let label: (SelectionValue) -> Content

    public init(_ title: String, selection: Binding<SelectionValue>, options: [SelectionValue], @ViewBuilder label: @escaping (SelectionValue) -> Content) {
        self.title = title; self._selection = selection; self.options = options; self.label = label
    }

    public var body: some View {
        Picker(title, selection: $selection) {
            ForEach(options, id: \.self) { option in label(option).tag(option) }
        }
        .tint(PakitecTheme.accent)
    }
}

public extension PakitecPicker where Content == Text {
    init(_ title: String, selection: Binding<SelectionValue>, options: [SelectionValue], label: @escaping (SelectionValue) -> String) {
        self.init(title, selection: selection, options: options) { Text(label($0)) }
    }
}
