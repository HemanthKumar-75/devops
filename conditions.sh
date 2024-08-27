#!/bin/bash
echo -n "enter your number here : "
read num

if [num -gt 20]
then
    echo "Given number $num is greater than 20"
else
    if [num -eq 20]
    then
        echo "Given number $num is equal to 20"
    fi
fi