#!/bin/bash
set -euo pipefail

trap 'echo Exiting due to an error !!! , command: $BASH_COMMAND, LINE_NO: $LINENO , script: $0' ERR

echo "Printing the script params $@"

function validate(){
    echo "The '\$0 still printing the script name inside the function : $0" 
    echo "Checking for \$@ inside the fucntions $@" 
    exit 1 # main script exits when the function fails
    echo "Checking for \$* inside the fucntions $*" 
}

value=$(validate func_param1 func_param2 func_param3 func_param4)  # without "set -e" , this line would not cause the error 

echo $value
echo "script finished"