---
name: sdd-build
description: Executar um planejamento SDD aprovado, sincronizando subtarefas Jira e QA.
argument-hint: <ISSUE-KEY> [--parallel]
allowed-tools: Read, Glob, Grep, Bash, Write, Edit mcp__pakitec-cloud-mcp__jira_get_workspace_binding, mcp__pakitec-cloud-mcp__jira_list_profiles, mcp__pakitec-cloud-mcp__jira_bind_workspace, mcp__pakitec-cloud-mcp__jira_get_issue, mcp__pakitec-cloud-mcp__jira_list_attachments, mcp__pakitec-cloud-mcp__jira_edit_task, mcp__pakitec-cloud-mcp__jira_record_sdd_event, mcp__pakitec-cloud-mcp__jira_move_to_active_sprint, jira_get_workspace_binding, jira_list_profiles, jira_bind_workspace, jira_get_issue, jira_list_attachments, jira_edit_task, jira_record_sdd_event, jira_move_to_active_sprint
---

<!-- sdd:section command.sdd-build:start -->
Voce esta executando `/sdd-build` para implementar uma issue Jira planejada. Entrada: `$ARGUMENTS`.

O `workflow.json` tem um unico escritor por fase: o agente que assume o papel de orquestrador — o agente principal do comando, ou o `sdd-orchestrator` quando a fase foi delegada a ele. Apos delegar uma fase, o comando nao escreve `workflow.json` ate o retorno; dados produzidos pelo delegado voltam no resultado e sao persistidos por um unico escritor.

Fluxo multi-projeto (opcional, ativado apenas com dois ou mais workspaces vinculados). Enquanto houver um unico workspace vinculado, este bloco nao muda nada: siga o fluxo padrao do comando sem qualquer alteracao.

Vocabulario:

- Grupo: uma mesma feature que atravessa dois ou mais projetos (por exemplo backend, frontend e uma biblioteca de componentes). Cada projeto participante vira UMA Task Jira top-level propria. Subtarefa exige o mesmo projeto do pai, portanto o grupo usa tasks separadas, linkadas nativamente no Jira via `jira_link_issues` (`Relates`) e unidas pelo label compartilhado, nunca subtarefas entre projetos.
- `groupId`: identificador estavel do grupo no formato `grp-<YYYYMMDD>-<slug-curto>`. O mesmo valor aparece no label `sdd-group:<groupId>` de todas as tasks e no `group.json` de cada membro.
- Membro: um par `{ projeto Jira, workspace }` que participa do grupo, com um `role` curto e humano (`backend`, `frontend`, `components`).

MULTI_GATE (deteccao — execute depois do `JIRA_GATE` e antes de agir):

1. Liste os workspaces abertos na sessao (os roots do cliente). Para cada um, chame `jira_get_workspace_binding` com o `workspacePath` absoluto.
2. Conte os workspaces com vinculo Jira habilitado (perfil + projeto validos).
   - 0 ou 1 vinculado: MODO SINGLE. Ignore todo o restante deste bloco e siga o fluxo padrao do comando, sem alteracao.
   - 2 ou mais vinculados: MODO MULTI candidato. Nao ative automaticamente. Apresente os projetos detectados e pergunte se esta feature deve ser distribuida entre eles. Sem confirmacao explicita, permaneca em MODO SINGLE usando o workspace escolhido pelo usuario.
3. Em MODO MULTI, confirme com o usuario a lista final de membros (default: todos os vinculados) e a `order` entre eles. A ordem e sequencial e reflete dependencia: tipicamente o projeto que define o contrato/API vem antes dos consumidores.

`group.json` (um por spec, gravado em `docs/sdd/specs/<ISSUE-KEY>/group.json` de cada membro):

```json
{
  "groupId": "grp-20260819-checkout",
  "createdAt": "<ISO-8601 com timezone>",
  "order": ["BACK-12", "FRONT-8"],
  "members": [
    { "project": "BACK", "issueKey": "BACK-12", "workspacePath": "/abs/backend", "role": "backend" },
    { "project": "FRONT", "issueKey": "FRONT-8", "workspacePath": "/abs/frontend", "role": "frontend" }
  ]
}
```

