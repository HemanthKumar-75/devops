#!/bin/bash

id=$(id -u)
#echo "id details are : $id"

if [ $id -ne 0 ]
then
    echo "please try to run with root previlages"
    exit 1
fi

dnf list installed mysql

if [ $? -ne 0 ]
then
    echo "MYSQL is not installed, going to install..."
    dnf install mysql -y
    if [ $? -ne 0 ]
    then
        echo "MYSQL installation got failure... check it..."
        exit 1
    else
        echo "MYSQL installation is SUCCESSFUL."
    fi
else
    echo "MYSQL is already installed."
fi