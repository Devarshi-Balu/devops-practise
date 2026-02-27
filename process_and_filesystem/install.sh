#!/bin/bash


set -euo pipefail


# scriptname.log

folder="./"
logFile="${folder}/${0}.log" # logFile path

userid=$(id -u)

echo "Folder is : $folder, \n logFile is $logFile" 


if [[ userid -ne 0 ]]; then 
    echo "Please login as the root user" | tee -a $logFile; 
else
    echo "package is installed have a great time" | tee -a  $logFile;
fi
