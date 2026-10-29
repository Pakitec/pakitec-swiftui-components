# Pesquisa tecnica SCRUM-1761

<!-- sdd:section specs.research-template:start -->
Pesquisa somente leitura. Nenhum codigo foi alterado. Ambiente: Xcode 27.1, Swift 6.4, macOS 26, runtimes de simulador iOS 26.1 e 26.5 instalados.

## Arquivos e simbolos relevantes

### Repositorio-alvo 1: `pakitec-swiftui-components` (este workspace, branch `feature/liquid-glass`)

Base: `feature/liquid-glass` esta no mesmo commit de `master` (`cf8443f`). Nao ha diferenca a mesclar alem do trabalho novo. Tags existentes: `v1.0.0` a `v1.0.5`. Nao existe `CHANGELOG`; a versao so aparece como tag (README, secao "Versionamento"). O `Package.swift` nao declara versao.

`Package.swift`: `swift-tools-version: 6.0`, `platforms: [.iOS(.v17), .macOS(.v14)]`, um alvo (`PakitecSwiftUIComponents`) e um alvo de teste. Nao mudar.

Arquivos em `Sources/PakitecSwiftUIComponents/` e o estado atual das superficies:

| Arquivo | Simbolo | Superficie atual | Mudanca provavel |
| --- | --- | --- | --- |
| `PakitecTheme.swift` | `enum PakitecTheme` | Tokens estaticos `Color(light:dark:)`: `background`, `surface`, `surfaceElevated`, `divider`, `accent*`. Extensao privada `Color.init(light:dark:)` e `init(hex:)`. | Adicionar tokens de vidro (intensidade, opacidade do tint, opacidade minima, fundo solido de acessibilidade). |
| `PakitecTokens.swift` | `PakitecSpacing`, `PakitecMetrics`, `PakitecTypography` | Sem tokens de vidro. | Local alternativo para um `enum PakitecGlass` de metricas (raio, opacidades). |
| `PakitecCard.swift` | `PakitecCard` | `.background(.regularMaterial, in: RoundedRectangle(12))`. Ja usa Material, nao `surface`. | Trocar por modificador de vidro. |
| `PakitecAlertCard.swift` | `PakitecAlertCard` | `color.opacity(0.10)` + overlay `stroke(0.25)`, raio 12. | Vidro com tint do tom. |
| `PakitecTabBar.swift` | `PakitecTabBar` | `.background(PakitecTheme.surface)` opaco + divisor de 1 pt no topo. | Vidro na barra inteira. |
| `PakitecNavigationHeader.swift` | `PakitecNavigationHeader` | Sem fundo (HStack com `minHeight: 44`). | Adicionar superficie de vidro (hoje nao ha fundo). |
| `PakitecToolbarButton.swift` | `PakitecToolbarButton` | `Button` nativo com `.tint`. Usado em `ToolbarItem` no Joe. | Ver risco R3: vidro proprio dentro de toolbar duplica o vidro nativo. |
| `PakitecButton.swift` | `PakitecButton` e 3 `ButtonStyle` privados (`PakitecFilledButtonStyle`, `PakitecOutlinedButtonStyle`, `PakitecGhostButtonStyle`) | Preenchido (`accent`), contorno (`color.opacity(0.08)` + stroke) e ghost. | O vidro entra nos estilos `secondary` e `ghost`. O `primary` e `destructive` mantem a cor solida de acento, por causa do texto branco. |
| `PakitecBadge.swift` | `PakitecBadge` | `foreground.opacity(0.08)` em `Capsule`; neutro e `.clear`. | Capsula de vidro leve. Texto de 12 pt sobre vidro e o caso mais sensivel. |
| `PakitecTextField.swift`, `PakitecSecureField.swift` | idem | `surfaceElevated` + stroke `divider`, raio 12, altura minima 48. | Vidro no fundo do campo. |
| `PakitecTextEditor.swift` | idem | `surfaceElevated`, raio `buttonCornerRadius` (14), `scrollContentBackground(.hidden)`. | Campo de entrada: incluir (a issue diz "campos de entrada"). |
| `PakitecScreen.swift` | `PakitecScreen` | `PakitecTheme.background` opaco. | Nao muda. Fundo opaco atras do vidro limita o efeito (ver R7). |
| `PakitecComponentsPreview.swift` | `PreviewProvider` unico (privado) | Catalogo em `ScrollView` com `background(PakitecTheme.background)`; ja cobre todos os componentes alvo. | Adicionar fundo colorido/gradiente atras para o vidro aparecer; variantes claro/escuro; usar a mesma tela para as capturas. |

