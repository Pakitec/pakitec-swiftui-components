# Tarefas SCRUM-1761

<!-- sdd:section specs.tasks-template:start -->
## Formato

`TASK-ID [P?] [US-ID] Descricao com path exato`

`[P]` marca execucao paralela potencialmente segura: arquivos diferentes e nenhuma dependencia pendente. O build so honra `[P]` quando iniciado com `--parallel`; por padrao a execucao e sequencial e `[P]` e apenas informativo.

Convencoes desta Task:

- Uma Task, dois repositorios. Cada tarefa traz `Repositorio-alvo: pacote | app`.
- `pacote` = `/Volumes/External HD/Projetos/pakitec/pakitec-swiftui-components` (paths relativos a esta raiz).
- `app` = `/Volumes/External HD/Projetos/pakitec/pakitec-joe-workspace/pakitec-joe-app` (paths relativos a esta raiz).
- Tarefas do pacote primeiro. Tarefas do app dependem da tag `v1.1.0` (TASK-012).
- Ownership: `sdd-implementer` implementa; `sdd-qa-reviewer` valida e captura; o operador confirma release e aprova tokens.
- Em `[P]`, os arquivos nao se sobrepoem. A unica dependencia comum ja esta concluida antes (TASK-003 ou TASK-013).
- Nenhuma tarefa cria subtarefa fora desta Task. Sem `group.json`.

## Fase 1 - Setup/Fundacao

Nao ha setup separado. A fundacao do pacote (tokens e modificador) fica na US-001 porque desbloqueia os componentes. A fundacao do app e a TASK-013, dentro da US-003.

## Fase 2 - US-001 (P1): superficies de vidro no pacote

**Objetivo**: os 8 componentes usam vidro em OS 26, Material antes, e solido com acessibilidade ligada.  
**Teste independente**: abrir `PakitecComponentsPreview` em claro e escuro, em OS 26, com e sem as opcoes de acessibilidade, e rodar `swift test`.

### Testes

- [ ] `TASK-001 [US-001]` Criar `Tests/PakitecSwiftUIComponentsTests/PakitecGlassSurfaceTests.swift` com testes que falham antes da implementacao.
  - Tipo: test
  - Repositorio-alvo: pacote
  - Ownership: sdd-implementer
  - Requisitos: FR-006, FR-007, FR-008, FR-010, NFR-003
  - Criterios: AC-002, AC-004, AC-006
  - Dependencias: nenhuma
  - Arquivos provaveis: `Tests/PakitecSwiftUIComponentsTests/PakitecGlassSurfaceTests.swift`
  - Objetivo: uma assercao por linha da tabela de `PakitecGlassSurfaceMode.resolve`; faixas dos tokens (piso 0.04, teto 0.30, `subtle < regular < strong` por tema, valor sempre maior que 0 e menor que 1); construcao `@MainActor` dos 8 componentes e dos 3 campos.
  - Validacao: `swift test` compila os novos testes e falha apenas pelos simbolos ainda ausentes.
  - Subtarefa Jira: SCRUM-1765
  - Estado: pending

### Implementacao

- [ ] `TASK-002 [US-001]` Adicionar tokens de intensidade e `glassTintOpacity(_:colorScheme:)` ao `PakitecTheme`.
  - Tipo: implementation
  - Repositorio-alvo: pacote
  - Ownership: sdd-implementer
  - Requisitos: FR-006, FR-007, NFR-005
  - Criterios: AC-001, AC-003
  - Dependencias: TASK-001
  - Arquivos provaveis: `Sources/PakitecSwiftUIComponents/PakitecTheme.swift`
  - Objetivo: valores propostos no plano (subtle 0.06/0.08, regular 0.10/0.14, strong 0.14/0.18; piso 0.04; teto 0.30). TSDoc em PT-BR. Nao alterar `buttonHeight`, `compactButtonHeight`, `buttonCornerRadius`.
  - Validacao: `swift test` passa nos testes de token e nos 3 testes atuais.
  - Subtarefa Jira: SCRUM-1766
  - Estado: pending

