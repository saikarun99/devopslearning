#!/bin/bash



echo $a

b=xyz

echo $b

#everything is string in linux

echo "printing the value of $a"

DATE="$(date +%F)"

echo "Today's date is $DATE"



#If you are using special characters then enclose them in a double quotations ""

SESSION_COUNT= "$(who | wc -l)"

echo "$SESSION_COUNT"