Fora da lista da issue e com fundo proprio: `PakitecActionSection`, `PakitecListRow`, `PakitecPicker`, `PakitecToggleRow`, `PakitecEmptyState`, `PakitecProgressView`. Nao entram no escopo (a issue lista 8 componentes). Confirmar no plano que ficam como estao.

### Repositorio-alvo 2: `pakitec-joe-app` (`/Volumes/External HD/Projetos/pakitec/pakitec-joe-workspace/pakitec-joe-app`, repositorio separado, working tree limpo)

- `Joe.xcodeproj/project.pbxproj` linhas 657-664: `XCRemoteSwiftPackageReference "pakitec-swiftui-components"`, `kind = upToNextMajorVersion; minimumVersion = 1.0.5;` (alterar para `1.1.0`). Os pacotes `royalvnc` (revisao fixa) e `Vendor/SwiftTerm` (local) ficam como estao.
- `Joe.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved` linhas 22-29: `revision 25f600358de3495155bb12ef793e219890ccd85c`, `version 1.0.5`. Vira a revisao da tag `v1.1.0`.
- Alvos minimos (pbxproj linhas 491-492 e 602-603): `IPHONEOS_DEPLOYMENT_TARGET = 18.0`, `MACOSX_DEPLOYMENT_TARGET = 14.0`. `Package.swift` do app (`JoeCore`): `.macOS(.v14), .iOS(.v18)`, `swiftLanguageModes: [.v5]`. Os arquivos de View ficam fora do alvo `JoeCore`, entao `swift test` do app nao compila as Views.
- Telas (todas importam `PakitecSwiftUIComponents`):
  - `Joe/Features/BoardView.swift` (151 linhas): `PakitecTabBar` (iOS), colunas no macOS com `PakitecTheme.surface.opacity(0.45)` em `RoundedRectangle` (linha 54, ja um pseudo-vidro), `.background(PakitecTheme.background)`, toolbar com `PakitecToolbarButton`, 6 `.sheet` (linhas 96-108), avatar com `.background(.white, in: Circle())` (linha 73).
  - `Joe/Features/CardDetailView.swift` (225): `.sheet` de edicao, mover, logs, git (linhas 56-59); `List` com `listRowBackground(Color.clear)`; `MoveView` com `PakitecToolbarButton` em `cancellationAction`/`confirmationAction` (linhas 165-168).
  - `Joe/Features/CardEditorView.swift` (186): `Form`, toolbar com `Button` nativo (linhas 34-36), `PakitecTextField`, `PakitecTextEditor`.
  - `Joe/Features/GitView.swift` (77): toolbar com `PakitecToolbarButton("Fechar")` (linha 29).
  - `Joe/Features/JiraImportView.swift` (113): toolbar com `Button` nativo (linhas 29-31).
  - `Joe/Features/SupportViews.swift` (302): `SettingsView`, `ArchivedView`, `LogsView` e `MoveView` com `PakitecToolbarButton` (linhas 47, 48, 107, 256).
  - `Joe/Features/MacLayout.swift` (158): so macOS. Largura de sheet por `MacLayoutMetrics` (540 pt, faixa 520-560), altura por `frame`, sem `presentationSizing`. `WindowResizingConfigurator` em `.background` (linha 117). Nao tocar nas medidas.
  - `Joe/Core/MacLayoutMetrics.swift` + `Tests/MacLayoutMetricsTests.swift`: medidas e teste que o app ja tem. Devem continuar verdes.
  - `Joe/Features/DictationAccessory.swift` linha 73: `.background(PakitecTheme.surface, in: shape)`. Candidato a vidro, mas fora da lista da issue.
  - `Joe/Features/RemoteDesktopView.swift`: fundo `Color.black` (linhas 43, 265, 494) e botao com `black.opacity(0.65)`. Tela de area remota, nao listada na issue. Deixar opaca.
  - `Joe/App/JoeApp.swift` linha 18: `RootView` com `.background(PakitecTheme.background)`; linha 46: card de login com `.white` solido.
