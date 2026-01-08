# Fluxo Operacional: HealthPartner CRM

## SEÇÃO 1 — VISÃO GERAL DO FLUXO
O HealthPartner CRM segue um processo linear e controlado para garantir que cada profissional de saúde seja contatado de forma ética e profissional. O caminho inicia na identificação do médico através de dados públicos, passa por uma fase de enriquecimento e verificação, culmina em um único contato inicial automatizado e termina ou com o atendimento humano (em caso de interesse) ou com o encerramento definitivo do contato.

## SEÇÃO 2 — ENTRADA DE DADOS (ONBOARDING)
- **Identificação**: O `Agent_Researcher` busca médicos em fontes públicas (Google Maps, diretórios profissionais, sites de conselhos).
- **Dados Mínimos**: Para entrar no sistema, o registro deve conter pelo menos: Nome Completo, CRM (se disponível), Especialidade e um número de WhatsApp comercial público.
- **Atribuição de Status**: Todo médico identificado entra no banco de dados com o status inicial "novo".
- **Dados Incompletos**: Registros que não possuem o telefone comercial ou nome identificável são descartados automaticamente pelo sistema antes de qualquer ação.

## SEÇÃO 3 — PREPARAÇÃO PARA CONTATO
- **Papel do Agent_Enricher**: Este agente valida a especialidade e tenta confirmar se o número de WhatsApp pertence de fato à clínica ou ao profissional.
- **Definição de Canal**: O canal prioritário é o WhatsApp comercial identificado publicamente.
- **Avaliação de Risco**: O sistema verifica se o profissional já foi contatado anteriormente (deduplicação) ou se pertence a uma especialidade com restrições de contato institucional.
- **Bloqueio Preventivo**: O sistema NÃO prossegue se detectar que o profissional já solicitou opt-out em outras campanhas ou se os dados parecem ser de natureza puramente pessoal.

## SEÇÃO 4 — CONTATO AUTOMATIZADO
- **Acionamento**: O `Agent_Contact_WhatsApp` é acionado apenas uma vez para cada lead no status "novo".
- **Escolha da Mensagem**: O sistema escolhe um dos templates aprovados (Padrão, Conservador ou Contextualizado) com base na confiabilidade dos dados coletados.
- **Registro do Envio**: O sistema grava a data, hora e o conteúdo exato da mensagem enviada, alterando o status para "aguardando resposta".
- **Mensagem Única**: O sistema está programado para nunca enviar uma segunda mensagem automática sem que haja uma resposta prévia do médico.

## SEÇÃO 5 — INTERPRETAÇÃO DE RESPOSTAS
O `Agent_Qualifier` analisa a resposta do médico e a classifica em um dos quatro estados:
- **interessado**: O médico demonstrou abertura clara (ex: "tenho interesse", "pode enviar").
- **neutro**: Resposta ambígua ou que solicita adiamento (ex: "hoje não consigo", "talvez depois"). O sistema para o contato.
- **rejeitou**: Recusa clara ou pedido de remoção (ex: "não quero", "pare").
- **sem_resposta**: O médico não interagiu após o prazo definido. O sistema encerra o fluxo silenciosamente.

## SEÇÃO 6 — ESCALONAMENTO PARA HUMANO
- **Momento do Handoff**: No exato instante em que o status "interessado" é detectado.
- **Informações Repassadas**: O Atendente Humano recebe o histórico completo da conversa, nome do médico, especialidade e o gatilho que gerou o interesse.
- **Silenciamento dos Agentes**: Uma vez que o humano assume, todos os agentes automáticos são desativados para aquele contato. Nenhuma mensagem automática será enviada enquanto houver controle humano.

## SEÇÃO 7 — ENCERRAMENTO DO FLUXO
O fluxo é encerrado automaticamente quando:
1. O médico é classificado como "rejeitou" ou "neutro".
2. O tempo limite de resposta expira ("sem_resposta").
3. O atendimento humano é concluído com ou sem sucesso comercial.
- **Garantia de Não-Recontato**: Registros encerrados ou em opt-out são marcados em uma lista de exclusão permanente, impedindo novos contatos automáticos no futuro.

## SEÇÃO 8 — EXEMPLOS OPERACIONAIS
- **Exemplo 1 (Interesse)**: O sistema envia mensagem padrão. O médico responde: "Sim, gostaria de saber mais". O `Agent_Qualifier` marca como "interessado", silencia a automação e notifica o humano, que assume a conversa 2 minutos depois.
- **Exemplo 2 (Rejeição)**: O sistema envia mensagem conservadora. O médico responde: "Não tenho interesse, por favor remover". O `Agent_Qualifier` marca como "rejeitou", insere o número na blacklist e o fluxo é encerrado imediatamente.
- **Exemplo 3 (Silêncio)**: O sistema envia mensagem de contexto. O médico visualiza mas não responde. Após 48 horas, o sistema altera o status para "sem_resposta" e arquiva o registro sem enviar novas mensagens.

## SEÇÃO 9 — PRINCÍPIOS DE SEGURANÇA E CONTROLE
- **Limites Rígidos**: Os agentes nunca têm autonomia para negociar preços, contratos ou fazer promessas.
- **Intervenção Humana**: A qualquer momento, um supervisor humano pode intervir em qualquer estágio do fluxo.
- **Postura Conservadora**: Em caso de incerteza sobre o tom da resposta do médico, o sistema deve classificar como "neutro" ou "rejeitou" para evitar abordagens inconvenientes.
- **Controle Final**: O controle final sobre a conclusão do processo comercial é sempre do ser humano capacitado.