Regras do manifesto:

- Todos os membros compartilham exatamente o mesmo `groupId`, o mesmo array `order` e a mesma lista `members`; apenas o arquivo vive dentro de cada workspace.
- `order` lista as issueKeys na ordem de execucao. `members` descreve cada par projeto/workspace com `project`, `issueKey`, `workspacePath` absoluto e `role`.
- Grave o `group.json` de todos os membros somente depois que TODAS as tasks do grupo foram criadas e suas chaves confirmadas.

Descoberta de peers (execute quando o comando recebe uma issueKey):

1. Procure `docs/sdd/specs/<ISSUE-KEY>/group.json` no workspace atual.
2. Sem arquivo, ou arquivo sem a issueKey recebida em `members`: a issue NAO pertence a nenhum grupo. Siga o fluxo single padrao, sem alteracao.
3. Com arquivo valido: confirme que cada membro em `members` ainda e alcancavel — o workspace existe e `jira_get_issue` retorna a issue no projeto esperado. Membro inacessivel bloqueia o modo multi; relate e pare antes de agir.

FANOUT (execucao de fase em MODO MULTI):

- Itere `order` de forma sequencial. Para cada issueKey, execute o fluxo single COMPLETO deste comando dentro do workspace do membro correspondente: seu proprio binding, seu proprio `docs/sdd/specs/<KEY>/`, seus proprios agentes. Um membro so inicia depois que o anterior concluiu com sucesso.
- Cada membro e uma execucao single independente e idempotente: retomar o grupo nao repete membros ja concluidos.
- Falha ou bloqueio em um membro interrompe o grupo imediatamente, preservando os membros ja concluidos. Relate qual membro bloqueou e o motivo e nao inicie os membros seguintes.
- Ao final, consolide um resumo com uma linha por membro: issueKey, projeto, status final e observacao curta.

Contexto de execucao do Pakitec Pilot:

- No inicio do comando, leia uma unica vez as variaveis `PAKITEC_SDD_PHASE`, `PAKITEC_SDD_RUNNER`, `PAKITEC_SDD_MODEL`, `PAKITEC_SDD_MODEL_LABEL` e `PAKITEC_SDD_EXECUTION_ID` usando `printenv` sem imprimir outros valores do ambiente.
- Monte `executionContext` somente com os valores nao vazios: `phase`, `runner`, `model`, `modelLabel` e `executionId`.
- Inclua esses mesmos campos em toda chamada `jira_record_sdd_event`, qualquer que seja o tipo do evento.
- Ao delegar um agente que possa registrar eventos Jira, inclua `executionContext` no prompt da delegacao e ordene que ele o preserve sem alteracoes em todas as chamadas.
- Se as variaveis nao existirem (execucao fora do Pilot), omita os campos; isso nao bloqueia o fluxo.

Classificacao de porte (modo lite ou modo completo). O fluxo avalia a issue depois do `REFINEMENT_GATE: PASS` e decide o modo sozinho. A decisao e automatica: nunca pergunte ao operador qual modo usar.

Vocabulario:

- Modo lite: caminho reduzido de planejamento e build para tarefa pequena.
- Modo completo: caminho vigente, com todos os artefatos e subtarefas de fase.
- Gatilho de risco: condicao que obriga o modo completo.
- MODO SINGLE: um unico modulo ou workspace na issue.
- MODO MULTI: dois ou mais workspaces vinculados na sessao.

O modo lite exige TODOS os limites abaixo:

- Ate 3 arquivos de producao. Arquivos de teste nao contam no limite. Espelhos regenerados pelo `sdd_init apply` tambem nao contam, porque nao sao arquivos-fonte editados a mao.
- Um unico modulo ou workspace (MODO SINGLE).
- Nenhum gatilho de risco.
- Tipo de mudanca aceito.

Tipos de mudanca aceitos no modo lite:

- Mudanca de componente.
- Bump de versao.
- Texto ou documentacao.
- Ajuste pontual sem comportamento novo.
- Correcao de bug apenas com causa local identificada e sem mudanca de contrato, de regra de negocio ou de permissao.

