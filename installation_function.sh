#!/bin/bash

id=$(id -u)
#echo "id details are : $id"
B="\e[1m"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

#root user permission checking
if [ $id -ne 0 ]
then
    echo -e " $B $R please try to run with root previlages $N $N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$B $R $2 is ... failed $N $N"
        exit 1
    else
        echo "$B $G $2 is ... success $N $N"
    fi
}

#checking the list installed packages
dnf list installed mysql

if [ $? -ne 0 ]
then
    echo "MYSQL is not installed, going to install..."
    dnf install mysql -y
    VALIDATE $? "Installing MYSQL"
else
    echo -e "$B MYSQL is already installed. $N"
fi

dnf list installed nginx

if [ $? -ne 0 ]
then
    echo "NGINX is not installed, going to install..."
    dnf install nginx -y
    VALIDATE $? "Installing NGINX"
else
    echo -e "$B NGINX is already installed. $N"
fi