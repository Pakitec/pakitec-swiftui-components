# Plano tecnico SCRUM-1761

<!-- sdd:section specs.plan-template:start -->
## Resumo

A Task SCRUM-1761 cobre dois repositorios, em sequencia:

- Pacote (`pakitec-swiftui-components`, este workspace, branch `feature/liquid-glass`): cria um modificador interno de superficie em vidro, tokens de intensidade no `PakitecTheme`, aplica o modificador em 8 componentes, atualiza preview e testes, e publica a tag `v1.1.0`.
- App (`pakitec-joe-app`, `/Volumes/External HD/Projetos/pakitec/pakitec-joe-workspace/pakitec-joe-app`): consome a tag `v1.1.0` e aplica os recursos do iOS 26 e macOS 26 em telas, sheets, barras e toolbars, com Terminal de fundo opaco.

Nao existe `group.json` nem tarefa fora desta Task. Toda tarefa em `tasks.md` registra o `Repositorio-alvo`. As tarefas do pacote vem primeiro. A tarefa de release so roda no `/sdd-build`, com confirmacao do operador. As tarefas do app dependem da tag.

Abordagem central: um unico `ViewModifier` interno (`pakitecGlassSurface`) decide a superficie por uma funcao pura testavel por `swift test`. A ordem de decisao e: Reduzir transparencia, Aumentar contraste, Liquid Glass (OS 26), Material (OS anterior).

## Constitution Check

- Padroes por stack lidos: `docs/constitution.md` e `docs/sdd/templates/swift.md`. Atendido.
- Arquitetura existente preservada: tokens como `enum` com `static let`, componentes `public struct ...: View`, `ButtonStyle` privados no mesmo arquivo. O modificador novo e `internal`. `Package.swift` do pacote nao muda. Alvos minimos do pacote (iOS 17, macOS 14) e do app (iOS 18, macOS 14) nao mudam. `MacLayout` nao muda. Atendido.
- Seguranca, testes e qualidade: `swift test` no pacote, `xcodebuild` Debug iOS e macOS no pacote e no app, QA visual em OS 26. Sem dado pessoal, credencial ou endpoint novo. Atendido.
- Escrita PT-BR: codigo novo leva TSDoc/DocC em PT-BR (voz ativa, frases curtas, so o porque). Atendido.
- Jira: o workspace e a Task estao vinculados; esta fase nao altera `workflow.json`.
- Desvios: dois repositorios numa Task (decisao do operador, ja registrada no refinement) e a dependencia de Xcode 26 ou superior para compilar o pacote (R2). Justificados em Complexity Tracking.

## Contexto tecnico

- Runtime/stack: SwiftUI, Swift 6 (tools 6.0 no pacote; Swift 6.4 no Xcode 27.1). O app usa `swiftLanguageModes: [.v5]`.
- Dependencias: sem dependencia nova. O app mantem `royalvnc` (revisao fixa) e `Vendor/SwiftTerm` (local, nao editar). O pacote do app sobe de 1.0.5 para 1.1.0 (`upToNextMajorVersion`).
- Dados/storage: nenhum. Os tokens sao constantes. O modificador nao guarda estado.
- Auth/permissoes: nao se aplica. A publicacao exige push e tag no GitHub pela conta do operador.
- Plataformas: pacote iOS 17 e macOS 14; app iOS 18 e macOS 14. `glassEffect` so em iOS 26 e macOS 26, por `#available`.
- Restricoes: compilar exige SDK 26 (Xcode 26 ou superior; ambiente tem Xcode 27.1). O `auto-tag.yml` cria a proxima tag patch a cada push em `master` (R1). Nao ha `CHANGELOG`; o `Package.swift` nao carrega versao, entao "bump 1.1.0" significa a tag `v1.1.0` mais a secao "Versionamento" do README.

## Arquitetura e abordagem

### Decisoes adotadas por padrao (premissas reversiveis)