- Terminal: `Joe/Terminal/TerminalScreen.swift` (307 linhas).
  - `NativeTerminalView` (UIKit linha 121, AppKit linha 156): `view.nativeBackgroundColor = UIColor/NSColor(hex: 0x090c12)`, opaco (alfa 1). Fundo ja atende `AC-005` hoje. O trabalho e proteger essa opacidade e aplicar vidro so nas barras.
  - `TerminalScreen` (linhas 208-260) e `ShellScreen` (263-300): barra de status no topo (HStack com `Circle` e `Text`), barra de teclas (`Esc`, `Tab`, `Ctrl+C`, setas) com `.buttonStyle(.bordered).background(PakitecTheme.surface)` (linhas 236 e 290), toolbar com `Button("Fechar")` e `Menu`. No iOS, `NavigationStack` proprio; no macOS, pilha do app.
  - `Joe/Terminal/UIColor+Hex.swift`: helper de cor.
- `Vendor/SwiftTerm`: dependencia local (`Package.swift`, `Sources`, etc.). Nao alterar o vendor; o fundo e definido por `nativeBackgroundColor` no Joe.

## Arquitetura e padroes existentes

- Tokens: `enum` com `static let` publicos (`PakitecTheme`, `PakitecSpacing`, `PakitecMetrics`, `PakitecTypography`). Cores adaptativas por `Color(light:dark:)` (UIKit `traits.userInterfaceStyle`, AppKit `appearance.bestMatch`). Seguir o mesmo padrao para tokens de vidro. Constituicao exige API publica documentada e estilo PT-BR (ver `docs/constitution.md`); os arquivos atuais quase nao tem TSDoc, entao o codigo novo deve ter.
- Componentes: `public struct ...: View` com `init` publico. Os `ButtonStyle` sao `private struct` no mesmo arquivo. O modificador interno de vidro deve ser `internal` (nao `public`), conforme `FR-001` ("de uso interno"). Sugestao: novo arquivo `PakitecGlassSurface.swift` com `struct PakitecGlassSurface: ViewModifier` e `extension View { func pakitecGlassSurface(...) }`.
- Hoje nenhum arquivo do pacote usa `@Environment`, `#available`, `glassEffect` ou `Material` alem de `PakitecCard`. Nao ha precedente interno para a decisao por acessibilidade.
- Ordem de decisao proposta dentro do modificador (sem redesenhar a arquitetura):
  1. `@Environment(\.accessibilityReduceTransparency)` ligado: fundo solido (`PakitecTheme.surface`/`surfaceElevated`) e `FR-008`.
  2. `@Environment(\.colorSchemeContrast) == .increased`: fundo solido com stroke `divider` (decisao P7; ver Alternativas).
  3. `#available(iOS 26, macOS 26, *)`: `glassEffect(.regular.tint(...), in: shape)`.
  4. Senao: `.regularMaterial` ou `.thinMaterial` conforme o token de intensidade.
- Uso de `#available` em `ViewModifier.body` com `if #available(iOS 26.0, macOS 26.0, *)` compila com alvo minimo iOS 17 / macOS 14 porque o SDK do Xcode 27.1 contem a API. Sem `#if canImport`/`#if swift` extra, pois o toolchain unico (Swift 6.4) ja conhece o simbolo. Isso quebra o build com Xcode antigo (sem SDK 26); registrar como restricao (R5).

## Testes e comandos atuais

- `Tests/PakitecSwiftUIComponentsTests/PakitecSwiftUIComponentsTests.swift`: 3 testes XCTest (`testThemeExposesCoreSemanticTokens`, `testThemeExposesInteractionMetrics`, `testTextEditorCanBeConstructed`). Nenhum cobre as superficies. `testThemeExposesInteractionMetrics` fixa `buttonHeight 48`, `compactButtonHeight 40`, `buttonCornerRadius 14`: nao mudar esses valores.
- Baseline medido hoje: `swift test` passa, 3 testes, 0 falhas, cerca de 20 s (alvo `arm64e-apple-macos14.0`).
- `swift test` roda no macOS do host sem simulador. Ele nao exerce `glassEffect` visualmente. Pontos testaveis sem OS 26:
  - Valores e faixas dos tokens (opacidade maior que zero e menor que 1, minimo do Terminal).
  - Funcao pura de decisao, por exemplo `GlassSurfaceMode.resolve(reduceTransparency:, increasedContrast:, glassAvailable:) -> .solid | .material | .glass`, recebendo booleanos. Cobre `AC-002`, `AC-004` e a regra "nunca totalmente transparente" sem depender do OS.
  - Construcao dos 8 componentes (`@MainActor`, como o teste de `PakitecTextEditor`).
