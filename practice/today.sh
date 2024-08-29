#!/bin/bash

Date=$(date +%d-%m-%Y)
Time=$(date +%T)
Time_2=$(date +%H:%M:%S:%N)
time_zone=$(date +%:::z+%Z)

echo "Today date is : $Date"
echo "present time in(HH:MM:SS) : $Time"
echo "present time in(H:M:S:N) : $Time_2"
echo "TimeZone details are : $time_zone"