- [ ] `TASK-003 [US-001]` Criar o modificador interno `pakitecGlassSurface` e a funcao `PakitecGlassSurfaceMode.resolve`.
  - Tipo: implementation
  - Repositorio-alvo: pacote
  - Ownership: sdd-implementer
  - Requisitos: FR-001, FR-002, FR-003, FR-005, FR-007, FR-008, NFR-001, NFR-003, NFR-005
  - Criterios: AC-001, AC-002, AC-004, AC-006
  - Dependencias: TASK-002
  - Arquivos provaveis: `Sources/PakitecSwiftUIComponents/PakitecGlassSurface.swift` (novo)
  - Objetivo: tipos `internal`. Ordem: Reduzir transparencia (solido), Aumentar contraste (solido com stroke `divider`, D7), `#available(iOS 26, macOS 26, *)` com `glassEffect(.regular.tint(...), in:)`, senao `.regularMaterial` (grande) ou `.thinMaterial` (pequeno). O vidro cobre so a superficie, nunca o texto.
  - Validacao: `swift test` passa todos os testes de `resolve`; `xcodebuild` Debug iOS Simulator e macOS compilam.
  - Subtarefa Jira: SCRUM-1767
  - Estado: pending

- [ ] `TASK-004 [P] [US-001]` Aplicar o vidro em `PakitecCard` e `PakitecAlertCard`.
  - Tipo: implementation
  - Repositorio-alvo: pacote
  - Ownership: sdd-implementer
  - Requisitos: FR-004, FR-005, FR-009
  - Criterios: AC-001, AC-002, AC-003
  - Dependencias: TASK-003
  - Arquivos provaveis: `Sources/PakitecSwiftUIComponents/PakitecCard.swift`, `Sources/PakitecSwiftUIComponents/PakitecAlertCard.swift`
  - Objetivo: Card com intensidade `regular`; AlertCard com `strong` e tint do tom. Manter API publica e raio 12.
  - Validacao: `swift test`; `xcodebuild` Debug iOS e macOS.
  - Subtarefa Jira: SCRUM-1768
  - Estado: pending

- [ ] `TASK-005 [P] [US-001]` Aplicar o vidro em `PakitecTabBar`, `PakitecNavigationHeader` e `PakitecToolbarButton`.
  - Tipo: implementation
  - Repositorio-alvo: pacote
  - Ownership: sdd-implementer
  - Requisitos: FR-004, FR-005, FR-009
  - Criterios: AC-001, AC-002, AC-003
  - Dependencias: TASK-003
  - Arquivos provaveis: `Sources/PakitecSwiftUIComponents/PakitecTabBar.swift`, `Sources/PakitecSwiftUIComponents/PakitecNavigationHeader.swift`, `Sources/PakitecSwiftUIComponents/PakitecToolbarButton.swift`
  - Objetivo: TabBar `regular` na barra inteira, com divisor mantido. NavigationHeader com superficie `subtle` opcional, sem mudar o padding (R8). ToolbarButton `subtle` fora de toolbar; dentro de `ToolbarItem` no OS 26 delega ao vidro do sistema (D6, L7).
  - Validacao: `swift test`; `xcodebuild` Debug iOS e macOS.
  - Subtarefa Jira: SCRUM-1769
  - Estado: pending

- [ ] `TASK-006 [P] [US-001]` Aplicar o vidro em `PakitecButton` (`secondary` e `ghost`) e `PakitecBadge`.
  - Tipo: implementation
  - Repositorio-alvo: pacote
  - Ownership: sdd-implementer
  - Requisitos: FR-004, FR-005, FR-009
  - Criterios: AC-001, AC-002, AC-003
  - Dependencias: TASK-003
  - Arquivos provaveis: `Sources/PakitecSwiftUIComponents/PakitecButton.swift`, `Sources/PakitecSwiftUIComponents/PakitecBadge.swift`
  - Objetivo: `primary` e `destructive` seguem solidos (D2). Badge em capsula `subtle`; revisar contraste do texto de 12 pt (R5). Tint leve, sem novo `glassEffect`, quando dentro de Card (R4).
  - Validacao: `swift test`; `xcodebuild` Debug iOS e macOS.
  - Subtarefa Jira: SCRUM-1770
  - Estado: pending