- Nao testavel por `swift test`: aparencia real, legibilidade e `glassEffect`. Exige captura em simulador iOS 26 e app macOS 26 (`AC-001`, `AC-003`).
- Validacao proposta do pacote:
  - `swift test`
  - `xcodebuild -scheme PakitecSwiftUIComponents -destination 'generic/platform=iOS Simulator' build` e `-destination 'generic/platform=macOS' build` (o pacote tem o esquema automatico; a issue pede `xcodebuild` Debug para os dois).
- Validacao do Joe (conforme `docs/validation.md` do app, secoes 1, 2 e 4): `swift test` (14 testes, JoeCore), build macOS sem assinatura com `SYMROOT`/`OBJROOT` em `Build/QAMac` e `CODE_SIGNING_ALLOWED=NO`, e UI test iOS no simulador (`python3 scripts/fixture-server.py` + `xcodebuild test`, destino `iPhone 17`). Os destinos exatos devem ser confirmados com `xcrun simctl list devices` antes do build.

## Integracoes e dados

- Sem dado pessoal, credencial, API ou backend novo.
- Fluxo de publicacao (risco critico R1): `.github/workflows/auto-tag.yml` roda a cada push em `master`. Ele calcula a proxima tag **patch** (`v1.0.5` -> `v1.0.6`). Um merge simples em `master` cria `v1.0.6`, nao `v1.1.0`. O `Package.swift` nao carrega versao, entao "bump para 1.1.0" significa somente a tag.
- Joe resolve o pacote por `upToNextMajorVersion` 1.0.5; apos a tag `v1.1.0` a atualizacao exige `xcodebuild -resolvePackageDependencies` (ou Xcode "Update to Latest") para regravar `Package.resolved`.
- Dependencias do Joe: `royalvnc` (revisao fixa), `Vendor/SwiftTerm` (local), pacote de componentes (remoto). Acesso a rede ao GitHub necessario para resolver 1.1.0.

## Alternativas consideradas

1. Onde aplicar o vidro:
   - A. Modificador unico `pakitecGlassSurface(in:tint:)` usado pelos 8 componentes (recomendada: `FR-001`, menor duplicacao).
   - B. Um `ViewModifier` por componente. Descartada: duplica a logica de acessibilidade.
2. `Aumentar contraste` (P7):
   - A. Fundo solido com stroke `divider` (recomendada: contraste previsivel, texto sempre legivel).
   - B. Material espesso (`.regularMaterial`). Mantem translucidez e a pessoa pediu mais contraste; risco de reprovar `AC-004` na interpretacao "sem vidro translucido".
   - Para `Reduzir transparencia`, o mesmo fundo solido (A) atende `FR-008` e `SC-004` sem ambiguidade.
3. Fallback anterior ao 26: `.regularMaterial` em superficies grandes (Card, TabBar, NavigationHeader, campos) e `.thinMaterial` em pequenas (Badge, Button, ToolbarButton). Decisao de token, fixada no plano.
4. `Button` com vidro: `.buttonStyle(.glass)` (iOS/macOS 26) em vez de estilo proprio. Mais nativo, mas muda o contrato do `ButtonStyle` privado e nao permite o fallback no mesmo caminho. Preferir `glassEffect(.regular.interactive())` dentro do estilo existente.
5. `GlassEffectContainer` (iOS/macOS 26) para agrupar vidros vizinhos (por exemplo `HStack` de `PakitecBadge` ou `TabBar`). Opcional no pacote porque cada componente e independente; recomendado no Joe onde ha barras com varios botoes.
6. Terminal: manter `nativeBackgroundColor` opaco (`0x090c12`) e aplicar vidro so na barra de status/teclas e na toolbar (recomendada, igual a decisao do refinement). Alternativa de `alpha` 0.92-0.97 no fundo foi descartada: o terminal desenha por celulas e o ganho visual e baixo, com risco para o contraste.
7. Tag: (a) criar `v1.1.0` manualmente apontando para o commit de merge e depois deixar a automacao seguir (`v1.1.1` no proximo push); (b) alterar o workflow para respeitar minor. Ver R1; decisao do operador.

## Riscos tecnicos

