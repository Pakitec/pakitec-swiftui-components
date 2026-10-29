import SwiftUI

public struct PakitecNavigationHeader<Leading: View, Trailing: View>: View {
    private let title: String
    private let subtitle: String?
    private let leading: Leading
    private let trailing: Trailing
    private let showsSurface: Bool

    /// - Parameter showsSurface: quando verdadeiro, desenha a superficie de vidro `subtle` atras do cabecalho.
    ///   O padding nao muda; o padrao e falso para manter o layout atual (R8).
    public init(_ title: String, subtitle: String? = nil, showsSurface: Bool = false, @ViewBuilder leading: () -> Leading, @ViewBuilder trailing: () -> Trailing) {
        self.title = title; self.subtitle = subtitle; self.showsSurface = showsSurface
        self.leading = leading(); self.trailing = trailing()
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
        .modifier(OptionalGlass(enabled: showsSurface))
    }
}

public extension PakitecNavigationHeader where Leading == EmptyView, Trailing == EmptyView {
    init(_ title: String, subtitle: String? = nil, showsSurface: Bool = false) {
        self.init(title, subtitle: subtitle, showsSurface: showsSurface) { EmptyView() } trailing: { EmptyView() }
    }
}

/// Aplica o vidro `subtle` somente quando `enabled` e verdadeiro.
private struct OptionalGlass: ViewModifier {
    let enabled: Bool

    @ViewBuilder
    func body(content: Content) -> some View {
        if enabled {
            content.pakitecGlassSurface(.subtle, in: Rectangle())
        } else {
            content
        }
    }
}
