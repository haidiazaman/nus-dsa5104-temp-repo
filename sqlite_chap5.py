import sqlite3
import csv_to_sqlite
import pandas as pd

options = csv_to_sqlite.CsvOptions(typing_style='full',encoding='utf-8')
input_files = [
    './kaggle_data/products.csv'
    './kaggle_data/sellers.csv'
]

# csv_to_sqlite.write_csv is a simple, datatype-guessing scripts that takes
# csv files as input and copies their contetns into a SQLite database

db_connection = sqlite3.connect('olist.db')
ss = """
SELECT * FROM products LIMIT 3;
"""

df = pd.read_sql_query(ss, db_connection)
print(df)

db_connection.close()