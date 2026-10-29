# Snapshot da issue SCRUM-1761

<!-- sdd:section specs.issue-template:start -->
- Jira: `SCRUM-1761`
- Projeto: `SCRUM`
- Status no momento do planejamento: `Em andamento`
- Capturado em: `2026-10-28T21:46:46-03:00`
- Hash normalizado: `e597739b75dd30963c23b108990046c1c12e98356430d4755dfcb03d54e5cacf`

## Resumo

Aplicar Liquid Glass nos componentes SwiftUI (v1.1.0) e no app pakitec-joe-app (iOS e macOS).

## Descricao

**Historia:** Eu, como pessoa que usa os apps Pakitec, quero superficies com Liquid Glass moderado nos componentes e no app Joe, para ter a aparencia nativa do iOS e macOS 26 sem perder a legibilidade.

**Contexto:** Os componentes do pacote `pakitec-swiftui-components` usam superficies solidas (`PakitecTheme.surface`) e nao tem Liquid Glass. O app `pakitec-joe-app` consome o pacote na versao 1.0.5 e tambem nao usa Liquid Glass. A Task cobre os dois repositorios em sequencia; a equipe autorizou alterar os dois nesta mesma Task (workspace Jira unico: este pacote).

**Resultado esperado:** Liquid Glass perceptivel, mas moderado. O tema nao fica totalmente transparente e o texto continua legivel.

### Parte 1: pakitec-swiftui-components
- Criar modificador interno de superficie em vidro: `glassEffect` em iOS 26 / macOS 26 ou superior; `.regularMaterial` ou `.thinMaterial` nos anteriores.
- Manter alvos minimos do pacote: iOS 17 e macOS 14.
- Aplicar o vidro em Card, AlertCard, TabBar, NavigationHeader, ToolbarButton, Button, Badge e campos de entrada. Tokens do tema controlam a intensidade.
- Aplicar o vidro as superficies, nao ao texto.
- Atualizar `PakitecComponentsPreview` e os testes.
- Bump para 1.1.0, merge de `feature/liquid-glass` na `master`, publicar no GitHub e criar a tag `v1.1.0`.

### Parte 2: pakitec-joe-app (depende da tag v1.1.0)
- Atualizar a dependencia de 1.0.5 para 1.1.0 em `Joe.xcodeproj` e `Package.resolved`.
- Aplicar recursos do iOS 26 e macOS 26 em Board, CardDetail, CardEditor, GitView, JiraImport e Terminal, alem de sheets, barras e toolbars. Usar `#available` com fallback para iOS 18 e macOS 14.
- Respeitar a diferenca de layout entre iOS e macOS (`MacLayout`).
- Fora do escopo: regra de negocio, backend e alvos minimos.

### Decisoes (refinamento, 2026-10-28)
- Intensidade: tokens no `PakitecTheme`, valores iniciais propostos no plano e aprovados por captura nos temas claro e escuro.
- Versao: 1.1.0 confirmada; tag `v1.1.0`.
- Terminal (SwiftTerm): fundo opaco ou quase opaco; vidro so em barras e toolbars ao redor.
- Escopo: as duas partes na mesma Task `SCRUM-1761` (sem grupo multi-projeto; decisao do operador).
- Acessibilidade: com "Reduzir transparencia" ou "Aumentar contraste" ligados, a superficie usa fundo solido ou Material.
- Validacao visual real exige simulador ou dispositivo com OS 26 (Xcode 27.1).
- Merge, push e criacao de tag so no `/sdd-build`, com confirmacao.

## Criterios e campos personalizados

- Projeto (`customfield_10078`): pakitec-swiftui-components e pakitec-joe-app.
- Regras de negocio (`customfield_10079`): Liquid Glass perceptivel, mas nunca totalmente transparente; texto legivel nos temas claro e escuro; fallback em Material antes do OS 26; alvos minimos mantidos (pacote iOS 17 / macOS 14; app iOS 18 / macOS 14).
- Detalhes tecnicos (`customfield_10081`): SwiftUI, Swift 6, Swift Package. `glassEffect` a partir de iOS 26 / macOS 26 com `#available`. App Joe usa `XCRemoteSwiftPackageReference` (1.0.5). Validacao: `swift test` e `xcodebuild` Debug para iOS e macOS.
- Criterios de aceite enviados ao `customfield_10000` (nao retornado pela leitura da issue):
  - AC-1: Dado iOS/macOS 26+, quando um componente com vidro e exibido, entao usa `glassEffect` e nao fica totalmente transparente.
  - AC-2: Dado iOS 17 a 25 / macOS 14 a 25, quando o componente e exibido, entao usa `.regularMaterial` ou `.thinMaterial`.
  - AC-3: Dado tema claro ou escuro, quando ha texto sobre o vidro, entao o texto permanece legivel, validado por capturas.
  - AC-4: Dado "Reduzir transparencia" ou "Aumentar contraste" ligado, quando a superficie e exibida, entao usa fundo solido ou Material.
  - AC-5: Dado o Terminal do Joe, quando e exibido, entao o fundo e opaco ou quase opaco.
  - AC-6: Dado o pacote, quando o build termina, entao os alvos minimos seguem iOS 17 / macOS 14 (app: iOS 18 / macOS 14) e `swift test` passa.

## Anexos relevantes

Nenhum anexo. `assets/manifest.json` registra lista vazia.

## Subtarefas existentes

Nenhuma no momento do snapshot.

Este arquivo e um snapshot para rastreabilidade. A issue Jira continua sendo a fonte da demanda.
<!-- sdd:section specs.issue-template:end -->
