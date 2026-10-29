# Swift / Xcode

<!-- sdd:section architecture:start -->
## Arquitetura

- Organize o app por feature, mantendo `App`, `Core`, `Networking`, `DesignSystem` e `Resources` como áreas compartilhadas quando aplicável.
- Para SwiftUI, mantenha a View focada em composição e estado de apresentação; extraia regras de negócio para Store/ViewModel e serviços testáveis.
- Use modelos e contratos em `Core`; concentre chamadas HTTP, autenticação, Keychain e WebSocket em `Networking`.
- Preserve a separação entre o app iOS (`Joe/`) e o módulo Swift Package (`Package.swift`, `JoeCore`) quando o projeto já a utilizar.
- Dependências de terceiros devem permanecer fixadas e documentadas; não copie certificados, perfis ou segredos para o repositório.
<!-- sdd:section architecture:end -->

<!-- sdd:section conventions:start -->
## Convenções e implementação

- Use Swift 6 com concorrência segura e APIs nativas antes de criar abstrações próprias.
- Reutilize o Design System existente para cores, tipografia, espaçamento e componentes.
- Respeite acessibilidade, Dynamic Type, tema claro/escuro e layouts distintos para iPhone e iPad.
- Mantenha `Info.plist`, entitlements e configurações de assinatura coerentes com o alvo; nunca altere exposição de rede ou ATS sem justificar.
- Para terminal e conexões em tempo real, trate reconexão, cancelamento, ciclo de vida e limpeza de recursos explicitamente.
<!-- sdd:section conventions:end -->

<!-- sdd:section testing:start -->
## Testes e validação

- Rode `swift test` para o módulo Swift Package.
- Rode `xcodebuild test` com um destino de simulador instalado para testes de app e UI.
- Use `CODE_SIGNING_ALLOWED=NO` somente em validações locais/CI que não exigem assinatura.
- Não execute testes contra projetos reais, Jira, contas ou servidores externos quando houver fixture isolado.
- Verifique build Debug, acessibilidade, navegação, estados de erro, reconexão e rotação/tamanhos de tela relevantes.
<!-- sdd:section testing:end -->

<!-- sdd:section delivery:start -->
## Entrega

- Antes de archive/TestFlight, confirme `MARKETING_VERSION` e o próximo `CURRENT_PROJECT_VERSION` conforme a regra do projeto.
- Não versionar chaves App Store Connect, certificados, provisioning profiles ou credenciais.
- Documente mudanças de capacidade, permissões, endpoints, dependências e requisitos mínimos de iOS.
<!-- sdd:section delivery:end -->
