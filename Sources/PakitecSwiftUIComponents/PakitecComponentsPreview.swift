import SwiftUI

/// Variante de acessibilidade ou de ramo de renderizacao exibida pelo preview.
enum PakitecPreviewVariant: String, CaseIterable {
    case standard = "Padrão"
    case reduceTransparency = "Reduzir transparência"
    case increasedContrast = "Aumentar contraste"
    case material = "Material (fallback)"

    var overrides: PakitecGlassOverrides {
        switch self {
        case .standard: PakitecGlassOverrides()
        case .reduceTransparency: PakitecGlassOverrides(reduceTransparency: true, increasedContrast: false)
        case .increasedContrast: PakitecGlassOverrides(reduceTransparency: false, increasedContrast: true)
        case .material: PakitecGlassOverrides(reduceTransparency: false, increasedContrast: false, forceMaterial: true)
        }
    }
}

/// Catalogo visual dos 8 componentes com vidro, sobre fundo colorido para o vidro aparecer.
///
/// - Parameters:
///   - colorScheme: tema forcado; `nil` segue o sistema.
///   - variant: forca "Reduzir transparencia", "Aumentar contraste" ou o ramo Material.
struct PakitecComponentsPreview: View {
    var colorScheme: ColorScheme?
    var variant: PakitecPreviewVariant = .standard

    @State private var name = ""
    @State private var password = ""
    @State private var enabled = true
    @State private var progress = 0.65
    @State private var choice = "Ativo"
    @State private var tab = "home"

    /// Gradiente colorido atras do conteudo: sem ele, o vidro nao tem o que refratar (R7).
    private var backdrop: some View {
        ZStack {
            PakitecTheme.background
            LinearGradient(
                colors: [.blue.opacity(0.55), .purple.opacity(0.45), .pink.opacity(0.45), .orange.opacity(0.4)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        .ignoresSafeArea()
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Pakitec Components")
                        .font(.largeTitle.bold())
                    Text("Catálogo visual da biblioteca · \(variant.rawValue)")
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
                        PakitecTextEditor("Observações", text: $name, minHeight: 90)
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

                PakitecActionSection("Ações", subtitle: "Ações agrupadas para telas de detalhe") {
                    PakitecActionRow("Abrir terminal", systemImage: "terminal") { }
                    Divider().overlay(PakitecTheme.divider)
                    PakitecActionRow("Editar tarefa", systemImage: "pencil") { }
                    Divider().overlay(PakitecTheme.divider)
                    PakitecActionRow("Excluir tarefa", systemImage: "trash", tone: .destructive) { }
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
        .background(backdrop)
        .environment(\.pakitecGlassOverrides, variant.overrides)
        .preferredColorScheme(colorScheme)
    }
}

// Preview único para manter o consumo de memória baixo no Xcode.
// Cada linha do menu de variantes vira uma tela: troque `colorScheme` e `variant` abaixo
// (ou use o seletor do Xcode) para capturar claro/escuro e cada ramo de renderização.
struct PakitecComponentsPreview_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(PakitecPreviewVariant.allCases, id: \.self) { variant in
            PakitecComponentsPreview(colorScheme: nil, variant: variant)
                .previewDisplayName(variant.rawValue)
        }
    }
}
