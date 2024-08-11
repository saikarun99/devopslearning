#!/bin/bash

#echo "I am frontend"
set -e

COMPONENT=frontend

stat ()
{
    if [ $1 == 0 ]; then
    echo -e "\e[32m Successful \e[0m"

    else
    echo "failed"
    exit 2
    fi
}

USER_ID=$(id -u)

if [ $USER_ID -ne 0 ]; then
echo "script is expected to be run by rootuser or a user with a sudo privilege"
fi

echo "configuring ${COMPONENT}"

LOGFILE="/tmp/${COMPONENT}.log"
echo -n "Installing nodeJs:"
yum install https://rpm.nodesource.com/pub_16.x/nodistro/repo/nodesource-release-nodistro-1.noarch.rpm -y &>> ${LOGFILE}
yum install nodejs -y &>> ${LOGFILE}
stat $?
echo -n "Creating appn user:"
id ${APPUSER} &>> ${LOGFILE}
if [ $? -ne 0 ]; then
useradd roboshop
fi
stat $?



