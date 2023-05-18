#!/bin/bash

# Bash script to repeatedly run a query based on a speciied interval, for a specified amount of time. The output will be
# written to a csv file that will be created in the specified target path. The respective python file with the SQL
# statement must be in the same directory as this file.

# Input Parameters
# 1st Argument should be the amount of time that the script is executed in seconds
# 2nd Argument Interval time between each statement execution in seconds
# 3rd Argument target path

# Mandatory change
# In the corresponding python script "jobex_threadgroups.py", please insert/change the database hdbuserstore key

if [ $# -ne 3 ]
  then
    echo "Specify 3 arguments"
    echo "Usage: jobex_threadgroups.sh [Time to execute script in seconds] [Interval time between each statement execution in seconds] [Target Path where csv file should be created]"
    exit 1
fi

targetPath=$3

echo "Start Time: `date +%F-%H_%M_%S`"

fileDate="$targetPath/Jobex_Threadgroups_`date +%F-%H_%M_%S`.csv"

header="STATISTICS_NAME, THREAD_GROUP, TOTALOPEN_COUNT,
PRIOQUEUE_COUNT, TOKENS_COUNT, AVG_WAIT_IN_QUEUE_TIME_I,
AVG_WAIT_IN_QUEUE_TIME_S, AVG_WAIT_IN_QUEUE_TIME_N,
QUEUE_RUNNING_EMPTY_COUNT, COMPLETED_JOBS_COUNT,
COMPLETED_JOBGRAPHS_COUNT, COMPLETED_SHORT_JOBGRAPHS_COUNT,
OPEN_NOPREF_PRIMARY_COUNT, OPEN_NUMAPREF_PRIMARY_COUNT,
OPEN_NOSTEAL_PRIMARY_COUNT, OPEN_SYSTEM_PRIMARY_COUNT,
OPEN_SHORT_PRIMARY_COUNT, OPEN_OTHER_PRIMARY_COUNT,
 JOBBARRIER_WAIT_COUNT, JOBBARRIER_WAIT_ESTCPU,
 JOBS_WORKED_SYSTEM_OWNGROUP_COUNT, JOBS_WORKED_SYSTEM_NEIGHBORGROUP_COUNT,
 JOBS_WORKED_SYSTEM_OTHERGROUPCOUNT, JOBS_WORKED_NOPREF_OWNGROUP_COUNT,
 JOBS_WORKED_NOPREF_NEIGHBORGROUP_COUNT, JOBS_WORKED_NOPREF_OTHERGROUPCOUNT,
 JOBS_WORKED_NUMAPREF_OWNGROUP_COUNT, JOBS_WORKED_NUMAPREF_NEIGHBORGROUP_COUNT,
 JOBS_WORKED_NUMAPREF_OTHERGROUPCOUNT, JOBS_WORKED_NOSTEAL_OWNGROUP_COUNT,
 JOBS_WORKED_NOSTEAL_NEIGHBORGROUP_COUNT, JOBS_WORKED_NOSTEAL_OTHERGROUPCOUNT,
 JOBS_WORKED_IMMEDIATE_OWNGROUP_COUNT, JOBS_WORKED_IMMEDIATE_NEIGHBORGROUP_COUNT,
 JOBS_WORKED_IMMEDIATE_OTHERGROUP_COUNT, JOBS_WORKED_SHORTRUNNING_OWNGROUP_COUNT,
 JOBS_WORKED_SHORTRUNNING_NEIGHBORGROUP_COUNT, JOBS_WORKED_SHORTRUNNING_OTHERGROUP_COUNT,
 JOBS_INSERTED_SYSTEM_OWNGROUP_COUNT, JOBS_INSERTED_SYSTEM_OTHERGROUP_COUNT,
 JOBS_INSERTED_NOPREF_OWNGROUP_COUNT, JOBS_INSERTED_NOPREF_OTHERGROUP_COUNT,
 JOBS_INSERTED_NUMAPREF_OWNGROUP_COUNT, JOBS_INSERTED_NUMAPREF_OTHERGROUP_COUNT,
 JOBS_INSERTED_NOSTEAL_OWNGROUP_COUNT, JOBS_INSERTED_NOSTEAL_OTHERGROUP_COUNT,
 JOBS_INSERTED_IMMEDIATE_OWNGROUP_COUNT, JOBS_INSERTED_SHORTRUNNING_OWNGROUP_COUNT,
 JOBS_INSERTED_SHORTRUNNING_OTHERGROUP_COUNT, LOCAL_SIGNALS_COUNT, TO_DISPATCHER_SIGNALS_COUNT,
 FROM_DISPATCHER_SIGNALS_COUNT, MAX_CONCURRENCY_CONFIG, MAX_CONCURRENCY_DYNAMIC, TOTAL_WORKER_COUNT,
 PARKED_JOB_WORKER_COUNT, WORKING_JOB_WORKER_COUNT, FREE_JOB_WORKER_COUNT,      SYS_WAITING_JOB_WORKER_COUNT,
 JOB_WAITING_JOB_WORKER_COUNT,  WORKING_SQL_WORKER_COUNT, FREE_SQL_WORKER_COUNT, SYS_WAITING_SQL_WORKER_COUNT,
 JOB_WAITING_SQL_WORKER_COUNT, WORKING_NET_WORKER_COUNT, FREE_NET_WORKER_COUNT, SYS_WAITING_NET_WORKER_COUNT,
 JOB_WAITING_NET_WORKER_COUNT, YIELD_WAITING_WORKER_COUNT, OTHER_THREADS_COUNT, OTHER_THREADS_RUNNING_COUNT,
 UNASSIGNED_THREADS_COUNT, UNASSIGNED_THREADS_RUNNING_COUNT, STEALING_LIMIT_NEIGHBORS, STEALING_TOKEN_NEIGHBORS,
 STEALING_LIMIT_NON_NEIGHBORS, STEALING_TOKEN_NON_NEIGHBORS, RUNNING_LIMIT_NEIGHBORS, RUNNING_TOKEN_NEIGHBORS,
 RUNNING_LIMIT_NON_NEIGHBORS, RUNNING_TOKEN_NON_NEIGHBORS,      WORKER_CREATE_COUNT, WORKER_TERMINATE_COUNT,
 DYNAMIC_CONCURRENCY_HINT, HOST,  PORT,  SITE_ID"

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
    python jobex_threadgroups.py $fileDate
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