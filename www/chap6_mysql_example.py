import pymysql

conn = pymysql.connect(
    host='127.0.0.1',
    user="hdaza",
    password="password123",
    database="cms"
)

cur = conn.cursor()

try:
    cur.execute('select * from article;')
    results = cur.fetchall()
    for row in results:
        print(row)

finally:
    cur.close()
    conn.close()