- [ ] `TASK-007 [P] [US-001]` Aplicar o vidro em `PakitecTextField`, `PakitecSecureField` e `PakitecTextEditor`.
  - Tipo: implementation
  - Repositorio-alvo: pacote
  - Ownership: sdd-implementer
  - Requisitos: FR-004, FR-005, FR-009
  - Criterios: AC-001, AC-002, AC-003
  - Dependencias: TASK-003
  - Arquivos provaveis: `Sources/PakitecSwiftUIComponents/PakitecTextField.swift`, `Sources/PakitecSwiftUIComponents/PakitecSecureField.swift`, `Sources/PakitecSwiftUIComponents/PakitecTextEditor.swift`
  - Objetivo: fundo `regular` no lugar de `surfaceElevated`; manter altura minima 48 e `scrollContentBackground(.hidden)`. Em acessibilidade, fundo `surfaceElevated`.
  - Validacao: `swift test` (incluindo `testTextEditorCanBeConstructed`); `xcodebuild` Debug iOS e macOS.
  - Subtarefa Jira: SCRUM-1771
  - Estado: pending

- [ ] `TASK-008 [US-001]` Atualizar `PakitecComponentsPreview` para exibir o vidro.
  - Tipo: implementation
  - Repositorio-alvo: pacote
  - Ownership: sdd-implementer
  - Requisitos: FR-010, NFR-004
  - Criterios: AC-001, AC-002, AC-003, AC-004
  - Dependencias: TASK-004, TASK-005, TASK-006, TASK-007
  - Arquivos provaveis: `Sources/PakitecSwiftUIComponents/PakitecComponentsPreview.swift`
  - Objetivo: fundo colorido ou gradiente atras (R7); variantes claro/escuro; forcar `reduceTransparency`, `increasedContrast` e o ramo Material por parametros do preview; manter um unico `PreviewProvider` (R10).
  - Validacao: `xcodebuild` Debug iOS e macOS compilam; o preview cobre os 8 componentes.
  - Subtarefa Jira: SCRUM-1772
  - Estado: pending

- [ ] `TASK-009 [P] [US-001]` Documentar o Liquid Glass no `README.md`.
  - Tipo: documentation
  - Repositorio-alvo: pacote
  - Ownership: sdd-implementer
  - Requisitos: FR-011, NFR-001, NFR-005
  - Criterios: AC-006
  - Dependencias: TASK-003
  - Arquivos provaveis: `README.md`
  - Objetivo: secao sobre vidro, fallback, acessibilidade, requisito de Xcode 26 ou superior para compilar (R2) e linha de versao 1.1.0 em "Versionamento". Nao tocar em `Package.swift`.
  - Validacao: leitura do README confirma alvos minimos iOS 17 e macOS 14 e texto PT-BR curto.
  - Subtarefa Jira: SCRUM-1773
  - Estado: pending

### Validacao e QA da jornada

- [ ] `TASK-010 [US-001]` Validar build e testes do pacote.
  - Tipo: qa
  - Repositorio-alvo: pacote
  - Ownership: sdd-qa-reviewer
  - Requisitos: NFR-001, NFR-002
  - Criterios: AC-006
  - Dependencias: TASK-008, TASK-009
  - Arquivos provaveis: nenhum (somente comandos)
  - Objetivo: rodar `swift test`; `xcodebuild -scheme PakitecSwiftUIComponents -configuration Debug -destination 'generic/platform=iOS Simulator' build`; mesmo comando com `-destination 'generic/platform=macOS'`.
  - Validacao: 0 falhas; os dois builds concluem; `Package.swift` sem diff.
  - Subtarefa Jira: SCRUM-1774
  - Estado: pending