| Id | Decisao | Reversao |
| --- | --- | --- |
| D1 | Campos de entrada = `PakitecTextField`, `PakitecSecureField`, `PakitecTextEditor`. `PakitecPicker` e `PakitecToggleRow` ficam como estao (L3). | Incluir os outros no modificador. |
| D2 | `PakitecButton` `primary` e `destructive` seguem solidos (texto branco). O vidro entra em `secondary` e `ghost`. | Trocar o estilo preenchido por vidro com tint. |
| D3 | `RemoteDesktopView` fica opaco. `DictationAccessory` fica fora do escopo (L4). | Aplicar o modificador depois. |
| D4 | Terminal com opacidade 1.0 (`0x090c12`). Um teste exige `>= 0.95` (L5). | Baixar para ate 0.95 se a captura aprovar. |
| D5 | Funcao pura `PakitecGlassSurfaceMode.resolve(...)` testavel por `swift test`. | Nao se aplica. |
| D6 | Sem vidro duplicado: toolbar nativa recebe o vidro do sistema; itens dentro de `PakitecCard` usam tint leve, sem novo `glassEffect` (R3, R4). | Ajustar por captura (L7). |
| D7 (P7) | "Aumentar contraste": fundo solido com stroke `divider` (recomendado). "Reduzir transparencia": fundo solido sem stroke. | Trocar por `.regularMaterial` se o operador pedir. |

### Valores propostos dos tokens (P1 e P2)

Estes valores sao propostas. A captura em tema claro e escuro, em OS 26, aprova ou ajusta cada um (TASK-011). A faixa permitida e 0.06 a 0.18 (L6).

Opacidade do tint do vidro, por intensidade e tema:

| Intensidade | Claro | Escuro | Uso |
| --- | --- | --- | --- |
| `subtle` | 0.06 | 0.08 | Badge, Button `secondary` e `ghost`, ToolbarButton, NavigationHeader, itens dentro de Card |
| `regular` | 0.10 | 0.14 | Card, TabBar, campos de entrada |
| `strong` | 0.14 | 0.18 | AlertCard (tint do tom: info, sucesso, aviso, erro) |

Outros valores:

| Token | Valor inicial | Regra |
| --- | --- | --- |
| `glassMinimumTintOpacity` | 0.04 | Piso: a funcao de opacidade nunca devolve menos que isto (FR-007). |
| `glassMaximumTintOpacity` | 0.30 | Teto: o vidro nao vira cor chapada. |
| Material de fallback grande | `.regularMaterial` | Card, TabBar, NavigationHeader, campos. |
| Material de fallback pequeno | `.thinMaterial` | Badge, Button, ToolbarButton. |
| Stroke em "Aumentar contraste" | `PakitecTheme.divider`, 1 pt | D7. |
| Fundo solido de acessibilidade | `PakitecTheme.surface` (superficies) e `surfaceElevated` (campos) | FR-008. |
| Opacidade minima do Terminal (P2) | 0.95 (valor usado: 1.0) | Teste no app (TASK-014). |

Os tokens entram em `PakitecTheme.swift`. A funcao `PakitecTheme.glassTintOpacity(_ intensity:, colorScheme:) -> Double` le a tabela acima e aplica piso e teto. Nao altera `buttonHeight 48`, `compactButtonHeight 40` nem `buttonCornerRadius 14`.

### Funcao de decisao

`PakitecGlassSurfaceMode.resolve(reduceTransparency: Bool, increasedContrast: Bool, glassAvailable: Bool) -> PakitecGlassSurfaceMode`

| reduceTransparency | increasedContrast | glassAvailable | Resultado |
| --- | --- | --- | --- |
| true | qualquer | qualquer | `.solid` |
| false | true | qualquer | `.solidWithStroke` |
| false | false | true | `.glass` |
| false | false | false | `.material` |

