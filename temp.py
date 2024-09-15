query1 = 'select id, name from instructor'
query2 = 'select id, upper(name) name from (select * from instructor)'
print(query2.upper())
print(query2.upper().index('FROM'))
a = query2.upper().index('FROM')
print(query2[a:])
print(query2[7:a])
column_names = query2[7:a]
print(column_names.split(','))
column_names = column_names.split(',')
column_names = [s.strip() for s in column_names]
print(column_names)
column_names = [s.split(' ')[-1] for s in column_names]
print(column_names)
print('id'.split(' ')[-1])