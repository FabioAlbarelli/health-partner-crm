# MedConnect WhatsApp Prospecting System: Technical Specification

## 1. Visão Geral do Sistema (Overview)

O **MedConnect WhatsApp Prospecting System** é uma plataforma de automação de prospecção comercial B2B voltada para o setor médico. O sistema utiliza dados públicos para identificar clientes potenciais e inicia o relacionamento através do WhatsApp Business API, utilizando agentes conversacionais inteligentes para qualificar o interesse antes de escalar para o atendimento humano.

### Estratégia de Prospecção
A prospecção é baseada em "Interesse Legítimo", onde contatamos profissionais que disponibilizam seus dados publicamente para fins comerciais/profissionais.
1. **Identificação**: Coleta automatizada de dados de clínicas e médicos.
2. **Engajamento**: Primeiro contato via WhatsApp focado em uma proposta de valor clara e transparente.
3. **Qualificação**: IA interpreta respostas e gerencia dúvidas básicas.
4. **Conversão**: Transferência para o CRM humano apenas quando o médico demonstra interesse explícito.

### Princípios Fundamentais
- **Eficiência**: Otimiza o tempo da equipe de vendas removendo o atrito do "cold calling" manual.
- **Transparência**: Nunca fingir ser humano; identificação clara como sistema automatizado.
- **Conformidade**: Foco total em LGPD e políticas anti-spam do WhatsApp.

---

## 2. Aquisição de Dados (Data Acquisition)

O módulo de aquisição é responsável por alimentar o pipeline com leads qualificados.

### Escopo de Dados
- **Especialidade Alvo Inicial**: Urologistas (Configurável).
- **Fontes**: Google Maps API, diretórios médicos públicos (ex: Doctoralia), sites de CRM (Conselho Regional de Medicina), e sites institucionais de clínicas/hospitais.

### Campos de Coleta (Apenas Dados Públicos)
| Campo | Descrição |
| :--- | :--- |
| **Nome Completo** | Nome do médico |
| **Especialidade** | Classificação principal e sub-especialidades |
| **Cidade/UF** | Localização da clínica ou consultório |
| **Entidade** | Nome da clínica ou hospital onde atende |
| **WhatsApp Público** | Número prioritário para contato ( extraído de listagens comerciais) |
| **Email** | Canal secundário de contato |
| **Fonte** | URL ou origem de onde o dado foi extraído |

### Processamento de Entrada
1. **Deduplicação**: Verificação por Nome + CRM ou Nome + WhatsApp para evitar contatos duplicados.
2. **Normalização**: Formatação de números de telefone e nomes.
3. **Classificação**: Todo novo registro entra com o status **"Novo"**.

---

## 3. Pipeline de Prospecção (Hierarchy)

O pipeline define a jornada do lead desde a descoberta até a conversão ou descarte.

### Estágios do Funil
1. **Novo**: Lead recém-coletado, aguardando início de campanha.
2. **WhatsApp Automático Enviado**: A primeira mensagem de outreach foi disparada.
3. **Em Conversa com Agente**: Respondeu e a IA está processando a interação.
4. **Respondeu**: Lead interagiu de forma geral (pode ser dúvida ou saudação).
5. **Interessado**: Lead demonstrou interesse positivo na proposta (Gatilho para Humano).
6. **Encaminhado para Atendente**: Conexão estabelecida com o time comercial.
7. **Cliente**: Conversão final realizada.
8. **Rejeitou**: Demonstrou desinteresse (Arquivado).
9. **Opt-out**: Solicitou remoção (Blacklist permanente).
10. **Inativo**: Sem resposta após X tentativas ou número inválido.

### Regras de Transição Automática
- `Novo` → `WhatsApp Automático Enviado`: Disparo via scheduler de campanha.
- `Recebeu Resposta` → `Em Conversa com Agente`: Reconhecimento de entrada de mensagem.
- `Intenção = Interesse` → `Interessado` → `Encaminhado`: Automação de handoff.
- `Pedido de Opt-out` → `Opt-out`: Bloqueio imediato no banco de dados.

---

## 4. Agentes Conversacionais (Core do Sistema)

Os agentes são responsáveis pela interação de primeira linha, atuando como um filtro inteligente.

### Funcionalidades do Agente
- **Processamento de Linguagem Natural (NLP)**: Interpretação de respostas em texto livre para classificar a intenção (Dúvida, Interesse, Rejeição, Off-topic).
- **Respostas Baseadas em Base de Conhecimento**: Responde a dúvidas frequentes (FAQ) sobre o serviço/produto oferecido.
- **Identificação Transparente**: Toda conversa inicia com uma declaração clara: *"Olá, sou o assistente virtual do HealthPartner CRM..."*. No-bot-masking policy.
- **Gestão de Turnos**: Limite máximo de 5 interações por lead para evitar "looping" ou fadiga do lead.