O modificador le `@Environment(\.accessibilityReduceTransparency)` e `@Environment(\.colorSchemeContrast)`. `glassAvailable` vem de `#available(iOS 26, macOS 26, *)`. O ramo `.glass` chama `glassEffect(.regular.tint(...), in: shape)`; nunca ha vidro no texto (FR-005).

### Arquivos a alterar

Pacote (`/Volumes/External HD/Projetos/pakitec/pakitec-swiftui-components`):

- `Sources/PakitecSwiftUIComponents/PakitecTheme.swift`: tokens de intensidade e funcao de opacidade.
- `Sources/PakitecSwiftUIComponents/PakitecCard.swift`: troca `.regularMaterial` pelo modificador (`regular`).
- `Sources/PakitecSwiftUIComponents/PakitecAlertCard.swift`: vidro `strong` com tint do tom.
- `Sources/PakitecSwiftUIComponents/PakitecTabBar.swift`: vidro `regular` no lugar de `surface` opaco; mantem o divisor.
- `Sources/PakitecSwiftUIComponents/PakitecNavigationHeader.swift`: superficie `subtle` opcional, sem mudar o padding atual (R8).
- `Sources/PakitecSwiftUIComponents/PakitecToolbarButton.swift`: vidro `subtle` fora de toolbar; dentro de `ToolbarItem` delega ao sistema (D6, L7).
- `Sources/PakitecSwiftUIComponents/PakitecButton.swift`: vidro nos estilos `secondary` e `ghost` (D2).
- `Sources/PakitecSwiftUIComponents/PakitecBadge.swift`: capsula `subtle`; revisar contraste do texto de 12 pt (R5).
- `Sources/PakitecSwiftUIComponents/PakitecTextField.swift`, `PakitecSecureField.swift`, `PakitecTextEditor.swift`: fundo `regular` (D1).
- `Sources/PakitecSwiftUIComponents/PakitecComponentsPreview.swift`: fundo colorido, variantes claro/escuro e acessibilidade, num unico `PreviewProvider` (R7, R10).
- `Tests/PakitecSwiftUIComponentsTests/PakitecSwiftUIComponentsTests.swift`: preserva os 3 testes atuais.
- `README.md`: secao de Liquid Glass e "Versionamento" (1.1.0).
- `.github/workflows/auto-tag.yml`: somente se o operador escolher a opcao B no checkpoint de release (R1).

App (`/Volumes/External HD/Projetos/pakitec/pakitec-joe-workspace/pakitec-joe-app`), somente apos a tag:

- `Joe.xcodeproj/project.pbxproj` (`minimumVersion` 1.0.5 para 1.1.0, linhas ~657-664) e `Joe.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved` (revisao da tag).
- `Joe/Features/BoardView.swift`, `CardDetailView.swift`, `CardEditorView.swift`, `GitView.swift`, `JiraImportView.swift`, `SupportViews.swift`.
- `Joe/Terminal/TerminalScreen.swift`: vidro nas barras de status e de teclas e na toolbar; fundo do terminal intacto.
- `Joe/Features/MacLayout.swift`: somente se precisar de fundo de sheet; nao toca nas medidas.

### Arquivos a criar

Pacote:

- `Sources/PakitecSwiftUIComponents/PakitecGlassSurface.swift`: `PakitecGlassSurfaceMode` (com `resolve`), `PakitecGlassIntensity`, `struct PakitecGlassSurface: ViewModifier` e `extension View { func pakitecGlassSurface(...) }`, todos `internal`.
- `Tests/PakitecSwiftUIComponentsTests/PakitecGlassSurfaceTests.swift`: testes da funcao de decisao, dos tokens e da construcao dos 8 componentes.

App:

- `Joe/Core/TerminalAppearance.swift`: constante de opacidade do fundo do Terminal (1.0) e minimo (0.95), em `Joe/Core` para entrar no alvo `JoeCore` testavel. Confirmar o alvo do arquivo na TASK-014.
- `Tests/TerminalAppearanceTests.swift`: exige opacidade `>= 0.95`.

