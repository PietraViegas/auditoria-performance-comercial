import pandas as pd
from sqlalchemy import create_engine
import sys

print("1. Iniciando o script...")

# --- CONFIGURAÇÃO DO SEU MYSQL LOCAL ---
USER = 'root'            
PASSWORD = '####'   
HOST = 'localhost'       
PORT = '####'            
DATABASE = 'superestore' 

try:
    # String de conexão local
    print("2. Conectando ao MySQL...")
    engine = create_engine(f'mysql+pymysql://{USER}:{PASSWORD}@{HOST}:{PORT}/{DATABASE}')

    print("3. Lendo o arquivo 'Sample - Superstore.csv'...")
    df = pd.read_csv('Sample - Superstore.csv', encoding='latin1')
    print(f"   -> CSV lido com sucesso! Total de linhas: {len(df)}")

    # Padroniza os nomes das colunas
    df.columns = df.columns.str.replace(' ', '_').str.replace('-', '_').str.lower()

    print("4. Enviando dados para o banco de dados...")
    df.to_sql('superstore', engine, if_exists='replace', index=False, chunksize=2000)

    print("\n✅ SUCESSO! A tabela 'superstore' foi criada e populada no MySQL!")

except Exception as e:
    print(f"\n❌ ERRO ENCONTRADO:\n{e}")