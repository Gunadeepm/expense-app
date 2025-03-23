#!/bin/bash
component=frontend
source common.sh

#changing the ec2-instance's name
set-hostname $component

#installing nginx webserver on our instance
echo -n "Installing nginx:"
dnf install nginx -y &>> /tmp/$component.log
status

# #starting and enbaling the nginx
# echo -n "Starting the nginx:"
# systemctl enable nginx  &>> /tmp/$component.log
# systemctl start nginx  &>> /tmp/$component.log
# status

# #Removing the default/cached content of nginx
# echo -n "removing the bydefault content:"
# rm -rf /usr/share/nginx/html/*  
# status

# #downloading the web-content for frontend
# echo -n "downloading the artifactory:"
# curl -o /tmp/$component.zip https://expense-web-app.s3.amazonaws.com/$component.zip &>> /tmp/$component.log
# status

# #extracting the frontend content 
# echo -n "Extracting the content for $component:"
# cd /usr/share/nginx/html 
# unzip -o /tmp/$component.zip  &>> /tmp/$component.log
# status

# #restarting the nginx
# echo -n "Restarting the nginx"
# systemctl enable nginx
# systemctl restart nginx
# status