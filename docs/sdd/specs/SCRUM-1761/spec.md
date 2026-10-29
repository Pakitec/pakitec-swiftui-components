# Feature Specification: SCRUM-1761

<!-- sdd:section specs.spec-template:start -->
**Issue**: `SCRUM-1761`  
**Status**: Draft  
**Input**: Jira validado pelo refinement gate (`REFINEMENT_GATE: PASS`, hash `e597739b75dd30963c23b108990046c1c12e98356430d4755dfcb03d54e5cacf`)

## Objetivo

Dar aos apps Pakitec a aparencia nativa do iOS 26 e do macOS 26, com superficies em Liquid Glass moderado. O efeito deve ser perceptivel, mas o tema nunca fica totalmente transparente. O texto continua legivel nos temas claro e escuro.

A Task cobre dois repositorios, em sequencia:

- Parte 1: pacote `pakitec-swiftui-components`, publicado na versao 1.1.0.
- Parte 2: app `pakitec-joe-app` (Joe), que consome o pacote na versao 1.1.0.

Em sistemas anteriores ao 26, as superficies usam Material, sem perder a identidade visual.

## Usuarios e Cenarios

Ator: pessoa que usa os apps Pakitec (iOS e macOS). Ator secundario: pessoa da equipe que consome o pacote.

### US-001 - Superficies de vidro nos componentes do pacote (P1)

A pessoa que usa um app Pakitec ve Card, AlertCard, TabBar, NavigationHeader, ToolbarButton, Button, Badge e campos de entrada com fundo em vidro. O vidro cobre a superficie, nunca o texto. Sistemas sem suporte ao vidro mostram Material. Quem ativa "Reduzir transparencia" ou "Aumentar contraste" ve fundo solido ou Material.

**Por que P1**: entrega o valor central da issue e e base da Parte 2.  
**Teste independente**: abrir `PakitecComponentsPreview` nos temas claro e escuro, em OS 26 e em OS anterior, com e sem as opcoes de acessibilidade, e comparar as capturas.

**Cenarios de aceite**:

1. `AC-001` - **Dado** um dispositivo ou simulador com iOS 26 ou superior, ou macOS 26 ou superior, **quando** um componente com vidro e exibido, **entao** a superficie usa o efeito nativo de Liquid Glass (`glassEffect`) e nao fica totalmente transparente (opacidade visivel maior que zero, comprovada por captura).
2. `AC-002` - **Dado** um dispositivo ou simulador com iOS 17 a 25, ou macOS 14 a 25, **quando** o componente e exibido, **entao** a superficie usa `.regularMaterial` ou `.thinMaterial`.
3. `AC-003` - **Dado** o tema claro ou o tema escuro, **quando** ha texto sobre o vidro, **entao** o texto permanece legivel, comprovado por capturas oficiais nos dois temas.
4. `AC-004` - **Dado** "Reduzir transparencia" ou "Aumentar contraste" ligado, **quando** a superficie e exibida, **entao** ela usa fundo solido ou Material, sem vidro translucido.

### US-002 - Pacote 1.1.0 compativel e publicado (P1)

A pessoa da equipe atualiza o pacote para a versao 1.1.0 sem perder compatibilidade com os sistemas atualmente suportados. A versao fica disponivel por tag para o app Joe.

**Por que P1**: sem a tag `v1.1.0` a Parte 2 nao inicia.  
**Teste independente**: rodar `swift test` e `xcodebuild` Debug do pacote para iOS e macOS; conferir os alvos minimos declarados e a existencia da tag.

**Cenarios de aceite**:

1. `AC-006` - **Dado** o pacote com Liquid Glass aplicado, **quando** o build termina, **entao** os alvos minimos seguem iOS 17 e macOS 14 (no app Joe: iOS 18 e macOS 14) e `swift test` passa.

### US-003 - Liquid Glass no app Joe, com Terminal legivel (P2)

A pessoa que usa o Joe ve o vidro em Board, CardDetail, CardEditor, GitView, JiraImport, Terminal, sheets, barras e toolbars. A diferenca de layout entre iOS e macOS (`MacLayout`) permanece. No Terminal, o fundo e opaco ou quase opaco. O vidro aparece so nas barras e toolbars ao redor.

**Por que P2**: depende da tag `v1.1.0` (US-002) e entrega o valor ao app final.  
**Teste independente**: compilar o Joe para iOS e macOS e capturar o Terminal e as demais telas em OS 26 e em OS anterior.

**Cenarios de aceite**:

1. `AC-005` - **Dado** o Terminal do Joe, **quando** ele e exibido, **entao** o fundo e opaco ou quase opaco, comprovado por captura oficial. O valor minimo de opacidade e definido no plano.