- R1 (alto): O workflow `auto-tag.yml` cria `v1.0.6` ao receber o merge. Para obter `v1.1.0`: criar e enviar a tag `v1.1.0` manualmente antes do push em `master` (o workflow usa o maior tag por `sort=-v:refname`, e `v1.1.0 > v1.0.5` faria o proximo ser `v1.1.1`) ou ajustar o workflow no mesmo PR. Se a tag `v1.1.0` for enviada antes do push, o workflow cria `v1.1.1` e deixa duas tags no mesmo commit. A ordem deve ficar explicita no plano e a acao so ocorre no `/sdd-build` com confirmacao (P6).
- R2 (medio): `glassEffect`, `GlassEffectContainer` e `Glass` existem so no SDK 26. O build com `#available` exige Xcode 26 ou superior. O ambiente tem Xcode 27.1. Qualquer CI antiga sem SDK 26 passa a falhar.
- R3 (medio): Vidro duplicado. Em toolbars nativas do iOS/macOS 26 os botoes ja recebem vidro do sistema. Aplicar `glassEffect` em `PakitecToolbarButton` pode gerar vidro sobre vidro. Recomendacao: no OS 26, `PakitecToolbarButton` nao adiciona fundo proprio quando dentro de `ToolbarItem`, e usa vidro so fora de toolbar (no `PakitecNavigationHeader` do catalogo). Como o componente nao sabe onde esta, expor parametro interno ou decidir por captura.
- R4 (medio): Vidro sobre vidro (Button em Card, Badge em Card, campo em Card): vidro dentro de vidro com `glassEffect` nao e recomendado pela Apple; usar `GlassEffectContainer` ou manter o filho como cor/tint sem novo `glassEffect`. Tratar por nivel: Card e superficie de vidro; Button, Badge e campos dentro de Card usam tint translucido leve.
- R5 (medio): Legibilidade. `Badge` (12 pt, `caption`) e `AlertCard` usam texto colorido (`success`, `warning` verde/laranja) que perde contraste sobre vidro claro. Validar claro e escuro, e ajustar o tint.
- R6 (medio): Captura visual em OS 26. Ha runtimes iOS 26.1 e 26.5 instalados; o app macOS roda no macOS 26 local. Nao ha runtime iOS 18 ou 17 listado (so o `tail` da lista foi lido): confirmar com `xcrun simctl list runtimes`. Sem runtime anterior ao 26, `AC-002` (Material) so se prova por teste de decisao e por forcar o ramo de fallback via flag interna de preview.
- R7 (medio): Vidro precisa de fundo variado para ser perceptivel. Hoje o fundo e `PakitecTheme.background` liso (`F2F2F7`/`1C1C1E`). O catalogo e o Joe precisam de um fundo com cor/gradiente ou conteudo rolando atras, senao o "Liquid Glass perceptivel" (`SC-001`) nao se prova.
- R8 (medio): `PakitecNavigationHeader` nao tem fundo hoje. Dar-lhe uma superficie muda o layout (padding) e o uso no Joe (`BoardView` linha 51 usa o componente como titulo de coluna dentro de uma superficie). Risco de vidro duplicado e de regressao em `MacLayout`.
- R9 (baixo): Swift 6 e concorrencia. `Package.swift` usa tools 6.0 (modo Swift 6). Modificadores de `View` sao `@MainActor`; `Color(light:dark:)` ja compila. O app Joe usa `swiftLanguageModes: [.v5]`. Sem impacto previsto.
- R10 (baixo): Preview. O `PreviewProvider` unico existe para economizar memoria no Xcode. Adicionar variantes claro/escuro e acessibilidade deve manter um unico provider (e uma variavel local `@State` ou `Environment` para forcar `reduceTransparency` nas capturas).
- R11 (baixo): Terminal. `TerminalScreen` e `ShellScreen` duplicam a barra de teclas com `.background(PakitecTheme.surface)`. O vidro deve entrar nas duas. O teclado/`Menu` do iOS 26 ja ganha vidro automatico nas toolbars; `.buttonStyle(.bordered)` pode passar a `.glass` no OS 26 com `#available`.
- R12 (baixo): O Joe tem Features como `RemoteDesktopView` e `DictationAccessory` com superficies proprias. Nao fazem parte da lista da issue; se ficarem sem vidro, a UI pode parecer inconsistente. Decisao de produto (ver Lacunas).
- R13 (baixo): Merge. O repositorio principal tem `?? .agents/ .claude/ AGENTS.md docs/` nao rastreados no `git status`. Cuidar para nao incluir artefatos SDD em commits do pacote sem decisao explicita.

