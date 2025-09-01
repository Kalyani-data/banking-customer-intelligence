import pandas as pd
import mysql.connector
from mysql.connector import Error
from tqdm import tqdm

# --- CONFIGURE YOUR DATABASE CONNECTION ---
db_config = {
    'host': 'name of the host',
    'user': 'username',        # <-- change to your MySQL username
    'password': 'Password',    # <-- change to your MySQL password
    'database': 'database name'     # <-- change to your MySQL database name
}

# --- CSV file and chunk size ---
csv_file = "completedtrans.csv"    # dataset path 
chunk_size = 10000

# --- Your existing table column order ---
insert_query = """
INSERT INTO CompletedTrans (
    trans_id, account_id, type, operation, amount, balance, k_symbol,
    bank, account, year, month, day, fulldate, fulltime, fulldatewithtime
) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
"""

try:
    conn = mysql.connector.connect(**db_config)
    cursor = conn.cursor()

    total_rows = sum(1 for _ in open(csv_file)) - 1  # Total rows excluding header
    pbar = tqdm(total=total_rows, desc="Importing Rows")

    for chunk in pd.read_csv(csv_file, chunksize=chunk_size):
        values = [tuple(row) for row in chunk.values]
        cursor.executemany(insert_query, values)
        conn.commit()
        pbar.update(len(chunk))

    pbar.close()
    cursor.close()
    conn.close()
    print("✅ Data imported successfully into CompletedTrans table!")

except Error as e:
    print("❌ MySQL Error:", e)
except Exception as ex:
    print("❌ General Error:", ex)


