#!/bin/bash

USERID=$(id -u)
LOGS_FOLDER="/var/log/shell-roboshop"
LOGS_FILE="$LOGS_FOLDER/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

mkdir -p $LOGS_FOLDER 

if [[ "$USERID" -ne 0 ]]; then
    echo -e "$R Please run this script with root user access $N" | tee -a $LOGS_FILE
    exit 1
fi

VALIDATE(){
    if [[ $1 -ne 0 ]]; then
        echo -e "$2 ... $R FAILURE $N" | tee -a $LOGS_FILE
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N" | tee -a $LOGS_FILE
    fi
}

cat > /etc/yum.repos.d/mongo.repo <<EOF
[mongodb-org-7.0]
name=MongoDB Repository
baseurl="https://repo.mongodb.org/yum/redhat/9/mongodb-org/7.0/x86_64/"
enabled=1
gpgcheck=0
EOF

VALIDATE $? "creating MongoRepo File in yum.repos.d"

dnf install mongodb-org -y &>> $LOGS_FILE
VALIDATE $? "Installing Mongodb-org" 

systemctl enable mongod &>> $LOGS_FILE
VALIDATE $? "Enabling mongod service" 

systemctl start mongod 
VALIDATE $? "Starting mongod service" 

sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mongod.conf
VALIDATE $? "Allowing the connnections to mongodb from all Ip addresses" 

systemctl restart mongod
VALIDATE $? "restarting MongoDB" 
