import SwiftUI

private struct PakitecComponentsPreview: View {
    @State private var name = ""
    @State private var password = ""
    @State private var enabled = true
    @State private var progress = 0.65
    @State private var choice = "Ativo"
    @State private var tab = "home"

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

                PakitecSectionHeader("Status", subtitle: "Componentes de conteúdo e feedback")
                HStack {
                    PakitecBadge("Neutro")
                    PakitecBadge("Ativo", tone: .success)
                    PakitecBadge("Atenção", tone: .warning)
                    PakitecBadge("Erro", tone: .danger)
                }
                PakitecProgressView(value: progress)
                PakitecAlertCard(title: "Informação", message: "Este é um alerta visual reutilizável.")

                PakitecCard {
                    VStack(alignment: .leading, spacing: 14) {
                        PakitecSectionHeader("Formulário")
                        PakitecSecureField("Senha", text: $password, prompt: "Digite sua senha")
                        PakitecToggleRow("Notificações", subtitle: "Receber atualizações do aplicativo", isOn: $enabled)
                        PakitecPicker("Estado", selection: $choice, options: ["Ativo", "Pausado", "Arquivado"]) { $0 }
                        PakitecValidationMessage("Exemplo de validação", tone: .success)
                    }
                }

                PakitecSectionHeader("Lista")
                PakitecCard {
                    VStack(spacing: 0) {
                        PakitecListRow("Minha conta", subtitle: "Configurações e preferências", systemImage: "person") { Image(systemName: "chevron.right").foregroundStyle(PakitecTheme.secondaryText) }
                        Divider().overlay(PakitecTheme.divider)
                        PakitecListRow("Privacidade", subtitle: "Controle seus dados", systemImage: "lock") { PakitecBadge("Seguro", tone: .success) }
                    }
                }

                HStack {
                    PakitecLoadingView(message: "Carregando")
                    Spacer()
                }

                PakitecNavigationHeader("Detalhes", subtitle: "Cabeçalho de navegação") {
                    PakitecToolbarButton(systemImage: "chevron.left") { }
                } trailing: {
                    PakitecToolbarButton(systemImage: "ellipsis") { }
                }
                PakitecTabBar(items: [
                    PakitecTabItem(id: "home", title: "Início", systemImage: "house"),
                    PakitecTabItem(id: "settings", title: "Ajustes", systemImage: "gearshape")
                ], selection: $tab)

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
