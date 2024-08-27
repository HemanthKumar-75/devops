#!/bin/bash
echo -n "enter your number here : "
read num

if [ $num -gt 20 ]
then
    echo "Given number $num is greater than 20"
elif [ $num -lt 20 ]
    echo "Given number $num is lesser than 20"
else
    echo "Givne number $num is equla to 20"
fi