#!/bin/bash

id=$(id -u)
#echo "id details are : $id"

if [ $id -eq 0 ]
then
    dnf list installed mysql
else
    echo "please try to run with root previlages"
#    exit 1