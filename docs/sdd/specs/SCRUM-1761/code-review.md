# Revisao de Codigo SCRUM-1761

Revisao final consultiva executada apos `QA: PASS`, via Open Code Review em modo delegation. Consultiva: registra achados para analise, nunca bloqueia a conclusao da issue.

## Status

`REVIEWED`

## Comandos OCR executados

- `npx -y @alibaba-group/open-code-review delegate preview` (pacote, selecao de arquivos). A selecao incluiu os `.swift`, o workflow e o README. Docs e binarios foram excluidos pelo OCR.
- A primeira tentativa com `timeout` falhou porque o comando nao existe no macOS. Foi repetida sem ele e funcionou.
- O comando `delegate rule` nao foi executado. As regras foram aplicadas manualmente com Read, Grep e `git diff`.

## Arquivos revisados

Pacote (commit 7c9418a contra cf8443f): `.github/workflows/auto-tag.yml`, `README.md`, `PakitecGlassSurface.swift`, `PakitecTheme.swift`, `PakitecButton.swift`, `PakitecBadge.swift`, `PakitecToolbarButton.swift`, `PakitecNavigationHeader.swift`, `PakitecTextField.swift` e os demais componentes do diff.

App Joe (feature/liquid-glass, nao commitado): `BoardView.swift`, `CardDetailView.swift`, `GitView.swift`, `SupportViews.swift`, `Terminal/TerminalScreen.swift`, `Package.swift`, `project.yml`, `Core/TerminalAppearance.swift`, `Tests/TerminalAppearanceTests.swift`.

## Achados por severidade

### Critical

Nenhum.

### High

Nenhum.

### Medium

1. `pakitec-joe-app/Package.swift`: `Features/AppleDictationRecognizer.swift` saiu de `exclude` e entrou em `sources` do alvo JoeCore. A mudanca nao faz parte do escopo visual da issue. O arquivo pode depender de Speech/AVFoundation e quebrar `swift test` em alguma plataforma. Recomendacao: confirmar que e intencional e que `swift test` passa em macOS e iOS, ou reverter.
2. `PakitecGlassSurface.swift`, `body` modo `.solidWithStroke`: com "Aumentar contraste" o fundo e solido, mas o modo `.glass` e o modo `.material` nao tem stroke. Isso e o comportamento desejado. O que falta e um teste de integracao do `resolve` com o `glassAvailable` real, porque os testes cobrem so a funcao pura. Recomendacao: manter a evidencia visual do QA como cobertura do ramo OS 26.

### Low

1. `PakitecGlassSurface.swift` `glass(_:opacity:)`: o `else` de `#available(iOS 26, macOS 26, *)` e inalcancavel, pois `mode == .glass` so ocorre com OS 26. Codigo morto inofensivo.
2. `PakitecBadge.swift`: o padding horizontal passou de 2 para `PakitecSpacing.small`. E mudanca de layout visivel mesmo no badge neutro. Recomendacao: confirmar com o design.
3. `PakitecBadge.swift`: o texto usa a mesma cor do tint do fundo. Em `.subtle` com 6 a 8 por cento de opacidade o contraste tende a ser bom, mas `warning` (laranja) sobre claro e limitrofe. Recomendacao: validar o contraste de `warning` em modo claro.
4. `.github/workflows/auto-tag.yml`: se a tag manual for enviada depois do push da master, o workflow pode rodar antes e criar uma tag patch extra. A janela de corrida e pequena. Recomendacao: documentar a ordem (tag antes do push, ou push com a tag junto).
5. `pakitec-joe-app/Joe/Core/TerminalAppearance.swift` e `Tests/TerminalAppearanceTests.swift`: o teste compara duas constantes, entao nao detecta se o `TerminalScreen` deixar de usar a constante. `withAlphaComponent(1.0)` e um no-op. Alem disso, `BoardView.boardColumnSurface` tem comentario "no macOS", mas o codigo vale tambem para iOS 26. Recomendacao: corrigir o comentario.

## Observacoes

Esta etapa nao bloqueia `BUILD_COMPLETED`. Achados `critical`/`high` sao alertas para analise humana e devem virar novas tarefas quando pertinentes. Contagem: critical 0, high 0, medium 2, low 5.