Gatilhos de risco. Qualquer um mantem o modo completo:

- Informacao insuficiente ou ambigua.
- Regra de negocio.
- Contrato de API.
- Dependencia nova.
- Dado sensivel.
- Requisito visual.
- Mais de um modulo ou workspace. MODO MULTI nunca e lite.
- Quatro ou mais arquivos de producao.

Duvida residual sobre o porte mantem o modo completo. O modo completo e o padrao: sem certeza sobre os limites, nao aplique o lite.

Decisao de porte, aplicada no planejamento apos o `REFINEMENT_GATE: PASS`:

| Condicao | Resultado |
| --- | --- |
| Ate 3 arquivos de producao, MODO SINGLE, tipo aceito e nenhum gatilho de risco | `mode: "lite"` |
| Bug com causa local identificada e sem mudanca de contrato, de regra ou de permissao, dentro dos demais limites | `mode: "lite"` |
| Qualquer gatilho de risco ou duvida | `mode: "full"`, com o motivo em `modeReason` |

Registro do modo:

- `workflow.json`: grave o campo `mode` com `"lite"` ou `"full"` e o campo `modeReason` com o motivo curto da classificacao ou do escalonamento. Um unico escritor por fase grava os campos.
- Issue pai: registre o evento `PHASE_STARTED` com o modo e o motivo no `summary`, no formato `Modo <lite|completo>: <motivo>`. Na classificacao, use o `eventKey` `<ISSUE>/plan/<hash12>/mode`; no escalonamento, `<ISSUE>/<runId>/r<revision>/build/mode`.
- `BUILD_COMPLETED`: inclua a linha `Modo: <lite|completo>` no resumo textual. No escalonamento, inclua tambem o motivo.

Artefatos e subtarefas por modo:

| Item | Modo completo | Modo lite |
| --- | --- | --- |
| `issue.md`, `spec.md` e `checklist.md` | cria | cria, com a `spec.md` curta |
| `research.md` | cria | nao cria |
| `plan.md`, `tasks.md`, `qa.md`, `code-review.md`, `workflow.json` e `assets/` | cria | cria |
| Subtarefas fixas `[SDD][SPEC] Specification`, `[SDD][RESEARCH] Technical Research` e `[SDD][PLAN] Technical Plan` | cria | nao cria |
| Subtarefas `[SDD][TASK-*]` e `[SDD][QA] Quality Review` | cria | cria |

Os artefatos ficam na pasta de specs da issue, identificada pela chave no Jira. No modo lite, o bloco `hashes` do `workflow.json` omite `research`, porque o `research.md` nao existe.

Gates. O modo lite mantem todos os gates vigentes:

- `JIRA_GATE` valido e eventos Jira confirmados; nenhuma fase avanca sem o evento confirmado.
- Validacoes do projeto executadas e `QA: PASS` antes da conclusao.
- Revisao de codigo consultiva depois do QA, que nunca bloqueia a conclusao.

Escalonamento de modo lite para modo completo:

- No build ou no QA, detecte o escopo maior. Sinais: mais arquivos de producao que o limite, mais de um modulo ou workspace, ou qualquer gatilho de risco.
- Interrompa o lite: grave `mode: "full"`, anexe o novo motivo ao `modeReason` e registre o evento `PHASE_STARTED` no pai com o resumo `Escalonamento lite para completo: <motivo>`.
- Siga em modo completo. Nunca exija retroativamente os artefatos pulados: o escalonamento nao cria o `research.md` nem as subtarefas fixas de fase.

Proibicoes:

- O modo resulta apenas da classificacao automatica. Nao existe override manual do operador nem de agente.
- Escalonar de lite para completo e permitido. Rebaixar um fluxo completo para lite nao e.
- A ausencia do campo de modo equivale ao modo completo. Workflow sem `mode` retoma como completo, sem migracao manual.

Regras obrigatorias:

