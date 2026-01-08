# HealthPartner CRM: Especificação Técnica e Operacional

## 1. Visão Geral do Sistema (Overview)

O **HealthPartner CRM** é uma plataforma especializada em automação de prospecção comercial B2B para o setor de saúde. O sistema identifica profissionais através de dados públicos e gerencia o primeiro contato via WhatsApp Business API, utilizando inteligência artificial para qualificação e escalonamento para atendimento humano.

### Diferenciação de Níveis de Contato
Para garantir a eficiência e a conformidade, o sistema opera em três camadas distintas:
1.  **Contato Automatizado (Templates)**: Disparo inicial padronizado e aprovado pela Meta, focado em transparência e proposta de valor.
2.  **Agentes Conversacionais (IA)**: Inteligência artificial que interpreta respostas, esclarece dúvidas básicas e identifica a intenção do lead.
3.  **Atendimento Humano (CRM)**: Atuação consultiva final, iniciada apenas após demonstração de interesse explícito.

---

## 2. Aquisição de Dados (Data Acquisition)

O sistema baseia-se exclusivamente em **dados públicos** de natureza profissional.

### Escopo e Fontes
- **Público-Alvo**: Médicos e profissionais de saúde (Espec. inicial: Urologistas).
- **Fontes Primárias**: Google Maps (perfis comerciais), Doctoralia (perfis públicos), diretórios de CRM e sites institucionais.
- **Campos Coletados**: Nome, Especialidade, Cidade/UF, Clínica/Entidade, WhatsApp Profissional (público), Email e URL da Fonte.

### Princípio da Não-Invasividade
- **NUNCA** coletar ou tratar dados sensíveis (prontuários, dados clínicos).
- **NUNCA** coletar dados de âmbito privado (contatos pessoais fora do contexto comercial).

> [!TIP]
> Para detalhes sobre a lógica de identificação, critérios de descarte e auditoria de descoberta, consulte a [Especificação do Agent_Researcher](file:///h:/Meu%20Drive/Medicos/health-partner-crm/docs/agente_researcher.md). Para regras de validação e enriquecimento de dados, consulte a [Especificação do Agent_Enricher](file:///h:/Meu%20Drive/Medicos/health-partner-crm/docs/agente_enricher.md).

---

## 3. Pipeline de Prospecção (Funil Inteligente)

1.  **Novo**: Lead importado, aguardando início.
2.  **Apresentado (WhatsApp)**: Template de primeiro contato enviado de forma automatizada.
3.  **Em Triagem (Agente)**: Lead respondeu; o Agente Conversacional está processando a interação.
4.  **Qualificado (Interessado)**: Interesse positivo detectado; pronto para o comercial.
5.  **Em Atendimento Humano**: Handoff realizado para o dashboard da atendente.
6.  **Cliente**: Conversão comercial concluída.
7.  **Descartado (Rejeitou/Inativo/Opt-out)**: Lead removido do ciclo ativo com registro de motivo.

---

## 4. Agentes Conversacionais (Core Intelligence)

O Agent Conversacional atua como uma recepção inteligente e transparente.

### Regras de Ouro da IA
- **Transparência Total**: O agente deve se identificar como automação na primeira mensagem. Ex: "Olá, sou o assistente virtual da HealthPartner...".
- **Foco em FAQ**: Responde apenas sobre o escopo comercial e operacional pré-definido.
- **Handoff Imediato**: Transfere para humano em caso de interesse explícito, pedido de falar com pessoa ou quando a dúvida foge do escopo.
- **Limite de Interação**: Máximo de 5 turnos de conversa para evitar repetições e frustração.

> [!NOTE]
> Para detalhes técnicos de estados, classificação de intenção e regras de handoff, consulte a [Especificação do Agent_Qualifier](file:///h:/Meu%20Drive/Medicos/health-partner-crm/docs/agente_qualifier.md) e a [Especificação Geral de Agentes](file:///h:/Meu%20Drive/Medicos/health-partner-crm/docs/especificacao_agentes.md).

---

## 5. Automação de WhatsApp Business API

O sistema é construído sobre a API oficial para garantir perenidade e reputação.

- **Conformidade com a Meta**: Uso exclusivo de *Message Templates* para iniciar conversas.
- **Respeito à Janela de 24h**: Interação livre permitida apenas após opt-in/resposta do lead.
- **Mecânicas Anti-Spam**: Warming de números, intervalos aleatórios e monitoramento de taxas de bloqueio.
- **Opt-out Imediato**: Inclusão de comando de saída em todas as abordagens iniciais.

> [!IMPORTANT]
> O envio da mensagem inicial obedece a regras rigorosas para evitar spam e garantir a reputação do número. Para detalhes técnicos de ativação e templates, consulte a [Especificação do Agent_Contact_WhatsApp](file:///h:/Meu%20Drive/Medicos/health-partner-crm/docs/agente_whatsapp.md).

---

## 6. LGPD e Ética Comercial

O HealthPartner CRM opera sob o conceito de **Legítimo Interesse** (Art. 7º, IX da LGPD).

- **Finalidade**: Exclusivamente comercial e profissional.
- **Direitos do Titular**: Acesso, retificação e exclusão (opt-out) facilitados e permanentes.
- **Base de Consentimento Implícito**: Contato baseado na publicidade dos dados para fins de networking/comércio.
- **Auditoria**: Logs completos de todas as mensagens e mudanças de status para comprovação de boas práticas.
---

## 7. Infraestrutura e Hospedagem

A arquitetura do HealthPartner CRM é dividida para garantir escalabilidade, segurança e performance otimizada para cada componente.

### Frontend (Interface do Usuário)
- **Plataforma**: **Vercel**.
- **Escopo**: Hospedagem exclusiva da interface web (Dashboard), garantindo entrega global via CDN, SSL automático e deploys atômicos.

### Backend e Core de Automação
- **Plataforma**: **Infraestrutura Dedicada Separada** (ex: AWS, Google Cloud ou Servidor VPS dedicado).
- **Escopo**:
    - Processamento de Regras de Negócio.
    - Banco de Dados (SQLite/PostgreSQL).
    - Agentes Conversacionais (IA e NLP).
    - Integrações Críticas (WhatsApp Business API).
    - Motores de Scraping e Data Acquisition.
- **Justificativa**: Componentes de IA e processamento intensivo de dados exigem recursos de CPU/Memória persistentes e controle granular de ambiente que excedem o modelo serverless do frontend.
