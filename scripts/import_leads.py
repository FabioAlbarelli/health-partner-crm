import csv
import sqlite3
import os
import re

# Database configuration
DB_PATH = 'health_partner.db'
SCHEMA_PATH = 'schema.sql'

def normalize_whatsapp(phone):
    """Simple normalization for Brazilian WhatsApp numbers."""
    digits = re.sub(r'\D', '', phone)
    if not digits:
        return None
    # Add country code if missing
    if len(digits) == 11 and digits.startswith('11'): # Example for SP
        digits = '55' + digits
    elif len(digits) == 9:
        # Assuming local number without DDD, this is risky but here for POC
        pass
    return digits

def init_db():
    """Initializes the database using the schema file."""
    if not os.path.exists(DB_PATH):
        print(f"Creating database at {DB_PATH}...")
        conn = sqlite3.connect(DB_PATH)
        with open(SCHEMA_PATH, 'r') as f:
            schema = f.read()
            # SQLite doesn't support SERIAL or specific Postgres syntax, 
            # so we adapt for the POC.
            schema = schema.replace('SERIAL PRIMARY KEY', 'INTEGER PRIMARY KEY AUTOINCREMENT')
            schema = schema.replace('TIMESTAMP DEFAULT CURRENT_TIMESTAMP', 'DATETIME DEFAULT CURRENT_TIMESTAMP')
            conn.executescript(schema)
        conn.close()
    else:
        print("Database already exists.")

def import_from_csv(file_path):
    """Imports leads from a CSV file with deduplication."""
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    
    count_new = 0
    count_skip = 0

    try:
        with open(file_path, mode='r', encoding='utf-8') as f:
            reader = csv.DictReader(f)
            for row in reader:
                name = row.get('nome')
                whatsapp = normalize_whatsapp(row.get('whatsapp'))
                specialty = row.get('especialidade', 'Urologista')
                city = row.get('cidade')
                entity = row.get('entidade')

                if not whatsapp:
                    print(f"Skipping {name}: Invalid WhatsApp")
                    count_skip += 1
                    continue

                # Deduplication check
                cursor.execute("SELECT id FROM leads WHERE whatsapp = ?", (whatsapp,))
                if cursor.fetchone():
                    print(f"Skipping {name}: Duplicate WhatsApp {whatsapp}")
                    count_skip += 1
                    continue

                # Insert new lead
                cursor.execute("""
                    INSERT INTO leads (name, whatsapp, specialty, city, entity, status)
                    VALUES (?, ?, ?, ?, ?, 'Novo')
                """, (name, whatsapp, specialty, city, entity))
                count_new += 1

        conn.commit()
    except Exception as e:
        print(f"Error during import: {e}")
        conn.rollback()
    finally:
        conn.close()

    print(f"Import finished: {count_new} new leads, {count_skip} skipped.")

if __name__ == "__main__":
    init_db()
    import_from_csv('scripts/sample_leads.csv')
    print("Importer execution complete.")