### Regras de Handoff (Transferência para Humano)
A transferência ocorre instantaneamente quando:
1. O lead expressa interesse positivo (ex: "Quero saber mais", "Tenha interesse").
2. O lead solicita falar com uma pessoa.
3. A IA atinge o limite de confiança (não entende a pergunta após 2 tentativas).
4. Pergunta fora do escopo comercial pré-definido.

---

## 5. Automação de WhatsApp

Implementação técnica focada em estabilidade e conformidade com as políticas da Meta.

### Integração Tech
- **Provedor**: WhatsApp Business API (via Cloud API oficial da Meta ou BSPs como Twilio/Zenvia).
- **Message Templates**: Uso obrigatório de templates aprovados pela Meta para o primeiro contato (Marketing/Utility category).
- **Janela de 24h**: Monitoramento rigoroso da janela de conversação para permitir mensagens de texto livre apenas após interação do lead.

### Controle Anti-Ban e Reputação
- **Volume Incremental (Warming)**: Início com 50 envios/dia, escalando gradualmente conforme a saúde do número.
- **Randomização de Delay**: Intervalos variáveis (120s - 300s) entre disparos de "Cold messages".
- **Opt-out Facilitado**: Inclusão de um botão ou instrução clara de STOP/SAIR em todas as mensagens iniciais.
- **Logging Imutável**: Registro de todos os status de entrega (Sent, Delivered, Read) para fins de auditoria e métricas.

---

## 6. Contato Humano (Atendente)

O painel do atendente é o ponto final de conversão, onde a inteligência artificial entrega um lead "quente".

### Dashboard da Atendente
- **Lista de Prioridades**: Leads classificados como "Interessados" aparecem no topo com alerta visual.
- **Contexto Completo**: Visualização do histórico da conversa tida com o bot antes de assumir.
- **Ações Rápidas**: Botões para enviar propostas PDF, agendar reuniões ou marcar como "Cliente".
- **Handoff Reverso**: Possibilidade de devolver o lead para o bot (ex: "Lead pediu para ser contatado em 1 mês").

---

## 7. Campanhas e Mala Direta

O sistema permite a execução de disparos segmentados por WhatsApp.

### Segmentação
- **Por Especialidade**: Ex: Campanha específica para Urologistas de São Paulo.
- **Por Status**: Ex: Re-engajamento de leads que "Responderam" mas não avançaram.
- **Por Região**: Filtro geográfico para eventos ou promoções locais.

### Métricas de Campanha
- Taxa de Entrega.
- Taxa de Leitura (Read Receipt).
- Taxa de Resposta.
- Taxa de Conversão para Humano.

---

## 8. Regras de Negócio

Garantem a integridade e a ética da operação.

- **Histórico Imutável**: Nenhuma interação pode ser excluída, apenas arquivada (Auditoria).
- **Controle de Tentativas**: Máximo de 3 tentativas de contato inicial em horários diferentes antes de marcar como "Inativo".
- **Cooldown**: Intervalo mínimo de 90 dias entre campanhas para o mesmo lead, a menos que haja interação.
- **Blacklist Permanente**: Leads em status "Opt-out" nunca podem ser re-importados ou contatados.

---

## 9. LGPD e Conformidade

O sistema é desenhado sob o conceito de *Privacy by Design*.

- **Base Legal**: Artigo 7º, IX da LGPD (Legítimo Interesse do Controlador).
- **Direito de Opposição**: O lead pode interromper o contato a qualquer momento com o comando "Sair" ou "Não tenho interesse".
- **Transparência**: A primeira mensagem deve conter a origem do dado (Ex: "Encontramos seu contato publicamente no Google Maps...").
- **Descarte de Dados**: Dados de leads inativos por mais de 24 meses são anonimizados ou excluídos.

---

## 10. KPIs e Métricas de Sucesso

| Métrica | Meta Sugerida |
| :--- | :--- |
| **Taxa de Resposta (WhatsApp)** | > 15% |
| **Conversão Agente → Humano** | > 5% do total de enviados |
| **Eficiência da Automação** | Redução de 80% no tempo de triagem manual |
| **Taxa de Opt-out** | < 2% |

---

## 11. Roadmap de Implementação

### Versão 1: MVP Útil
- CRM Básico para gestão de leads.
- Disparo manual/semi-automático via WhatsApp Web.
- Importação de listas CSV de Urologistas.

### Versão 2: Automação Escalável
- Integração com WhatsApp Business API (Cloud API).
- Pipeline automático com transições de status.
- Painel prioritário para atendente.

### Versão 3: Inteligência Avançada
- IA Conversacional (LLM) para triagem de respostas.
- Dashboard de métricas avançado.
- Motor de scraping integrado e recorrente.
