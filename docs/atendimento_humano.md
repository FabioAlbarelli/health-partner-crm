# Fluxo de Atendimento Humano: HealthPartner CRM

## 1. OBJETIVO E INICIALIZAÇÃO
O Fluxo de Atendimento Humano é a etapa final e mais crítica do pipeline comercial. Ele visa converter o interesse demonstrado pelo médico em uma parceria real, garantindo um atendimento personalizado e 100% livre de interferências automáticas.

### Gatilho de Entrada
O fluxo humano é ativado automaticamente e exclusivamente quando:
- `doctors.status = 'interessado'`
- `conversations.status_atual = 'interessado'`
- Existe um registro de auditoria em `agent_actions` justificando a classificação por parte do `Agent_Qualifier`.

---

## 2. REGRAS DE SILENCIAMENTO E PRIORIDADE
Uma vez que o atendimento humano é iniciado:
- **Silenciamento Total**: Todos os agentes automáticos (`Contact_WhatsApp`, `Qualifier`) são bloqueados para interagir com este médico.
- **Controle Exclusivo**: O Atendente Humano possui autoridade única sobre a conversa. Nenhuma mensagem automática será enviada enquanto o status não for alterado para um estado terminal.
- **Histórico**: O atendente deve obrigatoriamente revisar o histórico de mensagens e ações de auditoria antes de enviar a primeira mensagem.

---

## 3. RESPONSABILIDADES DO ATENDENTE
O Atendente Humano deve:
1. Conduzir a negociação de forma ética e profissional.
2. Esclarecer dúvidas técnicas ou comerciais que fogem ao escopo da automação.
3. Registrar **todas** as interações enviadas e recebidas na tabela `messages` com a marcação `enviado_por = 'human'`.
4. Atualizar o status final do lead no sistema após a conclusão do contato.

---

## 4. CAMINHOS DE DECISÃO E TRANSICÕES DE STATUS

### A. Sucesso Comercial
Quando a parceria é formalizada ou a proposta é aceita.
- **Ação**: Atualizar `doctors.status = 'encerrado'`.
- **Auditoria**: Registrar em `agent_actions` com `acao = 'atendimento_concluido_sucesso'`.

### B. Encerramento Sem Sucesso
Quando a conversa é concluída mas não gera negócio imediato.
- **Ação**: Atualizar `doctors.status = 'encerrado'`.
- **Auditoria**: Registrar em `agent_actions` com `acao = 'atendimento_concluido_sem_sucesso'`.

### C. Pedido de Interrupção (Opt-out)
Se em qualquer momento o médico solicitar a parada do contato.
- **Ação**: Atualizar `doctors.status = 'rejeitou'`.
- **Blacklist**: Inserir imediatamente o `doctor_id` na tabela `blacklist`.
- **Auditoria**: Registrar em `agent_actions` com `acao = 'opt_out'`.

---

## 5. EXEMPLOS DE CENÁRIOS REAIS

- **Cenário 1 (Interesse Confirmado)**: Médico pergunta sobre valores. Atendente responde manualmente, explica a proposta e agenda uma demonstração. Ao final, marca o lead como `encerrado` e justifica o sucesso.
- **Cenário 2 (Dúvida pontual)**: Médico pergunta sobre a origem dos dados. Atendente explica a natureza pública das fontes (conforme política LGPD). O médico agradece mas declina no momento. Atendente marca como `encerrado` (sem sucesso).
- **Cenário 3 (Retirada)**: Médico diz: "Obrigado, mas não quero mais receber mensagens". Atendente não argumenta, registra a mensagem, marca como `rejeitou` e o sistema o insere na blacklist.

---

## 6. AUDITORIA E SEGURANÇA NO BANCO DE DADOS (PostgreSQL)

### Registro de Mensagens
Toda mensagem humana deve seguir o rigor do schema:
```sql
INSERT INTO messages (conversation_id, direcao, conteudo, enviado_por) 
VALUES (conv_id, 'outbound', 'Olá Dr., sou o atendente...', 'human');
```

### Regras de Ouro de Segurança
- **Imutabilidade**: O humano não tem permissão para editar ou deletar histórico de mensagens (proteger a auditoria).
- **Blacklist Intocável**: Humanos não podem remover registros da `blacklist`. Isso garante a conformidade legal mesmo sob pressão comercial.
- **Handoff em Via Única**: Uma vez escalado para humano, o lead nunca volta a ser processado por agentes de prospecção automática.

---

## 7. MONITORAMENTO E QUALIDADE
As ações registradas em `agent_actions` por humanos são revisadas periodicamente para:
- Validar a eficácia da classificação inicial do `Agent_Qualifier`.
- Ajustar tonalidade e discurso das mensagens iniciais.
- Garantir que nenhum lead "interessado" ficou sem resposta humana.