- [ ] `TASK-011 [US-001]` QA visual do pacote e aprovacao dos tokens (P1).
  - Tipo: qa
  - Repositorio-alvo: pacote
  - Ownership: sdd-qa-reviewer (aprovacao dos valores pelo operador)
  - Requisitos: FR-002, FR-003, FR-006, FR-007, FR-008, FR-009, NFR-003, NFR-004
  - Criterios: AC-001, AC-002, AC-003, AC-004
  - Dependencias: TASK-010
  - Arquivos provaveis: `evidence/SCRUM-1761/manifest.json`, `evidence/SCRUM-1761/SCRUM-1761-AC-001-*.png` a `SCRUM-1761-AC-004-*.png`; ajuste de valores em `Sources/PakitecSwiftUIComponents/PakitecTheme.swift` se a captura reprovar
  - Objetivo: confirmar runtimes com `xcrun simctl list runtimes` (L8). Capturar o preview em iOS 26.x e macOS 26, claro e escuro, com "Reduzir transparencia" e "Aumentar contraste". Aprovar ou ajustar os tokens. Registrar `manifest.json` com SHA-256. Sem OS 26, o QA nao passa (P4).
  - Validacao: uma captura `kind = official` por AC-001 a AC-004, todas com `containsSensitiveData = false`.
  - Subtarefa Jira: SCRUM-1775
  - Estado: pending

**Checkpoint US-001**: `swift test` e os dois `xcodebuild` passam; AC-001 a AC-004 tem evidencia oficial; o operador aprovou os valores dos tokens.

## Fase 3 - US-002 (P1): pacote 1.1.0 publicado

**Objetivo**: a tag `v1.1.0` existe e o pacote mantem os alvos minimos.  
**Teste independente**: `git ls-remote --tags origin v1.1.0` devolve a tag; `swift test` passa na `master`.

- [ ] `TASK-012 [US-002]` Release do pacote: bump 1.1.0, merge, push e tag `v1.1.0`, com confirmacao do operador.
  - Tipo: implementation
  - Repositorio-alvo: pacote
  - Ownership: operador confirma; sdd-implementer executa somente apos a confirmacao
  - Requisitos: FR-011, NFR-001
  - Criterios: AC-006
  - Dependencias: TASK-010, TASK-011
  - Arquivos provaveis: `README.md` (secao "Versionamento"); `.github/workflows/auto-tag.yml` apenas na opcao B
  - Objetivo: executar so no `/sdd-build`. Passo 0: mostrar branch, commits, arquivos do commit (sem `docs/`, `.agents/`, `.claude/`, `AGENTS.md` sem decisao), tags existentes e a tag que cada opcao cria. Passo 1 (checkpoint R1): perguntar A (tag `v1.1.0` manual antes do push e aceitar a tag automatica extra `v1.1.1`), B (ajustar `auto-tag.yml`) ou C (Outra). Nao decidir pelo operador. Passo 2: commit, merge de `feature/liquid-glass` na `master`, push e tag `v1.1.0` na ordem da opcao escolhida.
  - Validacao: `git ls-remote --tags origin` lista `v1.1.0`; `git tag --points-at` confirma o commit; `swift test` passa na `master`; `Package.swift` mantem iOS 17 e macOS 14.
  - Subtarefa Jira: SCRUM-1776
  - Estado: pending

**Checkpoint US-002**: tag `v1.1.0` remota existente (SC-007), `swift test` verde, alvos minimos intactos.

## Fase 4 - US-003 (P2): Liquid Glass no app Joe

**Objetivo**: o Joe resolve o pacote 1.1.0, aplica vidro nas telas e barras, e mantem o Terminal opaco.  
**Teste independente**: compilar o Joe para iOS e macOS e capturar o Terminal e as telas em OS 26 e em OS anterior.