1. Extraia exatamente uma chave `PROJ-123`. Reconheca a flag opcional `--parallel` em `$ARGUMENTS` (ausencia = execucao sequencial, que e o default) e persista a escolha em `workflow.json` como `buildConcurrency` (`sequential` ou `parallel`) para retomadas deterministas; em FANOUT multi-projeto a flag vale para todos os membros. Antes do `JIRA_GATE`, execute a descoberta de peers do bloco multi-projeto: se a chave pertencer a um grupo, aplique o FANOUT e implemente cada membro, na `order`, executando as regras abaixo por completo dentro do workspace de cada membro; caso contrario, siga em MODO SINGLE sem alteracao. Em MODO SINGLE, execute o `JIRA_GATE` antes de ler ou alterar o workflow: resolva o vinculo; se ausente, permita escolha assistida, vincule e valide novamente. Sem Jira valido, encerre sem executar codigo.
2. Leia a issue, confirme o projeto vinculado e somente entao abra constituicao e `docs/sdd/specs/<ISSUE-KEY>/workflow.json`.
3. Recuse a execucao quando o workflow nao existir, nao registrar `refinement.verdict: "PASS"`, nao possuir checklist aprovado, contiver `NEEDS CLARIFICATION`, estiver `BLOCKED` ou nunca tiver atingido `READY_TO_BUILD`; indique `/sdd-plan <ISSUE-KEY>`.
4. Migre workflow v1 para v2 preservando dados. Antes de trabalhar, descarregue todos os `pendingJiraEvents`; falha impede retomada.
5. Valide anexos e hashes. Mudanca material exige novo `/sdd-plan`.
6. Capture `buildStartedAt` em ISO-8601 com timezone no momento de inicio real do build, persista no `workflow.json`. Depois, e antes de registrar o `PHASE_STARTED` de inicio, chame `jira_move_to_active_sprint` UMA vez (`workspacePath`, `issueKey`). Inclua no `summary` desse evento (maximo 500 caracteres) uma linha com o resultado: `Sprint: movida para <sprintName> (<sprintId>).` para `moved`, `Aviso sprint: skipped (<reason>).` para `skipped` ou `Aviso sprint: failed (<error>).` para `failed`. Nenhum resultado bloqueia o build nem altera `targetStatus`. Entao registre `PHASE_STARTED` no pai com eventKey `<ISSUE>/<runId>/r<revision>/build/started`, `targetStatus: inProgress` e o horario de inicio no resumo.
6a. Escalone o lite para o modo completo quando uma tarefa ou o QA revelar escopo maior: mais arquivos de producao que o limite, mais de um modulo ou workspace, ou qualquer gatilho de risco. Grave `mode: "full"` com o novo motivo em `modeReason` no `workflow.json`; registre `PHASE_STARTED` no pai com eventKey `<ISSUE>/<runId>/r<revision>/build/mode` e o resumo `Escalonamento lite para completo: <motivo>`; siga em modo completo. Nao exija os artefatos pulados nem as subtarefas fixas de fase, e nunca rebaixe um fluxo completo para lite.
7. Leia o campo `mode` do `workflow.json` e trate a ausencia como modo completo. Delegue exatamente `sdd-orchestrator` em modo BUILD, informando o modo da issue lido. Repasse tambem a linha `Sprint: <resultado>` da regra 6 ao `sdd-orchestrator`. Para cada `TASK-*`, use exclusivamente `` com o papel nominal `sdd-implementer`; para QA, `sdd-qa-reviewer`; para a revisao final consultiva pos-QA, `sdd-code-review`; nunca `code` ou fallback direto. Apos delegar a fase ao `sdd-orchestrator`, nao escreva `workflow.json` ate o retorno; a sequencia dos itens 8 a 13 e executada por quem estiver orquestrando.
8. Para cada tarefa delegada, siga esta sequencia:

   **Antes de delegar o agente:**
   - Capture e persista `startedAt` na entrada da tarefa no `workflow.json`.
   - Registre `TASK_STARTED` na subtarefa com `targetStatus: inProgress`.

   **Apos o retorno do agente:**
   - Capture `finishedAt` e a observacao final.
   - Registre `TASK_COMPLETED` com arquivos, validacoes e `targetStatus: done` somente quando tudo passar.

