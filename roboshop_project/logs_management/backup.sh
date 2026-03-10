R="\e[31m"
Y="\e[32m"
G="\e[33m"
N="\e[0m"
userid=$(id -u)
logFolder="/var/log/backup-logs"
timestamp=$(date +"%Y-%m-%d-%H-%M-%S")
logFile="$logFolder/$timestamp.log"

SRC_DIR="$1"
DEST_DIR="$2"
NDAYS="${3:-14}"

echo -e "$R RED $G GREEN $Y YELLOW $N No color" 

if [[ userid -gt 0 ]]; then 
    echo "This script must be run as a root user, use sudo or switch to root user!!"; 
    exit 1
fi

script_doc(){
    echo "command:: ./backup.sh SrcDIR DestDir <days>Days<default=14>"
    exit 1
}

if [[ $# -lt 2 ]]; then 
    echo "Src or Dest directory is missing" 
    script_doc
fi

if [[ ! -d "$SRC_DIR" ]]; then 
    echo "Source directory doesnt exist"; 
    exit 1
elif [[ ! -d "$DEST_DIR" ]]; then 
    echo "Destination Directory doesnt exist"; 
    exit 1
fi

files=$(find "$SRC_DIR" -name "*.log" -mtime "+$NDAYS")

if [[ -z $files ]]; then 
    echo "No logs files found in the src directory" 
    exit 1 
fi

echo "performing_backup, files in the backup"
readlink -f $files

zip "$DEST_DIR/app-logs-$timestamp-backup.zip" $files

if [[ $? -ne 0 ]]; then 
    echo -e "$R there is an error in creating zip folder $N"; 
    exit 1 
fi 

echo "deleting the log files"
rm -f $files 
echo "success" 
exit 
