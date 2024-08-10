#!/bin/bash

# conditions are executed onlf if expression becomes true

action=$1
case $action in 
start)
echo "starting payment service"
exit 0
;;
stop)
echo "stopping payment service"
exit 1
;;
restart)
echo "restarting payment service"
exit 2
;;
*)
echo "Valid options are start or stop or restart"
echo -e "Example usage: \n bash scriptname stop"
exit 3
;;
esac