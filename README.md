# HealthPartner CRM - WhatsApp Prospecting System

![Versão](https://img.shields.io/badge/version-1.0.0--MVP-blue)
![Status](https://img.shields.io/badge/status-em--desenvolvimento-green)
![LGPD](https://img.shields.io/badge/compliance-LGPD-brightgreen)

O **HealthPartner CRM** é um sistema inteligente de prospecção comercial B2B voltado para o setor médico. Ele automatiza a identificação de profissionais através de dados públicos e gerencia o primeiro contato via **WhatsApp Business API**, utilizando agentes conversacionais para triagem e qualificação de leads.

## 🚀 Objetivo
Identificar médicos (inicialmente urologistas) a partir de informações públicas, organizar esses dados em um pipeline estruturado e executar estratégias de prospecção comercial automatizada, escalando para atendimento humano apenas quando houver demonstração clara de interesse.

## 🏗️ Arquitetura e Infraestrutura
O sistema possui uma arquitetura híbrida para máxima eficiência:
- **Frontend**: Hospedado na **Vercel** (Dashboard administrativa).
- **Backend & Core**: Infraestrutura dedicada separada (AWS/GCP/VPS) para processamento de IA, banco de dados e integrações críticas.

## 📁 Estrutura do Repositório
- 📄 `specification.md`: Documento mestre de arquitetura e regras de negócio.
- 📂 `docs/`: Documentação operacional e técnica detalhada.
    - `especificacao_agentes.md`: Lógica detalhada da IA e máquina de estados.
    - `manual_atendente.md`: Guia para a equipe comercial humana.
    - `politica_lgpd.md`: Governança de dados e base legal.
    - `politica_whatsapp.md`: Regras de uso da API oficial e reputação.
    - `riscos_operacionais.md`: Matriz de riscos e planos de contingência.
- 📂 `scripts/`: Ferramentas de automação (Importador de leads, sanitização).
- 📂 `ui/`: Protótipos da interface administrativa.
- 📄 `schema.sql`: Definição da estrutura do banco de dados (SQLite/PostgreSQL).

## 🛠️ Como Iniciar (Fase MVP)
1. **Configurar o Banco de Dados**:
   ```bash
   sqlite3 health_partner.db < schema.sql
   ```
2. **Importar Leads**:
   Coloque seu arquivo CSV em `scripts/` e execute:
   ```bash
   python scripts/import_leads.py
   ```
3. **Visualizar Dashboard**:
   Abra o arquivo `ui/dashboard.html` em seu navegador para ver o protótipo da interface.

## ⚖️ Conformidade e Ética
- **LGPD**: Baseado em Legítimo Interesse (Art. 7º, IX).
- **Dados**: Apenas informações públicas e de cunho profissional.
- **Transparência**: O bot sempre se identifica como atendimento automatizado.
- **Opt-out**: Respeito imediato e permanente a pedidos de interrupção de contato.

## 📅 Roadmap
- [x] **Fase 1**: CRM Básico + Importador + Database.
- [ ] **Fase 2**: Integração com WhatsApp Business API.
- [ ] **Fase 3**: Implementação de IA Conversacional (LLM) para triagem avançada.

---
Desenvolvido para **HealthPartner CRM**.
