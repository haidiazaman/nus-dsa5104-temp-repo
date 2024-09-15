import pandas as pd
from sqlalchemy import create_engine, text

engine = create_engine('sqlite://chicago.db')

df = pd.read_csv('./data/chicago_crime_2012.csv')
df.to_sql('chicago_crime', engine, index=False, if_exists='replce')

# add other csvs here
# df = pd.read_csv('./data/sample.csv')
# df.to_sql('chicago_school', engine, index=False, if_exists='replce')

with engine.connect() as connection:
    query = text(
        "SELECT * FROM chicago_crime LIMIT 2"
    )
    result = connection.execute(query).fetchall()
    print(result)    