#!/bin/bash

number1=$1
number2=$2

sum=$(($number1+$number2))
MUL=$(($number1*$number2))
DIV=$(($number1/$number2))
SUB=$(($number1-$number2))

echo "summation of $number1 and $number2 is equals to : $SUM"
echo "multiplication of $number1 and $number2 is equals to : $MUL"
echo "division of $number1 and $number2 is equals to : $DIV"
echo "substraction of $number1 and $number2 is equals to : $SUB"