## Requisitos funcionais

- `FR-001`: O pacote oferece uma superficie em vidro reutilizavel, de uso interno, para os componentes.
- `FR-002`: Em iOS 26 e macOS 26 ou superior, a superficie usa `glassEffect` (`AC-001`).
- `FR-003`: Em iOS 17 a 25 e macOS 14 a 25, a superficie usa `.regularMaterial` ou `.thinMaterial` (`AC-002`).
- `FR-004`: O vidro se aplica a Card, AlertCard, TabBar, NavigationHeader, ToolbarButton, Button, Badge e campos de entrada.
- `FR-005`: O vidro se aplica a superficie e nunca ao texto.
- `FR-006`: Tokens do `PakitecTheme` controlam a intensidade do vidro. Os valores iniciais vem do plano e sao aprovados por captura nos temas claro e escuro.
- `FR-007`: O vidro nunca deixa o tema totalmente transparente (`AC-001`).
- `FR-008`: Com "Reduzir transparencia" ou "Aumentar contraste" ligado, a superficie usa fundo solido ou Material (`AC-004`). O plano escolhe a opcao.
- `FR-009`: O texto sobre o vidro permanece legivel nos temas claro e escuro (`AC-003`).
- `FR-010`: `PakitecComponentsPreview` e os testes do pacote refletem as superficies em vidro.
- `FR-011`: O pacote sobe para a versao 1.1.0, com tag `v1.1.0`, e os alvos minimos continuam iOS 17 e macOS 14 (`AC-006`).
- `FR-012`: O app Joe atualiza a dependencia do pacote de 1.0.5 para 1.1.0 em `Joe.xcodeproj` e `Package.resolved`.
- `FR-013`: O app Joe aplica recursos do iOS 26 e macOS 26 em Board, CardDetail, CardEditor, GitView, JiraImport e Terminal, alem de sheets, barras e toolbars. Em sistemas anteriores, usa o fallback para iOS 18 e macOS 14.
- `FR-014`: O app Joe preserva a diferenca de layout entre iOS e macOS (`MacLayout`).
- `FR-015`: No Terminal do Joe, o fundo e opaco ou quase opaco. O vidro aparece so em barras e toolbars ao redor (`AC-005`).
- `FR-016`: O app Joe mantem os alvos minimos iOS 18 e macOS 14 (`AC-006`).

## Requisitos nao funcionais

- `NFR-001`: Compatibilidade. Nenhum alvo minimo sobe: pacote em iOS 17 e macOS 14; app em iOS 18 e macOS 14.
- `NFR-002`: Qualidade. `swift test` passa sem falhas no pacote, e o `xcodebuild` Debug do Joe conclui para iOS e macOS.
- `NFR-003`: Acessibilidade. Cada componente com vidro respeita "Reduzir transparencia" e "Aumentar contraste".
- `NFR-004`: Verificabilidade visual. Cada criterio visual (`AC-001` a `AC-005`) tem ao menos uma captura oficial, validada em OS 26 quando o criterio exige o vidro nativo.
- `NFR-005`: Documentacao. Comentarios e docs do codigo seguem o padrao PT-BR da constituicao.

## Entidades e Dados

- `PakitecTheme`: conjunto de tokens de cor e intensidade do vidro. Os valores variam por tema (claro e escuro). Nao guarda dado sensivel.
- Superficie em vidro: modificador interno do pacote, sem estado persistido.
- Componentes afetados (pacote): Card, AlertCard, TabBar, NavigationHeader, ToolbarButton, Button, Badge, campos de entrada.
- Telas afetadas (Joe): Board, CardDetail, CardEditor, GitView, JiraImport, Terminal, sheets, barras e toolbars.
- Versao do pacote: de 1.0.5 para 1.1.0, com tag `v1.1.0`.
- Nao ha dado pessoal, credencial ou contrato de API novo.

## Edge Cases

- Sistema anterior ao 26: a superficie usa Material, sem chamar `glassEffect`.
- "Reduzir transparencia" ligado: nenhuma superficie fica translucida.
- "Aumentar contraste" ligado: a superficie usa fundo solido ou Material, com contraste suficiente.
- Texto sobre fundo muito claro ou muito escuro: o texto continua legivel nos dois temas.
- Vidro sobre vidro (por exemplo, Button dentro de Card): o resultado continua legivel.
- Terminal: o conteudo do terminal nunca perde contraste por causa do vidro das barras.
- Layout macOS e iOS: `MacLayout` nao regride.
- Fundo atras do vidro varia (imagem, cor, lista rolando): a legibilidade se mantem.
- Falta de simulador ou dispositivo com OS 26: o QA visual de `AC-001` nao passa (premissa P4).

