# Revisao QA SCRUM-1761

## Veredito

`PASS` (ciclo 2 de 3). O bloqueio do ciclo 1 (EvidenceUITests no pbxproj) foi corrigido.

Historico: ciclo 1 = FAIL (4 entradas de EvidenceUITests.swift no pbxproj do app).

## Criterios verificados

- AC-001: `glassEffect(.regular.tint(...))` sob `#available(iOS 26, macOS 26, *)` em `PakitecGlassSurface.swift`; 4 capturas oficiais (iOS 26.5 e macOS 26.6, claro e escuro). OK.
- AC-002: Material (`regularMaterial`/`thinMaterial`) no ramo `.material`; 2 capturas com Material forcado (aproximacao aceita pelo operador). OK com ressalva aceita.
- AC-003: 2 capturas oficiais de legibilidade (claro/escuro). OK.
- AC-004: modos `solid`/`solidWithStroke` primeiro na ordem de resolucao; 4 capturas oficiais (Reduzir transparencia e Aumentar contraste, 2 temas). OK.
- AC-005: `TerminalAppearance.backgroundOpacity = 1.0` (piso 0.95, coberto por teste), aplicado nos dois `NativeTerminalView`; vidro so em `terminalBar`, `terminalKeyStyle` e `GlassEffectContainer`; 1 captura oficial iOS 26.1 (macOS 26 nao capturado, aceito). OK.
- AC-006 / NFR-001: pacote iOS 17/macOS 14 e app iOS 18/macOS 14 inalterados (Package.swift, project.yml, pbxproj). OK.
- FR-012 / SC-007: tag anotada `v1.1.0` no pacote e no origin, resolve para 7c9418a, igual ao `Package.resolved` do app (1.1.0). OK.
- FR-013/014: fallback `#available(iOS 26, macOS 26, *)` em BoardView e TerminalScreen; `MacLayout` intocado. OK.
- NFR-005: comentarios novos em PT-BR (alguns sem acento, mesmo padrao do codigo existente).
- Seguranca: manifesto sem dado sensivel (`containsSensitiveData: false`), sem segredos no diff.

## Comandos executados

- Pacote: `swift test` -> 26 testes, 0 falhas.
- App: `swift test` -> 123 testes, 0 falhas (esperado atingido).
- `git status` do app apos os testes: sem alteracao nova em Package.resolved/pbxproj.
- `sdd_visual_evidence_validate` do manifesto: 15 de 15 `accepted` (13 official, 2 exploratory).
- xcodebuild do app nao foi reexecutado (restricao de nao alterar pbxproj/Package.resolved); confio no build do orquestrador.

## Evidencias

Ver manifesto `evidence/SCRUM-1761/manifest.json` e anexos Jira 10416-10428, comentario 15638.

## Gate de evidencia visual

O preflight do Playwright MCP nao esta disponivel para este agente (limitacao do ambiente). As evidencias sao capturas nativas de simulador/macOS, ja validadas e publicadas; nenhuma captura oficial faltante.

| Criterio | Jornada | Resultado | Evidencia (anexo Jira) |
| --- | --- | --- | --- |
| `AC-001` | PakitecComponentsPreview iOS 26.5 e macOS 26.6, claro/escuro | Aprovado | 10416-10428 |
| `AC-002` | Material forcado, claro/escuro | Aprovado (aproximacao aceita) | 10416-10428 |
| `AC-003` | Legibilidade claro/escuro | Aprovado | 10416-10428 |
| `AC-004` | Reduzir transparencia / Aumentar contraste | Aprovado | 10416-10428 |
| `AC-005` | Terminal do Joe iOS 26.1 | Aprovado | 10416-10428 |

## Afericao de custo

Nao se aplica (issue em modo completo).

## Problemas bloqueantes

Nenhum. Ciclo 2: pbxproj com 0 ocorrencias de EvidenceUITests; `UITests/` contem apenas JoeUITestCase.swift, JoeUITests.swift e OpenClaudeUITests.swift; TerminalAppearance.swift segue registrado (4 referencias); xcodebuild Debug macOS e iOS Simulator com BUILD SUCCEEDED (orquestrador); Package.resolved com pin 1.1.0 esperado.

## Problemas nao bloqueantes

1. `Package.swift` do app move `Features/AppleDictationRecognizer.swift` de `exclude` para `sources`, mudanca nao relacionada a SCRUM-1761 e sem justificativa registrada; os 123 testes passam. Nao bloqueante por decisao do operador; sera justificado no commit.
2. pbxproj: correcao de indentacao de `CURRENT_PROJECT_VERSION` (ruido, inofensivo).
3. Desvio das TASK-013 a 018 feito manualmente pelo orquestrador: diff revisado, sem defeitos de logica alem dos itens acima.
4. CardEditor e JiraImport sem alteracao de codigo no app; recebem o vidro pelos componentes do pacote 1.1.0 (coerente com FR-013).

## Riscos residuais

- macOS 26 sem captura do Terminal; AC-002 sem runtime pre-OS 26 (ambos aceitos pelo operador).
- Build xcodebuild do app (iOS e macOS) nao reconfirmado por este QA.

Somente `PASS` autoriza conclusao da issue principal.
