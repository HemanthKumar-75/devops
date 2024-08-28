#!/bin/bash

# gathering the present userID details to verify
id=$(id -u)
# echo "id details are : $id"
# defining the colors while displaying results
B="\e[1m"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

#creating the logs and some folders to generate logs
LOGS_FOLDER="/var/log/expense"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIMESTAMP.log"
mkdir -p $LOGS_FOLDER

#root user permission checking
if [ $id -ne 0 ]
then
    echo -e " $R please try to run with root previlages $N" | tee -a $LOG_FILE
    exit 1
fi

#validating the commands exit status.
VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 $R is ... failed $N" | tee -a $LOG_FILE
        exit 1
    else
        echo -e "$2 $G is ... success $N" | tee -a $LOG_FILE
    fi
}

#recording the execution timestamp
echo "Script started executing at : $(date)" | tee -a $LOG_FILE

#checking the list installed packages
dnf list installed mysql &>>$LOG_FILE

if [ $? -ne 0 ]
then
    echo -e "$R MYSQL is not installed $N,$G going to install...$N" | tee -a $LOG_FILE
    dnf install mysql -y
    VALIDATE $? "Installing MYSQL" | tee -a $LOG_FILE
else
    echo -e "$G MYSQL is already installed. $N" | tee -a $LOG_FILE
fi

# password setting for the user in mysql
mysql -h mysql.hemanthkumar.online -u root -pExpenseApp@1 -e 'showdatabases;' &>>LOG_FILE

if [ &? -ne 0 ]
then
    echo -e "$R MYSQL root setup is not setup$N,$G setting up now...$N" &>>LOG_FILE
    mysql_secure_installation --set-root-pass ExpenseApp@1
    VALIDATE $? "Setting up root Password"
else
    echo -e "$G MYSQL root password is already setup...$N $Y Skipping $N" | tee -a $LOG_FILE