9. Por padrao o build e SEQUENCIAL: execute diretamente uma `TASK-*` por vez, na ordem de `tasks.md`, e integre o worktree de cada tarefa na branch de trabalho atual antes de iniciar a proxima, de modo que cada tarefa parta do resultado ja consolidado da anterior. Neste modo os marcadores `[P]` sao apenas informativos e nao alteram a execucao. Habilite paralelismo somente quando `buildConcurrency` for `parallel` (flag `--parallel` do item 1): nesse caso, tarefas consecutivas marcadas `[P]` em `tasks.md` podem ser delegadas em paralelo, no maximo 3 simultaneas, cada uma em seu proprio worktree; registre `TASK_STARTED` e `startedAt` de todas antes de disparar o lote e integre os worktrees sequencialmente, na ordem das tarefas, somente depois de todo o lote retornar. Antes de disparar um lote, confirme que os `Arquivos provaveis` das tarefas do lote nao se cruzam; havendo intersecao ou qualquer duvida de isolamento, rebaixe para execucao sequencial. Conflito de merge registra `BUILD_BLOCKED` preservando os worktrees. Se uma tarefa do lote falhar, aguarde o retorno das demais, registre os resultados individuais e so entao bloqueie.
10. Depois de cada retorno, consolide evidencias no `workflow.json`, incluindo horarios explicitos por tarefa. Se o agente criou worktree isolado, integre/mergeie as alteracoes aprovadas na branch de trabalho atual antes de marcar a tarefa como concluida. Nao repita tarefa concluida; bloqueios reais devem ser registrados na subtarefa correspondente.
11. Em qualquer erro, capture `buildFinishedAt` em ISO-8601 com timezone, registre `TASK_BLOCKED` ou `TASK_FAILED` na subtarefa e `BUILD_BLOCKED` no pai; mantenha a subtarefa aberta e pare imediatamente. O comentario final do `BUILD_BLOCKED` deve informar `Inicio do build: <buildStartedAt>` e `Fim do build: <buildFinishedAt>`.
12. Para QA, capture `qa.startedAt`, registre `QA_STARTED` na subtarefa e no pai, usando `codeReview` no pai quando disponivel; execute diretamente exclusivamente `sdd-qa-reviewer`, informando o ciclo atual (`qa.attempts + 1` de no maximo 3). Ao terminar, persista `qa.finishedAt`, `qa.attempts`, status e observacao.
12a. Em issue visual, confirme que `visualEvidence.criteria` declara todos os criterios de frontend antes das capturas. Delegue `sdd-visual-qa`, persista os metadados publicados sem remover criterios pendentes e envie o preflight observado (`visualPreflight: { available, version, tools }`) em cada `QA_PASSED` e `BUILD_COMPLETED`. O MCP verifica os hashes dos anexos antes de transicionar.
13. Em QA `FAIL` com correcoes minimas viaveis e dentro do escopo aprovado, execute um ciclo de correcao — no maximo 3 por build: incremente e persista `qa.attempts`; registre `TASK_PROGRESS` na subtarefa de QA com o ciclo `N/3` e os achados; execute diretamente `sdd-implementer` somente com as correcoes minimas apontadas pelo QA, com a mesma disciplina de worktree e merge do item 8; repita o QA completo. Esgotados os 3 ciclos com `FAIL`, ou quando a correcao exigir mudanca de escopo, registre `QA_FAILED` na subtarefa e `BUILD_BLOCKED` no pai e pare.
14. `QA_FAILED` mantem cards abertos e bloqueia. Somente `QA_PASSED` conclui a subtask.
14a. Depois de `QA_PASSED` e antes de `BUILD_COMPLETED`, execute a revisao final de codigo **consultiva**: capture `codeReview.startedAt`, execute diretamente exclusivamente `sdd-code-review` uma unica vez, passando a issue pai. O agente registra `CODE_REVIEW_STARTED`/`CODE_REVIEW_COMPLETED` na issue pai com achados por severidade via Open Code Review em modo delegation. Esta etapa e consultiva: qualquer resultado (`REVIEWED`, `SKIPPED` ou `BLOCKED:MCP_UNAVAILABLE`) NAO bloqueia o build e NAO dispara ciclo de correcao; achados `critical`/`high` sao alertas para analise humana. Persista `codeReview.finishedAt`, status e contagem de achados no `workflow.json`.
14b. Antes de `BUILD_COMPLETED`, confirme que todas as alteracoes dos worktrees dos agentes foram mergeadas na branch de trabalho atual e remova os worktrees temporarios criados para o build. Se algum worktree tiver alteracao nao consolidada, registre `BUILD_BLOCKED` e pare. Depois capture `buildFinishedAt` em ISO-8601 com timezone e persista no `workflow.json`.
14c. Antes de `BUILD_COMPLETED`, reconcilie todas as subtarefas: cada `TASK-*` e a subtarefa fixa de QA devem estar em status terminal no Jira (a de QA fecha via `QA_PASSED`). O servidor bloqueia `BUILD_COMPLETED` com `SUBTASKS_NOT_RECONCILED` enquanto houver subtarefa aberta; nesse caso, feche a subtarefa faltante com seu evento terminal (`TASK_COMPLETED`/`QA_PASSED`, `targetStatus: done`) e so entao registre `BUILD_COMPLETED`.
15. Registre `BUILD_COMPLETED` seguindo esta sequencia:
    a. Capture `buildFinishedAt` em ISO-8601 com timezone. Persista no `workflow.json`.
    b. Monte o resumo textual com:
       - `Inicio do build: <buildStartedAt>` e `Fim do build: <buildFinishedAt>`
       - `Modo: <lite|completo>` e, havendo escalonamento, o motivo registrado em `modeReason`
       - Uma linha por `TASK-*` com status final e observacao curta
       - Uma linha de QA com status, ciclos executados e observacao
       - Uma linha de code review com status (`REVIEWED`/`SKIPPED`) e contagem de achados por severidade
       - Validacoes executadas e observacoes gerais
    c. Chame `jira_record_sdd_event` no pai com `eventType: BUILD_COMPLETED`, `targetStatus: done`, o resumo montado em `summary` e as validacoes em `validations`. Nao inclua o campo `report`; o resumo em texto e suficiente.
    d. A notificacao Slack e enviada automaticamente pelo servidor conforme `SLACK_NOTIFY_EVENTS`; nao envie nada manualmente.
    e. Em `BUILD_BLOCKED`, nao monte o resumo completo de build; registre apenas o evento com blockers. A notificacao Slack de bloqueio tambem e automatica do servidor.

