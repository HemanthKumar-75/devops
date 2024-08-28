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
    echo -e " $R please try to run with root previlages $N"
    exit 1
fi

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 $R is ... failed $N"
        exit 1
    else
        echo "$2 $G is ... success $N"
    fi
}

#checking the list installed packages
dnf list installed mysql

if [ $? -ne 0 ]
then
    echo "$R MYSQL is not installed $N,$G going to install...$N"
    dnf install mysql -y
    VALIDATE $? "Installing MYSQL"
else
    echo -e "$G MYSQL is already installed. $N"
fi

dnf list installed nginx

if [ $? -ne 0 ]
then
    echo -e "$R NGINX is not installed $N,$G going to install...$N"
    dnf install nginx -y
    VALIDATE $? "Installing NGINX"
else
    echo -e "$G NGINX is already installed. $N"
fi