Nao editar: `Package.swift` do pacote e do app, `Vendor/SwiftTerm`, alvos minimos, regra de negocio, backend, `RemoteDesktopView`, `DictationAccessory`.

## Contratos e dados

- Contrato publico do pacote: nenhum simbolo publico novo. A API publica dos 8 componentes e dos 3 campos permanece igual. O modificador e a funcao de decisao sao `internal`.
- Contrato novo no app: `TerminalAppearance.backgroundOpacity` (interno do app).
- Dados: nenhum. Sem migracao, sem storage.

### Evidencia visual

Local: `evidence/SCRUM-1761/` a partir da raiz do workspace do pacote, com `manifest.json` (campos `criteriaId`, `kind`, `status`, `viewport`, `file`, `mimeType`, `size`, `sha256`, `containsSensitiveData`). Nome deterministico, por exemplo `SCRUM-1761-AC-001-ios26-light.png`. Somente PNG oficial de ate 10 MB sobe ao Jira. Nenhuma captura expoe dado pessoal; o Joe usa fixture (`scripts/fixture-server.py`). Capturas de falha ou exploratorias nao aprovam criterio.

Criterios visuais obrigatorios para `workflow.visualEvidence.criteria` (declarar antes das capturas, cada um inicialmente como `{ "criteriaId": "AC-00N" }`). A declaracao nao depende de anexo.

| criteriaId | O que a captura oficial prova | Ambiente |
| --- | --- | --- |
| `AC-001` | `PakitecComponentsPreview` com Card, AlertCard, TabBar, NavigationHeader, ToolbarButton, Button, Badge e campos usa o vidro nativo, com fundo visivelmente translucido e nunca transparente. | Simulador iOS 26.x e app macOS 26, tema claro e escuro |
| `AC-002` | Os mesmos componentes exibem Material (`.regularMaterial` ou `.thinMaterial`) no ramo de fallback. Se nao houver runtime anterior ao 26, forca-se o ramo por flag interna de preview, e o teste de decisao complementa. | Runtime iOS 17 a 25 ou macOS 14 a 25; senao preview forcado |
| `AC-003` | Texto sobre o vidro legivel nos temas claro e escuro, incluindo Badge de 12 pt e AlertCard colorido. | Simulador iOS 26.x e macOS 26, claro e escuro |
| `AC-004` | Com "Reduzir transparencia" e com "Aumentar contraste" ligados, as superficies ficam em fundo solido (com stroke no segundo caso), sem vidro translucido. | Simulador iOS 26.x e macOS 26, uma captura por opcao |
| `AC-005` | Terminal do Joe com fundo opaco (`0x090c12`), vidro apenas em barras e toolbar ao redor, conteudo legivel. | Joe no simulador iOS 26.x e no macOS 26 |

`AC-006` nao tem evidencia visual; e provado por `swift test` e `xcodebuild`.

## Seguranca e privacidade

- Sem dado pessoal, credencial, segredo ou endpoint novo. Nenhuma mudanca em `Info.plist`, entitlements, ATS ou rede.
- Capturas do Joe usam fixture isolado. Revisar cada PNG antes de marcar `containsSensitiveData = false`.
- Leitura de evidencia por caminho seguro em `evidence/SCRUM-1761/` (sem `..`, sem symlink externo), com SHA-256, tamanho e MIME conferidos. Nenhum retorno expoe Base64.
- Nao versionar artefatos SDD no commit do pacote sem decisao (R13): `.agents/`, `.claude/`, `AGENTS.md` e `docs/` estao nao rastreados. A tarefa de release lista os arquivos antes do commit e pede confirmacao.
- Push, merge e tag sao acoes externas e irreversiveis em parte. Exigem confirmacao explicita do operador.

