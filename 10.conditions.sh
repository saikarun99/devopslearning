#!/bin/bash

# conditions are executed onlf if expression becomes true

action=$1
case $action in 
start)
echo "starting payment service"
;;
stop)
echo "stopping payment service"
;;
restart)
echo "restarting payment service"
;;
*)
echo "Valid options are start or stop or restart"
echo -e "Example usage: \n bash scriptname stop"
;;
esac