Protocolo fail-fast: nao use `run_in_background` ao delegar agentes que precisam de Jira MCP.

| Tipo de erro | Condicao | Comportamento |
|---|---|---|
| Recuperavel (1 retry) | Timeout, rede, `429`, `5xx` | Repita uma vez com o mesmo agente e `eventKey` |
| Definitivo | Tool MCP ausente, `Agent type not found`, permissao, input invalido, artefato ausente, teste ou validacao FAIL, segunda falha | Retorne `BLOCKED:MCP_UNAVAILABLE` quando a tool MCP estiver ausente; registre o evento de falha ou bloqueio da fase (`TASK_FAILED`, `PLAN_BLOCKED` ou `BUILD_BLOCKED`); adicione `pendingJiraEvents` se o Jira estiver temporariamente indisponivel; interrompa sem retry |

Nunca continue parcialmente nem implemente como fallback.

Nenhuma fase avanca sem comentario/transicao confirmados.

Nao altere escopo aprovado durante o build. Ao final, informe tarefas executadas, arquivos, comandos, evidencias, estados Jira, pendencias, worktrees removidos, `buildStartedAt` e `buildFinishedAt`.
<!-- sdd:section command.sdd-build:end -->


## Regra Codex sem subagentes

Este arquivo e executado pelo Codex CLI local, sem delegacao nominal disponivel. Execute este papel diretamente na sessao principal, lendo a skill nominal correspondente em .agents/skills/. Nao tente chamar Agent, ferramenta de delegacao ou qualquer subagente. Preserve todos os gates, eventos, artefatos e validacoes do fluxo.
