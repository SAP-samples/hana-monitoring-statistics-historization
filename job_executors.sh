#!/bin/bash

# Bash script to repeatedly run a query based on a speciied interval, for a specified amount of time. The output will be
# written to a csv file that will be created in the specified target path. The respective python file with the SQL
# statement must be in the same directory as this file.

# Input Parameters
# 1st Argument should be the amount of time(in seconds)  that the script is executed
# 2nd Argument Interval time(in seconds) between each statement execution
# 3rd Argument target path

# Mandatory change
# In the corresponding python script "job_executors.py", please insert/change the database hdbuserstore key

if [ $# -ne 3 ]
  then
    echo "Specify 3 arguments"
    echo "Usage: job_executors.sh [Time to execute script in seconds] [Interval time between each statement execution in seconds] [Target Path to create csv file]"
    exit 1
fi

targetPath=$3

echo "Start Time: `date +%F-%H_%M_%S`"

fileDate="$targetPath/Job_Executors_`date +%F-%H_%M_%S`.csv"

header="Time,HOST,PORT,TOTAL,BUSY,PARKED,FREE,SYSWAIT,JOBWAIT,YIELDWAIT,QUEUED"

echo $header >> $fileDate

SECONDS=0
while true
do
    # If the number of rows in the csv file is greater than or equal to 50000, then a new file will be created with the name being the
    # timestamp at that time.
    if [ $(wc -l < $fileDate) -ge 50000 ];then
        echo "More than 50000"
        fileDate="$targetPath/`date +%F-%H_%M_%S`.csv"
        echo $header >> $fileDate
    fi
    # Run python script which contains the actual query
    python job_executors.py $fileDate
    # If the python file does not execute successfully, the program will exit
    exit_status=$?
    if [ "${exit_status}" -ne 0 ];
    then
        echo "Issue with SQL command/file see error"
        exit 1
    fi
    # If the execution time has passed the specified time of execution, the program exits
    if [ $SECONDS -ge $1 ];then
       echo "The script successfully ran for $1 seconds, exiting now.."
       echo "End time: `date +%F-%H_%M_%S`"
       break
    else
       sleep $2
    fi
done
