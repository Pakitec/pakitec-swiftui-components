# Revisao QA ISSUE-KEY

<!-- sdd:section specs.qa-template:start -->
## Veredito

`PASS`, `FAIL` ou `BLOCKED`.

## Criterios verificados

## Comandos executados

## Evidencias

## Gate de evidencia visual

Aplique este gate somente quando a issue tem requisito de frontend (bloco `visualEvidence` presente no workflow). Issues sem frontend ignoram esta secao.

- Cada criterio `AC-*` visual exige uma evidencia oficial (`kind = official`). Captura `exploratory` ou `failure` nao aprova o criterio.
- O QA nao atinge `PASS` sem a evidencia oficial obrigatoria, nem quando o servidor de navegador esta indisponivel, com versao abaixo de `v0.0.78` ou com tools ausentes. Nesses casos, registre o motivo e marque `BLOCKED`.
- A validacao le os arquivos por caminho seguro em `evidence/<ISSUE-KEY>/`. Caminho com `..`, symlink externo ou arquivo irregular e rejeitado com motivo.
- Nenhum anexo, comentario ou retorno expoe Base64, cookies, headers de autenticacao ou dados pessoais.
- PNG oficial acima de 10 MB permanece local, marcado para nao publicacao, e nunca sobe ao Jira.

Preencha a tabela por criterio visual:

| Criterio | Jornada | Resultado | Evidencia (anexo Jira) |
| --- | --- | --- | --- |
| `AC-XXX` | | | |

## Afericao de custo

O QA preenche esta secao apenas na issue em modo lite. A issue em modo completo mantem a secao em branco.

Registre os numeros medidos:

| Item | Valor |
| --- | --- |
| Subtarefas Jira da issue | |
| Tempo de build: intervalo entre `buildStartedAt` e `buildFinishedAt` do `workflow.json` | |
| Linha de base usada | |
| Veredito contra o `NFR-001` | |

A referencia de linha de base da issue e 12 subtarefas e cerca de 5 h de build no SCRUM-989.

Numeros brutos do repositorio para conferencia: o SCRUM-975 tem 13 subtarefas e 9 h 22 min de build; o SCRUM-989 tem 12 subtarefas e 5 h 11 min de build.

Escreva o veredito contra o `NFR-001`: no lite, a issue usa no maximo 6 subtarefas (metade de 12) e no maximo metade do tempo de build da tarefa comparavel.

O metodo segue a premissa P2: compare com o custo do modo completo em tarefa comparavel. Registre o metodo no QA das 3 primeiras issues lite. A premissa e reversivel.

## Problemas bloqueantes

## Problemas nao bloqueantes

## Riscos residuais

Somente `PASS` autoriza conclusao da issue principal.
<!-- sdd:section specs.qa-template:end -->
