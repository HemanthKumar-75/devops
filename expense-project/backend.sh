#!/bin/bash

# Gathering the present userID details to verify
id=$(id -u)

# Defining the colors while displaying results
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

# Creating the logs and some folders to generate logs
LOGS_FOLDER="/var/log/expense"
SCRIPT_NAME=$(basename $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIMESTAMP.log"

mkdir -p $LOGS_FOLDER

# Root user permission checking
if [ $id -ne 0 ]; then
    echo -e "${R}Please try to run with root privileges${N}" | tee -a $LOG_FILE
    exit 1
fi

# Validating the command's exit status
VALIDATE() {
    if [ $1 -ne 0 ]; then
        echo -e "$2 ${R}is ... failed${N}" | tee -a $LOG_FILE
        exit 1
    else
        echo -e "$2 ${G}is ... success${N}" | tee -a $LOG_FILE
    fi
}

# Recording the execution timestamp
echo "Script started executing at : $(date)" | tee -a $LOG_FILE

# diabling the existing application
dnf modules disable nodejs -y &>>$LOG_FILE
VALIDATE $? "Disabled default Nodejs"

#enabling the new version of application
dnf module enable nodejs:20 -y &>>$LOG_FILE
VALIDATE $? "Enabling the new version of Nodejs:20"

#installing the enabled version of application
dnf install nodejs -y &>>$LOG_FILE
VALIDATE $? "Install nodejs"

#checking the user with ID
id expense &>>$LOG_FILE

#if the user exists no issues, if not will creates.
if [ $? -ne 0 ]
then
    echo -e "${R}expense user is not exists...${N} ${G}going to create user${N}" &>>$LOG_FILE
    useradd expense &>>$LOG_FILE
    VALIDATE $? "user is created."
else
    echo -e "${G}expense user is already exist...${N} ${Y}SKIPPING${N}" &>>$LOG_FILE
fi

#creating the directory
mkdir -p /app &>>$LOG_FILE

#validate the directory
VALIDATE $? "creating the /app folder" &>>$LOG_FILE

#downloading the required configuration files from URL
curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOG_FILE
VALIDATE $? "Downloading the backend application"

cd /app
rm -rf /app/*  &>>$LOG_FILE # removing the existing files
unzip /tmp/backend.zip &>>$LOG_FILE
VALIDATE $? "Extracting the files into application folder"

#installing the requiried library files
npm install &>>$LOG_FILE
cp /home/ec2-user/devops/expense-project/backend.service /etc/systemd/system/backend.service  &>>$LOG_FILE

#installing the application client
dnf install mysql -y &>>$LOG_FILE
VALIDATE $? "Installing MySQL Client"

#creating the schema and pushing into main DB
mysql -h db.hemanthkumar.online -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>$LOG_FILE
VALIDATE $? "Schema loading"

#reloading the services
systemctl daemon-reload &>>$LOG_FILE
VALIDATE $? "Daemon reload"

#enabling the backend services
systemctl enable backend &>>$LOG_FILE
VALIDATE $? "Enabled backend"

#starting the backend services
systemctl restart backend &>>$LOG_FILE
VALIDATE $? "Restarted Backend"
