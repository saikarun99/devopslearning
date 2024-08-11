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

LOGFILE = "/tmp/${COMPONENT}.log"
echo -n "Installing nginx:"
yum install nginx -y &>> ${LOGFILE}
stat $?

echo -n "starting nginx:"
systemctl enable nginx &>> ${LOGFILE}
systemctl start nginx &>> ${LOGFILE} ; stat $?


echo -n "downloading the frontend file:"
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip" 
stat $?
echo -n "cleanup of default frontend:"
cd /usr/share/nginx/html &>> ${LOGFILE}
rm -rf * &>> /tmp/frontend.log
stat $?

echo -n "extracting frontend:"
unzip /tmp/frontend.zip &>> ${LOGFILE}
stat $?

echo -n "sorting the frontend files"
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf
stat $?

echo -n "restarting frontend:"

systemctl daemon-reload
systemctl restart nginx

stat $?

