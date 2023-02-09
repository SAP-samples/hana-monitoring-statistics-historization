# Python file which executes an SQL command and writes the output to a specified csv file

import datetime
from hdbcli import dbapi
import csv
import sys

# Input parameter:
# 1st Argument: target path with the file to output data to

# This script only retrieves the statistics from the indexserver (port 3xx03 where xx is instance number). Maintaining the value '%' retrieves the statistics for all services

# Connect to Database
# conn = dbapi.connect(address='', port=, user='', password='')
conn = dbapi.connect(key='')

cursor = conn.cursor()
sql_command = """SELECT * FROM SYS.M_DEV_JOBEX_THREADGROUPS WHERE PORT = '%';"""
cursor.execute(sql_command)
rows = cursor.fetchall()
# Write SQL statement response to csv file
with open(sys.argv[1], 'a', newline='') as fp:
            a = csv.writer(fp, delimiter=',')
            for row in rows:
                a.writerow([datetime.datetime.now()] + list(row))
cursor.close()

conn.close()