## Criterios de sucesso

- `SC-001`: Em OS 26, 100% dos componentes listados em `FR-004` exibem o vidro nativo e nao ficam totalmente transparentes, comprovado por captura.
- `SC-002`: Em OS anterior ao 26, 100% dos mesmos componentes exibem Material, comprovado por captura.
- `SC-003`: Nos temas claro e escuro, 100% dos textos sobre vidro ficam legiveis nas capturas oficiais.
- `SC-004`: Com "Reduzir transparencia" ou "Aumentar contraste" ligado, 0 superficies ficam translucidas.
- `SC-005`: No Terminal do Joe, o fundo e opaco ou quase opaco, e o conteudo do terminal permanece legivel.
- `SC-006`: `swift test` passa com 0 falhas, os alvos minimos permanecem os mesmos e o `xcodebuild` Debug do Joe conclui para iOS e macOS.
- `SC-007`: A tag `v1.1.0` existe antes do inicio da Parte 2, e o Joe resolve o pacote na versao 1.1.0.

## Escopo

Dentro do escopo:

- Parte 1: pacote `pakitec-swiftui-components` (superficie em vidro, tokens, componentes, preview, testes, bump 1.1.0, merge de `feature/liquid-glass` na `master`, publicacao e tag `v1.1.0`).
- Parte 2: app `pakitec-joe-app` (dependencia 1.1.0, recursos do iOS 26 e macOS 26 nas telas, barras e toolbars, fallback e Terminal).

## Fora de escopo

- Regra de negocio do Joe, backend e mudanca de alvos minimos.
- Vidro aplicado ao texto.
- Terminal com fundo em vidro translucido.
- Novos componentes ou novas telas.
- Merge, push e criacao de tag fora do `/sdd-build`, ou sem confirmacao.

## Dependencias

- Parte 2 depende da tag `v1.1.0` publicada no GitHub (Parte 1).
- Validacao visual real exige simulador ou dispositivo com OS 26 (Xcode 27.1).
- Acesso aos dois repositorios, autorizado pela equipe nesta Task (workspace Jira unico: este pacote).
- Biblioteca SwiftTerm no Terminal do Joe (ja existente).

## Premissas

Todas sao reversiveis e aceitas no refinement.

- `P1`: Os valores dos tokens de intensidade sao propostos no plano e aprovados por captura.
- `P2`: A opacidade minima do fundo do Terminal e proposta no plano e aprovada por captura.
- `P3`: A Parte 2 inicia somente apos a tag `v1.1.0`, na mesma Task `SCRUM-1761`.
- `P4`: A validacao visual exige simulador ou dispositivo com OS 26. Sem ele, o QA visual nao passa.
- `P5`: Os criterios AC-1 a AC-6 foram enviados ao campo `customfield_10000`, mas a leitura da issue nao os retorna. O `issue.md` e a fonte. Esta spec os renumera como `AC-001` a `AC-006`.
- `P6`: Merge, push e tag acontecem so no `/sdd-build`, com confirmacao.
- `P7`: Com "Aumentar contraste", a superficie usa fundo solido ou Material. O plano escolhe.

## Rastreabilidade

- Issue Jira: `SCRUM-1761`. Gate: `REFINEMENT_GATE: PASS`, hash `e597739b75dd`.
- Renumeracao: AC-1 -> `AC-001`, AC-2 -> `AC-002`, AC-3 -> `AC-003`, AC-4 -> `AC-004`, AC-5 -> `AC-005`, AC-6 -> `AC-006`.
- Criterios visuais (evidencia oficial): `AC-001` a `AC-005`. `AC-006` e de build e teste, sem evidencia visual.

| FR | US | Cenario | SC |
| --- | --- | --- | --- |
| FR-001, FR-002, FR-007 | US-001 | AC-001 | SC-001 |
| FR-003 | US-001 | AC-002 | SC-002 |
| FR-004, FR-005, FR-006, FR-009 | US-001 | AC-003 | SC-003 |
| FR-008 | US-001 | AC-004 | SC-004 |
| FR-010, FR-011 | US-002 | AC-006 | SC-006, SC-007 |
| FR-012, FR-013, FR-014 | US-003 | AC-005, AC-006 | SC-005, SC-006, SC-007 |
| FR-015 | US-003 | AC-005 | SC-005 |
| FR-016 | US-003 | AC-006 | SC-006 |

## Clarificacoes

Nenhuma marcacao `[NEEDS CLARIFICATION]` pode permanecer numa spec aprovada. Esta spec nao tem lacunas abertas.

## Gate da Spec

`READY` somente com `checklist.md` aprovado.
<!-- sdd:section specs.spec-template:end -->