## Lacunas

- L1 (decisao do operador): tag `v1.1.0` e o workflow `auto-tag.yml` (R1). Opcoes: (A) tag manual `v1.1.0` antes do push e aceitar `v1.1.1` automatica depois; (B) alterar o workflow para ler a versao de um arquivo/tag manual; (C) criar `v1.1.0` manualmente e desabilitar a automacao neste push.
- L2 (decisao de produto): `Aumentar contraste` usa fundo solido (recomendado) ou Material espesso (P7).
- L3 (decisao de produto): inclusao de `PakitecTextEditor` e dos campos de formulario (`PakitecPicker`, `PakitecToggleRow`) no vidro. Recomendado: so `TextField`, `SecureField` e `TextEditor`.
- L4 (decisao de produto): `RemoteDesktopView` e `DictationAccessory` ficam fora do escopo? Recomendado: sim, `RemoteDesktopView` opaca; `DictationAccessory` usa o mesmo modificador se for exportado (hoje e `internal`).
- L5 (decisao de produto): opacidade minima do fundo do Terminal. O valor atual e 1.0 (`0x090c12`); recomendado manter 1.0 e adicionar teste que fixe `>= 0.95`.
- L6: valores iniciais dos tokens de intensidade (opacidade do tint, 0.06 a 0.18 por tema) dependem de captura nos dois temas; o plano propoe e as capturas aprovam (P1).
- L7: `PakitecToolbarButton` dentro de `ToolbarItem` no OS 26 (R3): definir por captura se o componente aplica vidro ou delega ao sistema.
- L8: simuladores anteriores ao 26 nao foram confirmados (R6). Verificar com `xcrun simctl list runtimes` na fase de plano.
- L9: nao se verificou se o `Package.resolved` do Joe muda mais que a linha do pacote ao resolver 1.1.0. Conferir `git diff` apos `-resolvePackageDependencies`.
- L10: o `customfield_10000` com os criterios nao e retornado pela API Jira (P5); o `issue.md` e a fonte.

## Arquivos provaveis por repositorio-alvo

Pacote (`pakitec-swiftui-components`):
- Novo: `Sources/PakitecSwiftUIComponents/PakitecGlassSurface.swift` (modificador interno e funcao de decisao).
- Editar: `PakitecTheme.swift` e/ou `PakitecTokens.swift` (tokens), `PakitecCard.swift`, `PakitecAlertCard.swift`, `PakitecTabBar.swift`, `PakitecNavigationHeader.swift`, `PakitecToolbarButton.swift`, `PakitecButton.swift`, `PakitecBadge.swift`, `PakitecTextField.swift`, `PakitecSecureField.swift`, `PakitecTextEditor.swift`, `PakitecComponentsPreview.swift`.
- Testes: `Tests/PakitecSwiftUIComponentsTests/PakitecSwiftUIComponentsTests.swift` (ou novo arquivo de teste de superficie).
- Docs: `README.md` (secao de Liquid Glass e versionamento), possivelmente `.github/workflows/auto-tag.yml` (L1).
- Nao editar: `Package.swift`.

App (`pakitec-joe-app`, apos a tag):
- `Joe.xcodeproj/project.pbxproj` (`minimumVersion`), `Joe.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved`.
- `Joe/Features/BoardView.swift`, `CardDetailView.swift`, `CardEditorView.swift`, `GitView.swift`, `JiraImportView.swift`, `SupportViews.swift`, `MacLayout.swift` (so se precisar de `presentationBackground`/fundo de sheet), `Joe/Terminal/TerminalScreen.swift`, `Joe/App/JoeApp.swift` (fundo do login/raiz, opcional), `Joe/Features/DictationAccessory.swift` (opcional).
- Testes: `Tests/MacLayoutMetricsTests.swift` (regressao), possivel novo teste de constante de opacidade do Terminal.
- Nao editar: `Vendor/SwiftTerm`, alvos minimos, `Joe/Core`, `Joe/Networking`.

Somente registre conclusoes sustentadas por evidencia do repositorio ou documentacao referenciada.
<!-- sdd:section specs.research-template:end -->
