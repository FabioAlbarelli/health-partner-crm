-- Database Schema for HealthPartner CRM WhatsApp Prospecting System
-- Target: SQLite or PostgreSQL

-- Table for Leads (Prospects)
CREATE TABLE IF NOT EXISTS leads (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    specialty VARCHAR(100) DEFAULT 'Urologist',
    crm VARCHAR(50),
    whatsapp VARCHAR(20) UNIQUE NOT NULL,
    email VARCHAR(255),
    city VARCHAR(100),
    entity VARCHAR(255), -- Clinic or Hospital
    source_url TEXT,
    status VARCHAR(50) DEFAULT 'Novo', -- Novo, WhatsApp Automático Enviado, Em Conversa, Interessado, Cliente, Rejeitou, Opt-out, Inativo
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for Interactions (Logs and Conversation History)
CREATE TABLE IF NOT EXISTS interactions (
    id SERIAL PRIMARY KEY,
    lead_id INTEGER REFERENCES leads(id),
    direction VARCHAR(10) NOT NULL, -- INBOUND or OUTBOUND
    message_content TEXT NOT NULL,
    interaction_type VARCHAR(50) DEFAULT 'WhatsApp', -- WhatsApp, Email, Call
    agent_id VARCHAR(50) DEFAULT 'Bot', -- Bot or Human Name
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for Campaigns
CREATE TABLE IF NOT EXISTS campaigns (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    target_specialty VARCHAR(100),
    status VARCHAR(50) DEFAULT 'Draft', -- Draft, Active, Completed
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Index for performance
CREATE INDEX IF NOT EXISTS idx_leads_whatsapp ON leads(whatsapp);
CREATE INDEX IF NOT EXISTS idx_leads_status ON leads(status);
CREATE INDEX IF NOT EXISTS idx_interactions_lead_id ON interactions(lead_id);
