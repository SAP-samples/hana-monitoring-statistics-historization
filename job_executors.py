# Python file which executes an SQL command and writes the output to a specified csv file

import datetime
from hdbcli import dbapi
import csv
import sys

# Input parameter:
# 1st Argument: target path with the file to output data to

# Change the key value to hdbuserstore key of the database. Reference:https://help.sap.com/docs/SAP_HANA_PLATFORM/b3ee5778bc2e4a089d3299b82ec762a7/ddbdd66b632d4fe7b3c2e0e6e341e222.html?version=2.0.05
# This script only retrieves the statistics from the indexserver (port 3xx03 where xx is instance number). Maintaining the value '%' retrieves the statistics for all services

# Connect to Database
# conn = dbapi.connect(address='', port=, user='', password='')
conn = dbapi.connect(key='')

cursor = conn.cursor()
sql_command = """SELECT

  J.HOST,
  LPAD(J.PORT, 5) PORT,
  LPAD(J.TOTAL_WORKER_COUNT, 5) TOTAL,
  LPAD(J.TOTAL_WORKER_COUNT - J.PARKED_WORKER_COUNT - J.FREE_WORKER_COUNT - J.SYS_WAITING_WORKER_COUNT -
    J.JOB_WAITING_WORKER_COUNT - J.YIELD_WAITING_WORKER_COUNT - 1, 4) BUSY,
  LPAD(J.PARKED_WORKER_COUNT, 6) PARKED,
  LPAD(J.FREE_WORKER_COUNT, 4) FREE,
  LPAD(J.SYS_WAITING_WORKER_COUNT, 7) SYSWAIT,
  LPAD(J.JOB_WAITING_WORKER_COUNT, 7) JOBWAIT,
  LPAD(J.YIELD_WAITING_WORKER_COUNT, 9) YIELDWAIT,
  LPAD(J.QUEUED_WAITING_JOB_COUNT, 6) QUEUED
FROM
( SELECT                        /* Modification section */
    '%' HOST,
    '30003' PORT
  FROM
    DUMMY
) BI,
  M_JOBEXECUTORS J
WHERE
  J.HOST LIKE BI.HOST AND
  TO_VARCHAR(J.PORT) LIKE BI.PORT
ORDER BY
  J.HOST,
  J.PORT
"""
cursor.execute(sql_command)
rows = cursor.fetchall()
# Write SQL statement response to csv file
with open(sys.argv[1], 'a', newline='') as fp:
            a = csv.writer(fp, delimiter=',')
            for row in rows:
                a.writerow([datetime.datetime.now()] + list(row))
cursor.close()

conn.close()
