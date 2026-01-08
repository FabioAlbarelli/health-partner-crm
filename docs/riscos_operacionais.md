# Documento de Riscos Operacionais: HealthPartner CRM

## 1. Riscos Legais e de Conformidade
- **Risco**: Questionamento sobre o uso do Legítimo Interesse (LGPD).
- **Mitigação**: Manter registros claros da origem pública do dado e respeitar rigorosamente o opt-out imediato.
- **Contingência**: Suspensão imediata da campanha em caso de notificação judicial ou administrativa para revisão jurídica.

## 2. Riscos de Infraestrutura (WhatsApp)
- **Risco**: Banimento do número comercial pela Meta.
- **Mitigação**: Uso de API Oficial, monitoramento de taxas de bloqueio/denúncia e manutenção de volume equilibrado (warming).
- **Contingência**: Ter números de reserva pré-aquecidos e processo rápido de migração de linha comercial.

## 3. Riscos de Reputação
- **Risco**: Ser percebido como "Gerador de Spam" pela comunidade médica local.
- **Mitigação**: Frequência baixa de contatos (no máximo 3 tentativas), tom de voz profissional e oferta de valor real.
- **Contingência**: Pedido formal de desculpas e remoção total do lead da base em caso de reclamação acalorada.

## 4. Riscos Operacionais (Operador Humano)
- **Risco**: Atendente tratar o médico de forma inadequada ou insistente.
- **Mitigação**: Treinamento obrigatório com o "Manual da Atendente" e monitoramento aleatório de conversas.
- **Contingência**: Advertência e reciclagem do operador; retirada do operador do canal de vendas se reincidente.

## 5. Riscos Técnicos (Agente IA)
- **Risco**: IA dar respostas incorretas ou ofensivas (alucinação).
- **Mitigação**: Parametrização rígida do sistema, base de conhecimento curada e limites de confiança para handoff.
- **Contingência**: Desativar o módulo conversacional temporariamente e operar com handoff manual direto para a primeira mensagem.

## 6. Monitoramento de Saúde do Funil
Taxas críticas que disparam alertas:
- **Taxa de Bloqueio > 3%**: Parar campanha imediatamente.
- **Taxa de Reclamação > 1%**: Revisar o copy e o filtro de leads.
