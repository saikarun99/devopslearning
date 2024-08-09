#!/bin/bash
#special variables gives special property to the variables

# $0 prints the name of the script that is executing

echo "The name of the script is $0"

echo "The name of the recently launched vehicle is $1"

# we can supply 9 arguments during run time $1 $2 $3 $4 .......$9

a=10
b=90
c=xyz

echo "The name of the recent EV stock is $2"


echo $$ #prints the current process
echo $* #prints the no of arguments
