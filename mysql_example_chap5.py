import pymysql
import getpass
import pandas as pd


def get_columns_from_query(query):
    """
    query is a string like
    select id, name from instructor ....
    or
    select * from instructor ...

    if * is used, then this function just returns [], 
    else function will return list of column names
    """
    get_index_of_FROM_in_query = query.upper().index('FROM')
    column_names = query[7:get_index_of_FROM_in_query]

    if '*' in column_names:
        # if * is used then just skip getting column names
        return []
    else:
        column_names = column_names.split(',')
        column_names = [s.strip() for s in column_names] # strip() method removes any leading, and trailing whitespaces
        column_names = [s.split(' ')[-1] for s in column_names] # gets the column name for queries where select statement is select upper(name) name, id from ...
        return column_names


if __name__ == "__main__":

    conn = pymysql.connect(
        host = '127.0.0.1',
        user='root',
        passwd=getpass.getpass(),
        database='university'
    )

    cur = conn.cursor()

    try:
        query = input("Enter your MySQL query: ")
        cur.execute(query)
        results = cur.fetchall()

        column_names = get_columns_from_query(query=query)
        if column_names:
            # set column names for the csv accordingly
            df = pd.DataFrame(results,columns=column_names)
            df.to_csv('sample_query.csv',index=False)    

            print("Displaying first 5 rows")
            print(column_names)
            for row in results[:5]:
                print(row)
        else:
            # dont set column names
            df = pd.DataFrame(results)
            df.to_csv('sample_query.csv',index=False) 

            print("Displaying first 5 rows")
            # dont display column names since * was used in select clause of query
            for row in results[:5]:
                print(row)
                
    except Exception as e:
        print(e)

    finally:
        # important to close both cur and conn to ensure there is no connection leak
        cur.close()
        conn.close()