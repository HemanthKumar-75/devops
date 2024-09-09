#!/bin/bash

# Gathering the present userID details to verify
id=$(id -u)

# Defining the colors while displaying results
B="\e[1m"
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

# Checking the list of installed packages
dnf list installed mysql &>>$LOG_FILE

if [ $? -ne 0 ]; then
    echo -e "${R}MYSQL is not installed${N}, ${G}going to install...${N}" | tee -a $LOG_FILE
    dnf install mysql-server -y &>>$LOG_FILE
    VALIDATE $? "Installing MYSQL"
else
    echo -e "${G}MYSQL is already installed.${N}" | tee -a $LOG_FILE
fi

# Enabling MySQL server
systemctl enable mysqld &>>$LOG_FILE
VALIDATE $? "Enabling MySQL Server"

# Starting MySQL server
systemctl start mysqld &>>$LOG_FILE
VALIDATE $? "Starting MySQL Server"

# Password setting for the user in MySQL
mysql -h db.hemanthkumar.online -u root -pExpenseApp@1 -e 'show databases;' &>>$LOG_FILE

if [ $? -ne 0 ]; then
    echo -e "${R}MYSQL root setup is not done${N}, ${G}setting up now...${N}" | tee -a $LOG_FILE
    mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOG_FILE
    VALIDATE $? "Setting up root Password"
else
    echo -e "${G}MYSQL root password is already set up...${N} ${Y}Skipping${N}" | tee -a $LOG_FILE
fi
