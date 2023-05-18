# Monitoring Data Historization for SAP HANA
[![REUSE status](https://api.reuse.software/badge/github.com/SAP-samples/hana-monitoring-statistics-historization)](https://api.reuse.software/info/github.com/SAP-samples/hana-monitoring-statistics-historization)
## Description
The repository contains a set of Python and Bash scripts that would help historize SAP HANA monitoring statistics.

The scripts in this repository are intended to historize the SAP HANA monitoring views (SYS.M_) for which there are no historical monitoring views (SYS_STATISTICS.HOST). Every historization comes with a combination of two scripts (Bash and Python); the Bash script is the anchor script that calls the Python script under the hood.

The bash script will take duration and interval specified by the user and run the respective SQL statement for each interval period up to the duration time. The output will be a csv file with the timestamp as its name in its suffix and the contents will be an aggregation of the output that was collected from the SQL statement over the duration period. New csv file created after maximum of 50K records.

### Usage:
To run task: \
sh job_executors.sh [Time to execute script in seconds] [Interval time between each statement execution in seconds] [Target Path to create csv file]
sh jobex_threadgroups.sh [Time to execute script in seconds] [Interval time between each statement execution in seconds] [Target Path where csv file should be created]

E.g. 1 : To collect the statistics for next 24 hours every 1 second in the trace directory of tenant
sh job_executors.sh 86400 1 \usr\sap\<SID>\HDB<instance ##>\<hostname>\DB_<Tenant Name>\


To background task: \
sh job_executors.sh [Time to execute script in seconds] [Interval time between each statement execution in seconds] [Target Path to create csv file] &
sh jobex_threadgroups.sh [Time to execute script in seconds] [Interval time between each statement execution in seconds] [Target Path where csv file should be created] &

E.g. 2 : To collect the statistics for next 24 hours every 1 second in the trace directory of tenant in background mode
sh job_executors.sh 86400 1 \usr\sap\<SID>\HDB<instance ##>\<hostname>\DB_<Tenant Name>\ &

Use command bg to view background tasks.

## Requirements
Tested with Python 3.8.12 and higher versions
Tested with SAP HANA 2.0 revision 59 and higher versions

## Download and Installation
1. The python script and bash script should be downloaded into the same folder. 
2. The scripts are executed as SAP HANA <SID>ADM user. The <SID>ADM user should have the necessary permissions to write into and create the csv files in the folder where these scripts are downloaded to.
3. In the python script, insert/change the database hdbuserstore key. The user maintained in the hdbuserstore key should have privileges: CATALOG_READ, SAP_INTERNAL_HANA_SUPPORT.
4. In the python script, modify the host, and port numbers against which these scripts are executed.

## Known Issues
No known issues.

## How to obtain support
This project is provided "as-is" and any bug reports are not guaranteed to be fixed.

## License
Copyright (c) 2023 SAP SE or an SAP affiliate company. All rights reserved. This project is licensed under the Apache Software License, version 2.0 except as noted otherwise in the [LICENSE](LICENSE) file.