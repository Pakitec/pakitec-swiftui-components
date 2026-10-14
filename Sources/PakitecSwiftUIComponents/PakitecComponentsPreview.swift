import SwiftUI

private struct PakitecComponentsPreview: View {
    @State private var name = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Pakitec Components")
                        .font(.largeTitle.bold())
                    Text("Catálogo visual da biblioteca")
                        .foregroundStyle(PakitecTheme.secondaryText)
                }

                PakitecCard {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Card")
                            .font(.headline)
                        Text("Superfície reutilizável para conteúdos e seções.")
                            .foregroundStyle(PakitecTheme.secondaryText)
                        PakitecTextField("Nome", text: $name, prompt: "Digite seu nome")
                        PakitecButton("Continuar", systemImage: "arrow.right") { }
                        PakitecButton("Ação secundária", style: .secondary) { }
                        PakitecButton("Excluir", systemImage: "trash", style: .destructive) { }
                    }
                }

                PakitecCard {
                    PakitecEmptyState(
                        title: "Nenhum item encontrado",
                        message: "Quando houver conteúdo, ele aparecerá aqui.",
                        systemImage: "tray",
                        action: { }
                    )
                }
            }
            .padding()
        }
        .background(PakitecTheme.background)
        .preferredColorScheme(nil)
    }
}

// Preview único para manter o consumo de memória baixo no Xcode.
struct PakitecComponentsPreview_Previews: PreviewProvider {
    static var previews: some View {
        PakitecComponentsPreview()
    }
}