- [ ] `TASK-013 [US-003]` Atualizar a dependencia do pacote para 1.1.0 no Joe.
  - Tipo: implementation
  - Repositorio-alvo: app
  - Ownership: sdd-implementer
  - Requisitos: FR-012, FR-016, NFR-001
  - Criterios: AC-006
  - Dependencias: TASK-012
  - Arquivos provaveis: `Joe.xcodeproj/project.pbxproj` (`minimumVersion` 1.0.5 para 1.1.0), `Joe.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved`
  - Objetivo: alterar `minimumVersion` e rodar `xcodebuild -resolvePackageDependencies`. Conferir por `git diff` que so a entrada do pacote muda (L9). Nao alterar `royalvnc`, `Vendor/SwiftTerm` nem alvos minimos.
  - Validacao: `Package.resolved` mostra `version 1.1.0` e a revisao da tag; `xcodebuild` Debug macOS conclui.
  - Subtarefa Jira: SCRUM-1777
  - Estado: pending

- [ ] `TASK-014 [P] [US-003]` Criar a constante de opacidade do Terminal e o teste.
  - Tipo: test
  - Repositorio-alvo: app
  - Ownership: sdd-implementer
  - Requisitos: FR-015, NFR-002
  - Criterios: AC-005
  - Dependencias: TASK-013
  - Arquivos provaveis: `Joe/Core/TerminalAppearance.swift` (novo; confirmar que `Joe/Core` entra no alvo `JoeCore`), `Tests/TerminalAppearanceTests.swift` (novo)
  - Objetivo: `TerminalAppearance.backgroundOpacity = 1.0` e `minimumBackgroundOpacity = 0.95` (P2, D4). O teste exige `backgroundOpacity >= minimumBackgroundOpacity`.
  - Validacao: `swift test` no app passa (14 testes atuais mais o novo).
  - Subtarefa Jira: SCRUM-1778
  - Estado: pending

- [ ] `TASK-015 [US-003]` Aplicar vidro nas barras e toolbar do Terminal, com fundo opaco.
  - Tipo: implementation
  - Repositorio-alvo: app
  - Ownership: sdd-implementer
  - Requisitos: FR-013, FR-014, FR-015
  - Criterios: AC-005
  - Dependencias: TASK-014
  - Arquivos provaveis: `Joe/Terminal/TerminalScreen.swift`
  - Objetivo: barra de status e barra de teclas de `TerminalScreen` e `ShellScreen` usam vidro por `#available(iOS 26, macOS 26, *)` (por exemplo `.buttonStyle(.glass)` e `GlassEffectContainer`), com fallback `.bordered` e `PakitecTheme.surface`. `nativeBackgroundColor` fica opaco e usa `TerminalAppearance`. Nao editar `Vendor/SwiftTerm`.
  - Validacao: `xcodebuild` Debug iOS e macOS; `swift test`.
  - Subtarefa Jira: SCRUM-1779
  - Estado: pending

- [ ] `TASK-016 [P] [US-003]` Aplicar recursos do OS 26 em `BoardView` e `CardDetailView`.
  - Tipo: implementation
  - Repositorio-alvo: app
  - Ownership: sdd-implementer
  - Requisitos: FR-013, FR-014, FR-016
  - Criterios: AC-006
  - Dependencias: TASK-013
  - Arquivos provaveis: `Joe/Features/BoardView.swift`, `Joe/Features/CardDetailView.swift`
  - Objetivo: colunas macOS (hoje `surface.opacity(0.45)`) com vidro no OS 26; `#available` e fallback para iOS 18 e macOS 14; sheets e toolbars sem vidro duplicado (D6). Preservar `MacLayout`.
  - Validacao: `xcodebuild` Debug iOS e macOS; `MacLayoutMetricsTests` verde.
  - Subtarefa Jira: SCRUM-1780
  - Estado: pending

