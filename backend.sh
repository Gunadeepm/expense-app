#!/bin/bash
component=nodejs
logs=/tmp/$component.log
source common.sh
# We're using nodejs-20 version as backend server, for this specfic project.
# As, we're deploying code on rhel9 linux instances. The package manager in rhel9 by default install nodejs16, which is not desired for us.

# Here, we're disabling the default node(16v) repo and enable the needed version 20 repo.
echo -n "Configuring the nodejs20 repo:-"
dnf module list                       &>>$logs
dnf module disable $component -y          &>>$logs
dnf module enable $component:20 -y        &>>$logs
status $?

# Now, we have completed the enabling the nodejs20 repository. we now have to download & install the nodejs20.
echo -n "Installing $component:-"
dnf install $component -y   &>>$logs
status $?

# For configuring the application, we should create a user account for running the application. 
echo -n "Creating an user_account: expense:-"
useradd expense
status $?

# we have to keep the application in a standard location
echo -n "Defining the application path:-"
mkdir /app
status $?

echo -n "downloading the application code:-"
curl -o /tmp/backend.zip https://expense-web-app.s3.amazonaws.com/backend.zip 
cd /app 
unzip /tmp/backend.zip