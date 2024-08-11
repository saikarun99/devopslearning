#!/bin/bash

#echo "I am frontend"
set -e

stat ()
{
    if [ $1 == 0 ]; then
    echo "Successful"

    else
    echo "failed"
    exit 2
    fi
}

USER_ID=$(id -u)

if [ $USER_ID -ne 0 ]; then
echo "script is expected to be run by rootuser or a user with a sudo privilege"
fi

echo -n "Installing nginx:"
yum install nginx -y &>> /tmp/frontend.log
stat $?

echo "starting nginx"
systemctl enable nginx &>> /tmp/frontend.log
systemctl start nginx &>> /tmp/frontend.log ; stat $?


echo "downloading the frontend file:"
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip" 
stat $?
echo "cleanup of default frontend"
cd /usr/share/nginx/html &>> /tmp/frontend.log
rm -rf * &>> /tmp/frontend.log
stat $?

echo "extracting frontend"
unzip /tmp/frontend.zip &>> /tmp/frontend.log
stat $?

echo "sorting the frontend files"
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf
stat $?

echo "restarting frontend"

systemctl daemon-reload
systemctl restart nginx

