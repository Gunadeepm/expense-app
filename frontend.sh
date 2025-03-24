#!/bin/bash
component=frontend
logs=/tmp/frontend.log
source common.sh

set -x #--> debug mode

#changing the ec2-instance's name
set-hostname Frontend-Server

#installing nginx webserver on our instance
echo -n "Installing nginx:"
dnf install nginx -y  &>> $logs
if [ $? -eq 0 ]; then 
        echo -e "\e[32m Sucess \e[0m"
    else
        echo -e "\e[31m Failure \e[0m"
fi 

#starting and enbaling the nginx
echo -n "Starting the nginx:"
systemctl enable nginx  &>> $logs
systemctl start nginx   &>> $logs
status

#Removing the default/cached content of nginx
echo -n "removing the bydefault content:"
rm -rf /usr/share/nginx/html/*  
status

#downloading the web-content for frontend
echo -n "downloading the artifactory:"
curl -o /tmp/frontend.zip https://expense-web-app.s3.amazonaws.com/frontend.zip  &>> $logs
status

#extracting the frontend content 
echo -n "Extracting the content for frontend:"
cd /usr/share/nginx/html 
unzip -o /tmp/frontend.zip  &>> $logs
status

#restarting the nginx
echo -n "Restarting the nginx"
systemctl enable nginx  &>> $logs
systemctl restart nginx &>> $logs
status