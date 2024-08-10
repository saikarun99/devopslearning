#!/bin/bash

#echo "I am frontend"
set -e

USER_ID=$(id -u)

if [ $USER_ID -ne 0 ]; then
echo "script is expected to be run by rootuser or a user with a sudo privilege"
fi

echo "Installing nginx:"
yum install nginx -y &>> /tmp/frontend.log

echo "starting nginx"
systemctl enable nginx &>> /tmp/frontend.log
systemctl start nginx &>> /tmp/frontend.log

echo "downloading the frontend file:"
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip" 

echo "cleanup of default frontend"
cd /usr/share/nginx/html &>> /tmp/frontend.log
rm -rf * &>> /tmp/frontend.log

echo "extracting frontend"
unzip /tmp/frontend.zip &>> /tmp/frontend.log

echo "sorting the frontend files"
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf

echo "restarting frontend"

systemctl daemon-reload
systemctl restart nginx

