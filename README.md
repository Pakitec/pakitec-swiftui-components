# Pakitec SwiftUI Components

Biblioteca compartilhada de componentes e tokens visuais para os aplicativos nativos da Pakitec.

## Versionamento

Cada push na branch `master` dispara a workflow `Auto tag master`, que cria a próxima tag patch automaticamente (`v1.0.0`, `v1.0.1`, `v1.0.2`...). O primeiro push cria `v1.0.0`; os seguintes incrementam apenas o patch.

Versão atual: `1.1.0`. Esta versão adiciona o Liquid Glass (vidro líquido) aos componentes. Os alvos mínimos não mudam: iOS 17 e macOS 14.

## Direção visual

A biblioteca segue os componentes nativos do SwiftUI como padrão: usa a cor de destaque do aplicativo, tipografia semântica, materiais, controles nativos e agrupamentos mais leves. `PakitecAlertCard` usa vidro com o tom do alerta e mantém a borda colorida do tom.

## Liquid Glass

A partir da versão `1.1.0`, Card, AlertCard, TabBar, NavigationHeader, ToolbarButton, Button, Badge e os campos de entrada usam fundo em Liquid Glass. O vidro cobre só a superfície, nunca o texto. O tema nunca fica totalmente transparente.

### Compatibilidade e fallback

- iOS 26 e macOS 26 ou superior: a superfície usa o efeito nativo `glassEffect`.
- Sistemas anteriores ao 26: a superfície usa Material (`.regularMaterial` ou `.thinMaterial`). O pacote não chama `glassEffect` nesses sistemas.
- Alvos mínimos de execução: iOS 17 e macOS 14.
- Para compilar o pacote, use Xcode 26 ou superior. O SDK anterior não tem a API `glassEffect`.

### Acessibilidade

- "Reduzir transparência" ligado: a superfície usa fundo sólido, sem vidro.
- "Aumentar contraste" ligado: a superfície usa fundo sólido com borda `divider`.
- "Reduzir transparência" tem prioridade sobre "Aumentar contraste".

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
