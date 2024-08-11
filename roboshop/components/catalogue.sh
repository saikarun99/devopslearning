#!/bin/bash

#echo "I am frontend"
set -e

COMPONENT=catalogue
APPUSER="roboshop"

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
#yum install https://rpm.nodesource.com/pub_16.x/nodistro/repo/nodesource-release-nodistro-1.noarch.rpm -y &>> ${LOGFILE}
yum install nodejs -y &>> ${LOGFILE}
stat $?
#id ${APPUSER} &>> ${LOGFILE}
#if [ $? -ne 0 ]; then
echo -n "Creating appn user:"
useradd roboshop
stat $?
#fi

echo -n "Downloading the ${COMPONENT}:"
curl -s -L -o /tmp/catalogue.zip "https://github.com/stans-robot-project/catalogue/archive/main.zip"
cd /home/${APPUSER}/
rm -rf ${COMPONENT} &>> ${LOGFILE}
 unzip -o /tmp/${COMPONENT}.zip &>> ${LOGFILE}

 echo -n "changing the ownership:"
 mv ${COMPONENT}-main ${COMPONENT}
 chown -R ${APPUSER}:${APPUSER} /home/${APPUSER}/${COMPONENT}/
 stat $?

 echo -n "Generating the ${COMPONENT} artifacts:"

 cd /home/${APPUSER}/${COMPONENT}/

 npm install &>> ${LOGFILE}

 echo -n "configuring the ${COMPONENT} system file:"

sed -ie 's/MONGO_DNSNAME/172.31.85.62/g' /home/${APPUSER}/${COMPONENT}/systemd.service
 mv /home/${APPUSER}/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
 stat $?

 echo -n "starting the ${COMPONENT} service:"

 systemctl daemon-reload &>> ${LOGFILE}

systemctl enable ${COMPONENT} &>> ${LOGFILE}
systemctl restart ${COMPONENT} &>> ${LOGFILE}

stat $?

echo -n "Installation is completed"


