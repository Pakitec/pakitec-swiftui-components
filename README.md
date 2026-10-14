# Pakitec SwiftUI Components

Biblioteca compartilhada de componentes e tokens visuais para os aplicativos nativos da Pakitec.

## Versionamento

Cada push na branch `master` dispara a workflow `Auto tag master`, que cria a próxima tag patch automaticamente (`v1.0.0`, `v1.0.1`, `v1.0.2`...). O primeiro push cria `v1.0.0`; os seguintes incrementam apenas o patch.

## Princípios

- Tema claro/escuro usando as cores semânticas de `PakitecTheme`.
- Componentes pequenos e composáveis, sem dependência de arquitetura de produto.
- Acessibilidade e tamanhos dinâmicos fornecidos pelos controles nativos do SwiftUI.

## Uso

Adicione este repositório como Swift Package e importe:

```swift
import PakitecSwiftUIComponents

struct ExampleView: View {
    @State private var name = ""

    var body: some View {
        ZStack {
            PakitecTheme.background.ignoresSafeArea()
            PakitecCard {
                VStack(spacing: 16) {
                    PakitecTextField("Nome", text: $name, prompt: "Digite seu nome")
                    PakitecButton("Continuar", systemImage: "arrow.right") { }
                }
            }.padding()
        }
    }
}
```

Os aplicativos podem substituir a identidade visual por cima dos componentes através dos tokens, sem duplicar layouts e estados de interação.

## Visualizar os componentes

Abra `Package.swift` no Xcode e selecione o arquivo `PakitecComponentsPreview.swift`. O Canvas exibirá os previews `Claro` e `Escuro`. Caso o Canvas esteja oculto, use **Editor > Canvas** e clique em **Resume**.
