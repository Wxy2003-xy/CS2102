import csv

def read_csv(csvfilename):
  """
  Read .csv file.
  - file: the .csv file with the full path
  """
  rows = []
  with open(csvfilename, encoding='utf-8') as csvfile:
    file_reader = csv.reader(csvfile)
    for row in file_reader:
      rows.append(row)
  return rows
# Example usage
#   ensure that 'menu.csv' is in the same directory


for menu in read_csv('menu.csv')[1:]:
    cuisine_sql = menu[-1].strip().replace("'", "''")
    print(f"INSERT INTO Cuisines (Cuisine) VALUES ('{cuisine_sql}') ON CONFLICT DO NOTHING;")
for menu in read_csv('menu.csv')[1:]:
  print(f"""INSERT INTO Menu (Item, Price, Cuisine) VALUES ('{"', '".join(menu)}');""")

for staff in read_csv('staff.csv')[1:]:
  print(f"""INSERT INTO Staff (Staff, Name, Cuisine) VALUES ('{"', '".join(staff)}');""")
rows = read_csv('registration.csv')
hdr = rows[0]
ix = {name: i for i, name in enumerate(hdr)}
for row in read_csv('registration.csv')[1:]:
  date        = row[ix['Date']].strip()
  time_       = row[ix['Time']].strip()
  phone       = row[ix['Phone']].strip()
  firstname   = row[ix['Firstname']].strip()
  lastname    = row[ix['Lastname']].strip()
  firstname = firstname.replace("'", "''")
  lastname  = lastname.replace("'", "''")
  print(f"""INSERT INTO Registrations (Date, Time, Phone, FirstName, LastName) 
        VALUES ('{date}', '{time_}', '{phone}', '{firstname}','{lastname}');""")
rows = read_csv('order.csv')
hdr = rows[0]
ix = {name: i for i, name in enumerate(hdr)}
def sql_str(s):
    s = s.strip()
    return "NULL" if s == "" else s.replace("'", "''")
for row in rows[1:101]:
  date        = row[ix['Date']].strip()
  time_       = row[ix['Time']].strip()
  order_id    = row[ix['Order']].strip()
  payment     = row[ix['Payment']].strip().lower()
  card        = row[ix['Card']].strip()
  card_type   = row[ix['CardType']].strip()
  item        = row[ix['Item']].strip()
  total_price = row[ix['TotalPrice']].strip()
  phone       = row[ix['Phone']].strip()
  firstname   = row[ix['Firstname']].strip()
  lastname    = row[ix['Lastname']].strip()
  firstname = firstname.replace("'", "''")
  lastname  = lastname.replace("'", "''")
  staff       = row[ix['Staff']].strip()
  print(f"""INSERT INTO Orders 
        (Date, Time, "Order", Payment, Card, CardType, TotalPrice, Phone) 
        VALUES ('{date}', '{time_}','{order_id}','{payment}','{sql_str(card)}','{sql_str(card_type)}',{total_price},'{sql_str(phone)}') 
        ON CONFLICT DO NOTHING;""")

for row in rows[1:101]:
    order_id = row[ix['Order']].strip()
    item     = row[ix['Item']].strip()
    staff    = row[ix['Staff']].strip()
    if not (order_id and item and staff):
        continue
    item_sql  = item.replace("'", "''")
    staff_sql = staff.replace("'", "''")

    print(f"""INSERT INTO OrderLines ("Order", Item, Cuisine, Staff, Quantity)
          SELECT '{order_id}', '{item_sql}', m.Cuisine, '{staff_sql}', 1
          FROM Menu m
          WHERE m.Item = '{item_sql}'
          ON CONFLICT ("Order", Item, Staff)
          DO UPDATE SET Quantity = OrderLines.Quantity + EXCLUDED.Quantity;""")
