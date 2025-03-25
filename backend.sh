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
useradd expense &>>$logs
status $?

# we have to keep the application in a standard location
echo -n "Defining the application path:-"
mkdir /app
status $?

# The code was already in a zip file stored in AWS S3, we now have to download it 
echo -n "downloading the application code:-"
curl -o /tmp/backend.zip https://expense-web-app.s3.amazonaws.com/backend.zip  &>>$logs
status $?

#After the above step, we have to switch to app directory to unzip and save the code.
echo -n "Switching to app directory and Unzipping the file:-"
cd /app 
unzip /tmp/backend.zip  &>>$logs
status $?

# To run and function accordingly, this application does need some libraries..that are mentioned in the package.json by developer
echo -n "Installing the necessary dependencies:-"
cd /app
npm install   &>>$logs   #-->This will download and install all the packages needed for the application from package.json in a binary format under node_modules.
status $?




