#!/bin/bash
R="\e[31m"
G="\e[32m"
N="\e[0m"

echo -n "enter your number here : "
read num

if [ $num -gt 20 ]
then
    echo -e "$G Given number $num is greater than 20 $N"
elif [ $num -lt 20 ]
then
    echo "Given number $num is lesser than 20"
else
    echo "Givne number $num is equla to 20"
fi