- [ ] `TASK-017 [P] [US-003]` Aplicar recursos do OS 26 em `CardEditorView`, `GitView` e `JiraImportView`.
  - Tipo: implementation
  - Repositorio-alvo: app
  - Ownership: sdd-implementer
  - Requisitos: FR-013, FR-014, FR-016
  - Criterios: AC-006
  - Dependencias: TASK-013
  - Arquivos provaveis: `Joe/Features/CardEditorView.swift`, `Joe/Features/GitView.swift`, `Joe/Features/JiraImportView.swift`
  - Objetivo: fundos de `Form`/lista e toolbars com o visual do OS 26 e fallback para iOS 18 e macOS 14. `RemoteDesktopView` e `DictationAccessory` ficam fora (D3).
  - Validacao: `xcodebuild` Debug iOS e macOS.
  - Subtarefa Jira: SCRUM-1781
  - Estado: pending

- [ ] `TASK-018 [P] [US-003]` Aplicar recursos do OS 26 em `SupportViews` e, se preciso, no fundo de sheet em `MacLayout`.
  - Tipo: implementation
  - Repositorio-alvo: app
  - Ownership: sdd-implementer
  - Requisitos: FR-013, FR-014, FR-016
  - Criterios: AC-006
  - Dependencias: TASK-013
  - Arquivos provaveis: `Joe/Features/SupportViews.swift`; `Joe/Features/MacLayout.swift` somente para fundo de sheet
  - Objetivo: `SettingsView`, `ArchivedView`, `LogsView` e `MoveView` com barras e toolbars em vidro no OS 26 e fallback. Nao alterar medidas de `MacLayoutMetrics`.
  - Validacao: `xcodebuild` Debug iOS e macOS; `MacLayoutMetricsTests` verde.
  - Subtarefa Jira: SCRUM-1782
  - Estado: pending

- [ ] `TASK-019 [US-003]` Validar build e testes do app.
  - Tipo: qa
  - Repositorio-alvo: app
  - Ownership: sdd-qa-reviewer
  - Requisitos: FR-016, NFR-001, NFR-002
  - Criterios: AC-006
  - Dependencias: TASK-015, TASK-016, TASK-017, TASK-018
  - Arquivos provaveis: nenhum (somente comandos)
  - Objetivo: `swift test`; `xcodebuild` Debug macOS sem assinatura (`CODE_SIGNING_ALLOWED=NO`, `SYMROOT`/`OBJROOT` em `Build/QAMac`); `xcodebuild` Debug iOS Simulator com destino confirmado por `xcrun simctl list devices`.
  - Validacao: 0 falhas; builds concluem; alvos minimos iOS 18 e macOS 14 sem diff.
  - Subtarefa Jira: SCRUM-1783
  - Estado: pending

- [ ] `TASK-020 [US-003]` QA visual do Joe e evidencia do Terminal.
  - Tipo: qa
  - Repositorio-alvo: app (evidencia gravada em `evidence/SCRUM-1761/` do pacote)
  - Ownership: sdd-qa-reviewer
  - Requisitos: FR-013, FR-014, FR-015, NFR-004
  - Criterios: AC-005
  - Dependencias: TASK-019
  - Arquivos provaveis: `evidence/SCRUM-1761/manifest.json`, `evidence/SCRUM-1761/SCRUM-1761-AC-005-*.png`
  - Objetivo: capturar o Terminal em iOS 26.x e macOS 26 (fixture, sem dado pessoal), com vidro nas barras e fundo opaco. Capturar tambem Board, CardDetail, CardEditor, GitView, JiraImport e sheets em OS 26 e em OS anterior, como apoio.
  - Validacao: uma captura `kind = official` para AC-005 no `manifest.json` com SHA-256 e `containsSensitiveData = false`.
  - Subtarefa Jira: SCRUM-1784
  - Estado: pending

