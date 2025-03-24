#!/bin/bash
component=frontend
logs=/tmp/frontend.log
webserver=nginx
source common.sh

# set -x #--> debugging

#changing the ec2-instance's name
# set-hostname Frontend-Server

#installing nginx webserver on our instance
echo -n "Installing $webserver:"
dnf install $webserver -y  &>> $logs
status $?

#starting and enbaling the nginx
echo -n "Starting the $webserver:"
systemctl enable $webserver  &>> $logs
systemctl start $webserver   &>> $logs
status $?

#Removing the default/cached content of nginx
echo -n "removing the bydefault content:"
rm -rf /usr/share/$webserver/html/*  
status $?

#downloading the web-content for frontend
echo -n "downloading the artifactory:"
curl -o /tmp/$component.zip https://expense-web-app.s3.amazonaws.com/$component.zip  &>> $logs
status $?

#extracting the frontend content 
echo -n "Extracting the content for $component:"
cd /usr/share/$webserver/html 
unzip -o /tmp/$component.zip  &>> $logs
status $?

#restarting the nginx
echo -n "Restarting the $webserver"
systemctl enable $webserver  &>> $logs
systemctl restart $webserver &>> $logs
status $?