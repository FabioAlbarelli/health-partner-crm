# Guia de Mensagens Institucionais: HealthPartner CRM

## 1. Introdução
Este guia define os padrões e templates obrigatórios para o primeiro contato automatizado via WhatsApp com profissionais de saúde. O objetivo único deste contato é abrir um canal de comunicação profissional e identificar interesse para futura interação humana, respeitando a privacidade e a ética da classe médica.

## 2. Categorias de Mensagens Permitidas

### CATEGORIA 1 — PRIMEIRO CONTATO PADRÃO
**Texto da Mensagem:**
"Olá, Dr(a). {NOME}.

Meu nome é {NOME_ATENDENTE} e faço parte de uma iniciativa voltada a parcerias institucionais na área da saúde.

Estamos entrando em contato apenas para verificar se o(a) senhor(a) tem interesse em receber informações profissionais em algum momento futuro.

Caso prefira não receber este tipo de contato, é só nos avisar."

- **Intenção:** Abrir canal profissional sem pressão comercial.
- **Uso:** Contato padrão para novos leads qualificados.

### CATEGORIA 2 — PRIMEIRO CONTATO CONSERVADOR
**Texto da Mensagem:**
"Olá, Dr(a). {NOME}.

Este é um contato institucional e pontual.
Gostaríamos apenas de confirmar se podemos encaminhar informações profissionais futuramente.

Se preferir não receber mensagens, basta nos informar."

- **Intenção:** Verificar abertura para contato com o mínimo de intrusão possível.
- **Uso:** Recomendado para especialidades sensíveis ou leads de risco médio.

### CATEGORIA 3 — PRIMEIRO CONTATO COM CONTEXTO DE ESPECIALIDADE
**Texto da Mensagem:**
"Olá, Dr(a). {NOME}.

Estamos realizando um mapeamento institucional com profissionais da área de {ESPECIALIDADE}.
O objetivo é apenas identificar possíveis interesses em informações profissionais futuras.

Fique à vontade para nos informar caso prefira não receber contato."

- **Intenção:** Contextualizar o contato através da área de atuação do profissional.
- **Uso:** Utilizar apenas quando a especialidade for confirmada em fontes públicas confiáveis.

---

## 3. Classificação de Respostas (Agent_Qualifier)

O `Agent_Qualifier` deve processar a resposta do destinatário e aplicar as seguintes classificações:

| Resposta do Médico (Exemplos) | Status Atribuído | Próxima Ação |
| :--- | :--- | :--- |
| "Sim", "Ok", "Pode enviar", "Tenho interesse", "Com certeza" | **interessado** | Handoff Humano Imediato |
| "Talvez", "Agora não", "No momento não", "O que seria?" | **neutro** | Arquivamento para re-engajamento futuro |
| "Não", "Não quero", "Pare", "Remova", "Não me mande nada" | **rejeitou** | Blacklist Permanente (Opt-out) |
| (Sem resposta após o período definido) | **sem_resposta** | Encerramento Silencioso |

---

## 4. Comportamentos Proibidos (Tolerância Zero)

Para evitar a caracterização de spam e proteger a reputação do sistema, as seguintes ações são estritamente proibidas:

- **Follow-up Automático:** É proibido enviar uma segunda mensagem automática caso não haja resposta.
- **Argumentação ou Persuasão:** O sistema não deve tentar convencer o médico ou rebater recusas.
- **Linguagem Comercial:** Proibido mencionar preços, contratos, vendas ou propostas financeiras.
- **Elementos Informais:** Proibido o uso de emojis, gírias ou linguagem coloquial.
- **Conteúdo Externo:** Proibido o envio de links, anexos, áudios, vídeos ou PDFs no primeiro contato.
- **Menção a Sistemas:** Nunca mencionar que o contato é realizado por "robôs", "IA" ou "automação".

## 5. Princípios de Execução
1. **Linguagem Humana:** As mensagens devem ser curtas e diretas, simulando a cortesia de um contato institucional real.
2. **Prioridade Humana:** Identificado o interesse, qualquer interação subsequente deve ser obrigatoriamente humana.
3. **Mecânica de Saída:** O encerramento do contato (Opt-out) deve ser processado de forma instantânea no banco de dados.