## Observabilidade

Nao ha servico nem log. O sinal de qualidade e: resultado de `swift test`, resultado dos `xcodebuild`, capturas oficiais com SHA-256 e o `manifest.json`. A funcao de decisao pura e o ponto de diagnostico: um teste por linha da tabela. Nao adicionar log de producao.

## Etapas de implementacao

Ordem (detalhe e IDs em `tasks.md`):

1. Pacote, US-001: testes da funcao de decisao e dos tokens (TASK-001), tokens (TASK-002), modificador (TASK-003), componentes (TASK-004 a TASK-007), preview (TASK-008), README (TASK-009).
2. Pacote, validacao: `swift test` e `xcodebuild` (TASK-010) e QA visual com aprovacao dos tokens (TASK-011).
3. Pacote, US-002: release (TASK-012), com checkpoint do operador (abaixo).
4. App, US-003, somente apos a tag: dependencia (TASK-013), Terminal (TASK-014, TASK-015), telas (TASK-016 a TASK-018), validacao (TASK-019), QA visual (TASK-020).

### Checkpoint de release (R1): obrigatorio e sem decisao previa

O `auto-tag.yml` calcula a proxima tag patch pelo maior `vX.Y.Z` e cria `v1.0.6` a cada push em `master`. A tarefa TASK-012 pausa e apresenta as opcoes ao operador. O planner nao escolhe.

- Opcao A: criar e enviar a tag `v1.1.0` manualmente antes do push em `master` e aceitar a tag automatica extra (`v1.1.1`, no mesmo commit, criada pelo workflow).
- Opcao B: ajustar `.github/workflows/auto-tag.yml` no mesmo PR para respeitar a versao minor manual, e entao publicar.
- Opcao C: Outra (o operador descreve).

Antes de qualquer acao externa, TASK-012 mostra: branch, commits a mesclar, arquivos do commit, tags existentes (`v1.0.0` a `v1.0.5`) e a tag que a opcao escolhida cria. Sem resposta explicita, a tarefa nao executa merge, push nem tag.

## Estrategia de testes

Pacote:

- `swift test` (baseline: 3 testes, 0 falhas, ~20 s). Os 3 testes atuais seguem verdes.
- Novos testes em `PakitecGlassSurfaceTests.swift`: uma assercao por linha da tabela de `resolve` (cobre `AC-002` e `AC-004` sem OS 26); faixas dos tokens (maior que zero, menor que 1, piso e teto); `intensity` ordenada (`subtle < regular < strong` por tema); construcao `@MainActor` dos 8 componentes e dos 3 campos.
- `xcodebuild -scheme PakitecSwiftUIComponents -destination 'generic/platform=iOS Simulator' build` e `-destination 'generic/platform=macOS' build`, configuracao Debug.
- QA visual (nao testavel por `swift test`): `AC-001`, `AC-002`, `AC-003`, `AC-004`. Confirmar runtimes com `xcrun simctl list runtimes` (L8); sem OS 26, o QA visual nao passa (P4).

App:

- `swift test` no Joe (14 testes atuais mais o novo `TerminalAppearanceTests`). `MacLayoutMetricsTests` segue verde.
- `xcodebuild` Debug macOS sem assinatura (`CODE_SIGNING_ALLOWED=NO`, `SYMROOT`/`OBJROOT` em `Build/QAMac`) e Debug iOS Simulator (destino confirmado com `xcrun simctl list devices`).
- Conferir `git diff` do `Package.resolved` apos `xcodebuild -resolvePackageDependencies` (L9).
- QA visual: `AC-005` (Terminal) e telas Board, CardDetail, CardEditor, GitView, JiraImport e sheets em OS 26 e em OS anterior.

## Rollout e rollback

Rollout:

