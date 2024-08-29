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

# installing the nginx server
dnf install nginx -y &>>$LOG_FILE
VALIDATE $? "Installing Nginx"

# enabling the nginx services
systemctl enable nginx &>>$LOG_FILE
VALIDATE $? "Enable Nginx"

# starting the nginx services
systemctl start nginx &>>$LOG_FILE
VALIDATE $? "Start Nginx"

# removing the already existed html files
rm -rf /usr/share/nginx/html/* &>>$LOG_FILE
VALIDATE $? "Removing default website"

# downloading the application html code files
curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOG_FILE
VALIDATE $? "Downloding frontend code"

# unzipping the files
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>$LOG_FILE
VALIDATE $? "Extract frontend code"

# configuring the expense applicaiton
cp /home/ec2-user/expense-shell/expense.conf /etc/nginx/default.d/expense.conf
VALIDATE $? "Copied expense conf"

# restarting the services
systemctl restart nginx &>>$LOG_FILE
VALIDATE $? "Restarted Nginx"