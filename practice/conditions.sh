#!/bin/bash
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

echo -n "enter your number here : "
read num

if [ $num -gt 20 ]
then
    echo -e "$G Given number $num is greater than 20 $N"
elif [ $num -lt 20 ]
then
    echo -e "$R Given number $num is lesser than 20 $N"
else
    echo -e "$Y Givne number $num is equla to 20 $N"
fi