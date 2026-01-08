-- Database Schema for HealthPartner CRM
-- PostgreSQL Version

-- 1. ENUMS
CREATE TYPE doctor_status AS ENUM (
    'novo',
    'aguardando_resposta',
    'interessado',
    'neutro',
    'rejeitou',
    'sem_resposta',
    'em_atendimento_humano',
    'encerrado'
);

CREATE TYPE message_direction AS ENUM (
    'outbound',
    'inbound'
);

CREATE TYPE agent_type AS ENUM (
    'researcher',
    'enricher',
    'contact_whatsapp',
    'qualifier',
    'system',
    'human'
);

CREATE TYPE contact_type AS ENUM (
    'whatsapp',
    'email'
);

CREATE TYPE blacklist_reason AS ENUM (
    'rejeicao',
    'opt_out',
    'legal'
);

-- 2. TABLES

-- Table: doctors
-- Armazena médicos públicos identificados
CREATE TABLE IF NOT EXISTS doctors (
    id SERIAL PRIMARY KEY,
    nome_completo VARCHAR(255) NOT NULL,
    crm VARCHAR(50),
    especialidade VARCHAR(100) NOT NULL,
    status doctor_status NOT NULL DEFAULT 'novo',
    fonte_publica TEXT NOT NULL,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP WITH TIME ZONE -- Soft delete support
);

-- Table: contacts
-- Meios de contato públicos (WhatsApp é o canal principal)
CREATE TABLE IF NOT EXISTS contacts (
    id SERIAL PRIMARY KEY,
    doctor_id INTEGER NOT NULL REFERENCES doctors(id) ON DELETE RESTRICT,
    tipo contact_type NOT NULL,
    valor VARCHAR(255) NOT NULL,
    verificado BOOLEAN DEFAULT FALSE,
    principal BOOLEAN DEFAULT FALSE,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(doctor_id, tipo, valor)
);

-- Table: conversations
-- Registro de uma jornada de conversa única (1 conversa por canal por médico)
CREATE TABLE IF NOT EXISTS conversations (
    id SERIAL PRIMARY KEY,
    doctor_id INTEGER NOT NULL REFERENCES doctors(id) ON DELETE RESTRICT,
    canal contact_type NOT NULL DEFAULT 'whatsapp',
    status_atual doctor_status NOT NULL,
    iniciado_em TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    encerrado_em TIMESTAMP WITH TIME ZONE,
    UNIQUE(doctor_id, canal) -- Garante apenas uma conversa por canal
);

-- Table: messages
-- Histórico imutável de mensagens
CREATE TABLE IF NOT EXISTS messages (
    id SERIAL PRIMARY KEY,
    conversation_id INTEGER NOT NULL REFERENCES conversations(id) ON DELETE RESTRICT,
    direcao message_direction NOT NULL,
    conteudo TEXT NOT NULL,
    enviado_por agent_type NOT NULL,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Table: agent_actions
-- Auditoria de decisões e automações
CREATE TABLE IF NOT EXISTS agent_actions (
    id SERIAL PRIMARY KEY,
    agent agent_type NOT NULL,
    doctor_id INTEGER NOT NULL REFERENCES doctors(id) ON DELETE RESTRICT,
    acao VARCHAR(100) NOT NULL,
    justificativa_textual TEXT NOT NULL,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Table: blacklist
-- Bloqueio absoluto e irreversível
CREATE TABLE IF NOT EXISTS blacklist (
    id SERIAL PRIMARY KEY,
    doctor_id INTEGER UNIQUE NOT NULL REFERENCES doctors(id) ON DELETE RESTRICT,
    motivo blacklist_reason NOT NULL,
    criado_em TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. INDEXES
CREATE INDEX idx_doctors_status ON doctors(status);
CREATE INDEX idx_doctors_crm ON doctors(crm);
CREATE INDEX idx_contacts_doctor_id ON contacts(doctor_id);
CREATE INDEX idx_contacts_valor ON contacts(valor);
CREATE INDEX idx_conversations_doctor_id ON conversations(doctor_id);
CREATE INDEX idx_messages_conversation_id ON messages(conversation_id);
CREATE INDEX idx_agent_actions_doctor_id ON agent_actions(doctor_id);

-- 4. INTEGRITY CONSTRAINTS (Triggers/Functions for complex logic)

-- Function to prevent messages after blacklist
CREATE OR REPLACE FUNCTION check_blacklist_before_message()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM blacklist b
        JOIN conversations c ON b.doctor_id = c.doctor_id
        WHERE c.id = NEW.conversation_id
    ) THEN
        RAISE EXCEPTION 'Não é permitido enviar mensagens para um lead na blacklist.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_blacklist_message
BEFORE INSERT ON messages
FOR EACH ROW EXECUTE FUNCTION check_blacklist_before_message();

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.atualizado_em = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_doctors_updated_at
BEFORE UPDATE ON doctors
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