1. Pacote em `feature/liquid-glass`: validar tudo, depois (com confirmacao) merge na `master`, push e tag `v1.1.0`.
2. App: so apos a tag. Atualizar a dependencia, aplicar telas e validar.
3. Publicar o app pelo fluxo normal do Joe (`MARKETING_VERSION` e `CURRENT_PROJECT_VERSION` por regra do projeto, fora desta Task).

Rollback:

- Antes do push: descartar a branch ou reverter commits locais. Nada externo mudou.
- Apos tag publicada: nao reescrever ou apagar `v1.1.0`. Publicar `v1.1.1` com `git revert` do vidro, ou fixar o app na `1.0.5` (reverter `pbxproj` e `Package.resolved`). As tags `v1.0.x` continuam disponiveis.
- App: reverter o commit das telas. Como o app so usa API publica existente do pacote, nao ha migracao.
- Falha so no OS 26: o fallback para Material e a leitura de `reduceTransparency` ja limitam o impacto; um token pode baixar o tint sem mudar a API.

## Riscos e mitigacoes

| Risco | Mitigacao |
| --- | --- |
| R1 `auto-tag.yml` cria `v1.0.6` | Checkpoint de release com opcoes A, B e C. Sem decisao automatica. |
| R2 SDK 26 obrigatorio | Registrar no README que o pacote exige Xcode 26 ou superior. Verificar CI externa. |
| R3 e R4 vidro duplicado | D6: toolbar delega ao sistema; itens em Card usam tint leve; `GlassEffectContainer` no Joe para barras com varios botoes. |
| R5 contraste de Badge e AlertCard | Validar em AC-003; ajustar tint `strong` e cor do texto por captura. |
| R6 sem runtime anterior ao 26 | Forcar ramo de fallback por flag interna de preview; teste de decisao cobre a regra. |
| R7 fundo liso limita o efeito | Preview com gradiente atras; no Joe, validar com conteudo rolando. |
| R8 NavigationHeader sem fundo | Superficie opcional e sem mudar padding; revisar `BoardView` linha ~51. |
| R13 artefatos SDD nao rastreados | Listar arquivos do commit antes de commitar; nao incluir `docs/`, `.agents/`, `.claude/`, `AGENTS.md` sem decisao. |
| App compila antes da tag | Tarefas do app dependem de TASK-012 (SC-007, P3). |

## Complexity Tracking

| Desvio | Necessidade | Alternativa simples rejeitada |
| --- | --- | --- |
| Uma Task, dois repositorios | Decisao do operador no refinement (sem `group.json`). | Duas Tasks ou grupo multi-projeto: rejeitadas pelo operador. |
| Funcao pura de decisao separada do modificador | Permite provar `AC-002` e `AC-004` com `swift test`, sem OS 26. | Logica so dentro de `body`: nao testavel sem simulador. |
| `Joe/Core/TerminalAppearance.swift` | Constante testavel por `swift test` (as Views ficam fora de `JoeCore`). | Constante dentro de `TerminalScreen.swift`: sem teste automatizado. |
| Compilar com SDK 26 | `glassEffect` so existe no SDK 26. | `#if swift`/`canImport`: nao ajuda, o toolchain unico ja conhece o simbolo. |

## Gate de execucao

`READY_TO_BUILD` exige:

- `spec.md` sem `NEEDS CLARIFICATION` e `checklist.md` com Planning Quality marcado.
- `plan.md` e `tasks.md` com paths reais e `Repositorio-alvo` em toda tarefa.
- `workflow.visualEvidence.criteria` declarado com `AC-001` a `AC-005` antes das capturas.
- Operador ciente de que TASK-012 pausa para escolher A, B ou C, e de que as tarefas do app so iniciam apos a tag.
- Ambiente com Xcode 27.1 e runtime de simulador iOS 26.x (P4).

Nenhuma pergunta de produto fica aberta: as premissas D1 a D7 e os valores de tokens sao reversiveis e sujeitos a aprovacao por captura.
<!-- sdd:section specs.plan-template:end -->
