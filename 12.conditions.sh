#!/bin/bash

<<COMMENT


#simple if

if [expression]; then

commands

fi

#if else

if [expression]; then

command 1

else

command 2

fi

#elif

if [expression1]; then

command 1

elif [expression2]; then

command 2

else 

command 3

fi

COMMENT

echo "demo on using if and else"

action=$1

if [ "$action" -eq "start" ]; then

echo "starting payment service"
exit 0;

elif [ "$action" -eq "restart" ]; then

echo "restarting the payment service"

exit 1;

elif [ "$action" -eq "stop" ]; then

echo "stopping the payment service"

exit 2;

else 

echo "valid option is start or stop or restart"

fi

