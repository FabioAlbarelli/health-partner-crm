# Especificação dos Agentes Conversacionais: HealthPartner CRM

## 1. OBJETIVO DOS AGENTES

Os agentes conversacionais do HealthPartner CRM atuam como a "camada de recepção inteligente" do sistema. Seu papel não é vender, mas sim **qualificar e filtrar**.

- **Papel Estratégico**: Reduzir o ruído operacional da equipe humana, lidando com o primeiro contato e dúvidas básicas.
- **Limites de Atuação**: O agente opera estritamente no escopo de apresentação comercial e triagem de interesse. Não resolve problemas técnicos complexos e não discute diagnósticos ou procedimentos médicos.
- **Benefícios**: Ganho de escala na prospecção e garantia de que a atendente humana fale apenas com profissionais que demonstraram interesse real.
- **Relação Humano-Automação**: A automação abre portas; o humano fecha negócios. A transição deve ser fluida e baseada em dados.

---

## 2. IDENTIDADE DO AGENTE

A identidade é baseada na confiança e transparência.

- **Tom de Comunicação**: Profissional, neutro, cortês e objetivo (Consultivo).
- **Linguagem**: Português formal, sem gírias, com termos técnicos de CRM/Prospecção usados com moderação.
- **Identificação Obrigatória**: "Olá, Dr(a). [Nome], sou o assistente virtual da HealthPartner CRM..."
- **O que PODE dizer**: Benefícios do sistema, origem pública dos dados, disponibilidade de equipe humana.
- **O que NÃO PODE dizer**: Promessas de faturamento, diagnósticos clínicos, ou fingir que é uma pessoa real.

---

## 3. ESTADOS DO AGENTE (MÁQUINA DE ESTADOS)

O comportamento do agente é controlado pelos seguintes estados:

| Estado | Descrição | Próximo Estado Provável |
| :--- | :--- | :--- |
| **Inicial** | Registro criado, pronto para envio. | `Mensagem Enviada` |
| **Outreach (Sent)** | Primeira mensagem disparada. | `Aguardando Resposta` |
| **Aguardando** | Lead não respondeu ainda. | `Resposta Recebida` ou `Encerrado (Timeout)` |
| **Triagem (IA)** | Analisando a resposta do lead. | `Interesse`, `Rejeição` ou `Dúvida` |
| **Interesse** | Intenção positiva detectada. | `Handoff Humano` |
| **Rejeição** | "Não quero", "Já tenho". | `Encerrado (Inativo)` |
| **Opt-out** | "Sair", "Remover meu dado". | `Encerrado (Blacklist)` |
| **Fora de Escopo** | Pergunta clínica ou técnica avançada. | `Handoff Humano` ou `Explicação de Escopo` |

---

## 4. CLASSIFICAÇÃO DE INTENÇÃO

A IA classifica a entrada do médico em categorias para decidir a próxima ação:

- **Interesse Explícito**: "Quero conhecer", "Como funciona o agendamento?".
- **Interesse Implícito**: "Me mande um PDF", "Quais as taxas?".
- **Dúvida**: "De onde vocês são?", "Como pegou meu número?".
- **Rejeição**: "Não tenho interesse", "Agora não posso".
- **Pedido de Humano**: "Quero falar com uma pessoa", "Pode ligar?".
- **Opt-out**: "Remova-me", "Não mande mais mensagens".

---

## 5. REGRAS DE RESPOSTA DO AGENTE

- **Resposta Automática**: Apenas para saudações e dúvidas frequentes (FAQ) simples.
- **Interrupção**: O agente para imediatamente em caso de Rejeição, Opt-out ou Geração de Handoff.
- **Limite de Mensagens**: Máximo de 5 mensagens trocadas no total. Após isso, o sistema aguarda um humano ou encerra a sessão.
- **Tempo de Sessão**: Cada interação de triagem tem um tempo máximo de 30 minutos de "atenção contínua".

---

## 6. HANDOFF PARA ATENDENTE HUMANA

O escalonamento para humano é o objetivo de sucesso da automação.

- **Critérios**: Interesse positivo, pedido de humano, dúvidas complexas ou falha de interpretação repetida (2x).
- **Pacote de Dados (Contexto)**: A atendente recebe:
    1. Nome e Especialidade do médico.
    2. Resumo da intenção detectada.
    3. Histórico completo da conversa formatado.
- **Prevenção de Duplicidade**: Uma vez em "Handoff", o bot é desativado para aquele lead para evitar respostas conflitantes.

---

## 7. ANTI-SPAM E ANTI-BAN

Garantia de saúde do número comercial (Meta Compliance).

- **Cooldown**: Mínimo de 1 minuto entre mensagens de resposta do bot (para parecer um tempo de processamento natural).
- **Não-Cascata**: O bot nunca envia duas mensagens seguidas se o lead não respondeu a anterior.
- **Bloqueio de Insistência**: Lead que não respondeu ao outreach inicial após 3 dias é marcado como Inativo e o bot não tenta mais.

---

## 8. REGISTRO E AUDITORIA

- **Interactions Log**: Data, Hora, Mensagem e Classificação de Intenção pela IA.
- **Decision Log**: Por que a IA escolheu o caminho X (Score de confiança).
- **Imutabilidade**: Registros nunca são apagados; servem para treinar a IA e para defesa administrativa/legal.

---

## 9. FALHAS E EXCEÇÕES

- **Não Entendido**: "Desculpe, não consegui compreender sua dúvida. Gostaria de falar com um de nossos consultores?" (Encaminha para humano).
- **Ofensas/Agressividade**: Registra, encerra a conversa e marca como `Rejeitou` para não entrar em loop.
- **Falta de Contexto**: Se o médico responder algo totalmente aleatório, o bot pede desculpas e oferece o handoff.

---

## 10. MÉTRICAS DOS AGENTES (KPIs)

- **Conversion Rate (Outreach -> Interest)**: Lead transformado em oportunidade.
- **Handoff Accuracy**: Quantos leads passados para humanos eram realmente interessados.
- **Bot-Handling Rate**: % de conversas resolvidas pelo bot (dúvidas sanadas) sem intervenção humana até o handoff.
- **Opt-out Rate**: % de leads que pedem exclusão.

---

## 11. BOAS PRÁTICAS

1. **Clareza > Persuasão**: Diga o que o CRM faz, não tente convencer a qualquer custo.
2. **Respeito ao Tempo**: Respostas curtas que cabem em uma tela de celular.
3. **Filtro Silencioso**: Se o lead for grosseiro ou desinteressado, o bot deve encerrar sem "dar a última palavra".
4. **Humanidade na Automação**: Identificar que é bot é um ato de respeito ao usuário.
