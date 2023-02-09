# SAP-samples/repository-template
This default template for SAP Samples repositories includes files for README, LICENSE, and .reuse/dep5. All repositories on github.com/SAP-samples will be created based on this template.

# Containing Files

1. The LICENSE file:
In most cases, the license for SAP sample projects is `Apache 2.0`.

2. The .reuse/dep5 file: 
The [Reuse Tool](https://reuse.software/) must be used for your samples project. You can find the .reuse/dep5 in the project initial. Please replace the parts inside the single angle quotation marks < > by the specific information for your repository.

3. The README.md file (this file):
Please edit this file as it is the primary description file for your project. You can find some placeholder titles for sections below.

# Monitoring Data Historization for SAP HANA
<!-- Please include descriptive title -->

<!--- Register repository https://api.reuse.software/register, then add REUSE badge:
[![REUSE status](https://api.reuse.software/badge/github.com/SAP-samples/REPO-NAME)](https://api.reuse.software/info/github.com/SAP-samples/REPO-NAME)
-->

## Description
The repository contains a set of Python and Bash scripts that would help historize SAP HANA monitoring statistics.

The scripts in this repository are intended to historize the SAP HANA monitoring views (SYS.M_) for which there are no historical monitoring views (SYS_STATISTICS.HOST). Every historization comes with a combination of two scripts (Bash and Python); the Bash script is the anchor script that calls the Python script under the hood.

The bash script will take duration and interval specified by the user and run the respective SQL statement for each interval period up to the duration time. The output will be a csv file with the timestamp as its name in its suffix and the contents will be an aggregation of the output that was collected from the SQL statement over the duration period. New csv file created after maximum of 50K records.

### Usage:

To run task: \
sh job_executors.sh [Time to execute script in seconds] [Interval time between each statement execution in seconds] [Target Path to create csv file]
sh jobex_threadgroups.sh [Time to execute script in seconds] [Interval time between each statement execution in seconds] [Target Path where csv file should be created]

E.g. 1 : To collect the statistics for next 24 hours every 1 second in the trace directory of tenant
sh job_executors.sh 1 86400 \usr\sap\<SID>\HDB<instance ##>\<hostname>\DB_<Tenant Name>\


To background task: \
sh job_executors.sh [Time to execute script in seconds] [Interval time between each statement execution in seconds] [Target Path to create csv file] &
sh jobex_threadgroups.sh [Time to execute script in seconds] [Interval time between each statement execution in seconds] [Target Path where csv file should be created] &

E.g. 2 : To collect the statistics for next 24 hours every 1 second in the trace directory of tenant in background mode
sh job_executors.sh 1 86400 \usr\sap\<SID>\HDB<instance ##>\<hostname>\DB_<Tenant Name>\ &

Use command bg to view background tasks.


## Requirements

## Download and Installation

## Known Issues
<!-- You may simply state "No known issues. -->

## How to obtain support
[Create an issue](https://github.com/SAP-samples/<repository-name>/issues) in this repository if you find a bug or have questions about the content.
 
For additional support, [ask a question in SAP Community](https://answers.sap.com/questions/ask.html).

## Contributing
If you wish to contribute code, offer fixes or improvements, please send a pull request. Due to legal reasons, contributors will be asked to accept a DCO when they create the first pull request to this project. This happens in an automated fashion during the submission process. SAP uses [the standard DCO text of the Linux Foundation](https://developercertificate.org/).

## License
Copyright (c) 2023 SAP SE or an SAP affiliate company. All rights reserved. This project is licensed under the Apache Software License, version 2.0 except as noted otherwise in the [LICENSE](LICENSE) file.