**Checkpoint US-003**: o Joe resolve a versao 1.1.0, compila em iOS e macOS, `swift test` e `MacLayoutMetricsTests` passam, e AC-005 tem evidencia oficial.

## Evidencia visual

Criterios para `workflow.visualEvidence.criteria`: `AC-001`, `AC-002`, `AC-003`, `AC-004`, `AC-005`. Cada um exige uma evidencia oficial em `evidence/SCRUM-1761/` (TASK-011 para AC-001 a AC-004; TASK-020 para AC-005). `AC-006` nao tem evidencia visual. O gate de QA bloqueia `QA_PASSED` sem a evidencia oficial ou com o servidor de navegador incompativel.

## Fase final - Polish e validacao

- [ ] Executar os comandos do plano nos dois repositorios (TASK-010 e TASK-019).
- [ ] Confirmar estrutura, documentacao PT-BR e ausencia de overengineering (sem componente novo, sem alvo minimo alterado).
- [ ] Confirmar evidencia oficial publicada para AC-001 a AC-005 e gate de QA satisfeito.

## Resumo de dependencias

| Task | Titulo | Repo | Depende de | [P] |
| --- | --- | --- | --- | --- |
| TASK-001 | Testes de decisao, tokens e construcao | pacote | nenhuma | nao |
| TASK-002 | Tokens de intensidade no PakitecTheme | pacote | TASK-001 | nao |
| TASK-003 | Modificador e funcao de decisao | pacote | TASK-002 | nao |
| TASK-004 | Vidro em Card e AlertCard | pacote | TASK-003 | sim |
| TASK-005 | Vidro em TabBar, NavigationHeader e ToolbarButton | pacote | TASK-003 | sim |
| TASK-006 | Vidro em Button e Badge | pacote | TASK-003 | sim |
| TASK-007 | Vidro em TextField, SecureField e TextEditor | pacote | TASK-003 | sim |
| TASK-008 | Atualizar PakitecComponentsPreview | pacote | TASK-004 a 007 | nao |
| TASK-009 | README com Liquid Glass | pacote | TASK-003 | sim |
| TASK-010 | Validar build e testes do pacote | pacote | TASK-008, 009 | nao |
| TASK-011 | QA visual e aprovacao dos tokens | pacote | TASK-010 | nao |
| TASK-012 | Release: bump, merge, push, tag v1.1.0 (confirmacao) | pacote | TASK-010, 011 | nao |
| TASK-013 | Dependencia 1.1.0 no Joe | app | TASK-012 | nao |
| TASK-014 | Constante e teste de opacidade do Terminal | app | TASK-013 | sim |
| TASK-015 | Vidro nas barras do Terminal | app | TASK-014 | nao |
| TASK-016 | OS 26 em BoardView e CardDetailView | app | TASK-013 | sim |
| TASK-017 | OS 26 em CardEditor, GitView e JiraImport | app | TASK-013 | sim |
| TASK-018 | OS 26 em SupportViews e MacLayout | app | TASK-013 | sim |
| TASK-019 | Validar build e testes do app | app | TASK-015 a 018 | nao |
| TASK-020 | QA visual do Joe e evidencia AC-005 | app | TASK-019 | nao |

## Contrato de cada tarefa

- Tipo: implementation | test | documentation | qa
- Repositorio-alvo: pacote | app
- Ownership: agente responsavel
- Requisitos: `FR-*`, `NFR-*`
- Criterios: `AC-*`
- Dependencias: IDs de tarefa
- Arquivos provaveis:
- Objetivo:
- Validacao:
- Subtarefa Jira: SCRUM-1785
- Estado: pending

Cada tarefa e pequena o bastante para execucao sem redesenhar o plano. Nenhuma tarefa esconde decisao de produto. A unica decisao aberta, a opcao A, B ou C do release (R1), e do operador e fica no passo 1 da TASK-012.
<!-- sdd:section specs.tasks-template:end -->
