#!/bin/bash

#echo "I am frontend"
set -e

COMPONENT=mongod

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
echo -n "configuring mongod repos:"

curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/stans-robot-project/mongodb/main/mongo.repo
stat $?

echo -n "Installing mongod:"
yum install -y mongodb-org &>> ${LOGFILE}
stat $?

echo -n "starting mongod:"
systemctl enable mongod &>> ${LOGFILE}
systemctl start mongod &>> ${LOGFILE} ; stat $?

echo -n "Making mongod visible:"

sed -ie 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf

stat $?

echo -n "restarting mongod:"
systemctl restart mongod
stat $?

echo -n "Downloading the schema and injecting:"

curl -s -L -o /tmp/mongodb.zip "https://github.com/stans-robot-project/mongodb/archive/main.zip" &>> ${LOGFILE}
cd /tmp
unzip -o mongodb.zip
cd mongodb-main
mongo < catalogue.js &>> ${LOGFILE}
mongo < users.js &>> ${LOGFILE}

stat $?

