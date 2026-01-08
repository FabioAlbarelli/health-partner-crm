# Documentação do Banco de Dados: HealthPartner CRM

Este documento descreve a fundação de dados do sistema, baseada em PostgreSQL, priorizando a integridade e a auditoria de processos automatizados.

## 1. Estrutura de Dados (Schema)

O banco de dados é composto por 6 tabelas principais e um conjunto de tipos enumerados (ENUMS) para garantir a padronização dos estados do sistema.

### Tabelas
- **`doctors`**: Tabela central contendo os dados identificados publicamente. Utiliza o ENUM `doctor_status` para gerenciar o funil.
- **`contacts`**: Armazena WhatsApp e Email. Possui flags de `verificado` e `principal` para orientar os agentes.
- **`conversations`**: Garante o limite de **apenas uma conversa automática** por médico por canal.
- **`messages`**: Registro imutável de todas as interações (direção, conteúdo e autor).
- **`agent_actions`**: Log de auditoria obrigatório para toda decisão tomada por uma IA ou agente automatizado.
- **`blacklist`**: Controle absoluto de exclusão de contato.

## 2. Regras de Integridade e Auditoria

### Garantia de Não-Recontato (Blacklist)
Para assegurar que médicos na blacklist nunca sejam contatados por engano:
- Um **Trigger PostgreSQL** (`trg_check_blacklist_message`) impede a inserção de novas mensagens na tabela `messages` se o médico vinculado à conversa estiver na tabela `blacklist`.
- Isso garante a integridade mesmo que a lógica da aplicação falhe.

### Auditoria de Decisões
Toda transição de status ou ação proativa dos agentes (ex: `Agent_Qualifier`) deve ser registrada na tabela `agent_actions` com uma **justificativa textual**. Isso permite:
- Debugar decisões da IA.
- Justificar ações em caso de auditoria legal ou administrativa.
- Treinar modelos futuros com base em acertos e erros.

### Persistência e Rastreabilidade
- **Foreign Keys**: Configuradas com `ON DELETE RESTRICT` para evitar a perda acidental de histórico.
- **Timestamps**: Todas as tabelas registram data de criação e atualização.
- **Soft Delete**: A tabela `doctors` possui o campo `deleted_at` para remoções lógicas sem perda de dados históricos.

## 3. Estados Canônicos (Pipeline)
O status do médico flui de `novo` até estados terminais como `interessado` (handoff), `rejeitou` (blacklist) ou `sem_resposta`. A automação é suspensa imediatamente ao atingir qualquer estado além de `aguardando_resposta`.
