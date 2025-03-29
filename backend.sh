#!/bin/bash
component=nodejs
rootpasswd=$1
logs=/tmp/$component.log

source common.sh
# We're using nodejs-20 version as backend server, for this specfic project.
# As, we're deploying code on rhel9 linux instances. The package manager in rhel9 by default install nodejs16, which is not desired for us.

# this below condition, validates that we should provide password for mysql as an argument
if [ -z $1 ]; then 
    echo -e "\e[31m mysql root user password \e[0m"
    echo -e "Example usage: \n\t \e[35m sudo bash $0 password \e[0m"
    exit 1
fi

# Here, we're disabling the default node(16v) repo and enable the needed version 20 repo.
echo -n "Configuring the nodejs20 repo:-"
dnf module list                           &>> $logs
dnf module disable $component -y          &>> $logs
dnf module enable $component:20 -y        &>> $logs
status $?

# Now, we have completed the enabling the nodejs20 repository. we now have to download & install the nodejs20.
echo -n "Installing $component:-"
dnf install $component -y   &>> $logs
status $?

echo -n "Configuring the systemd service:-"
cp backend.service /etc/systemd/system/
status $?

# For configuring the application, we should create a user account for running the application. 
echo -n "Creating a service_account: expense:-"
id -u expense &>> $logs
if [ $? -eq 0 ]; then 
    echo -n "expense user already exists..skipping:"
else
    echo -n "Creating expense user:"
    useradd expense
fi
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

# Changing the permissions and ownership of the /app directory to "expense" service account.
# All the objects belongs to application should be owned by application
echo -n "Granting the necessary permissions & ownership:-"
chmod -R 775 /app 
chown -R expense:expense /app  &>> $logs
status $?

# For this application to work fully functional we need to load schema to the Database.
# Defining schema is like defining the structure of the table with rows & columns.
# We need to load the schema. To load schema we need to install mysql client on this backend application instance.
echo -n "Installing the mysql client:-"
dnf install mysql-server -y &>> $logs
status $?

echo -n "Injecting the schema from the backend app:-"
mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -p$rootpasswd < /app/schema/backend.sql &>> $logs
status $?

echo -n "Loading and starting the service:-"
systemctl daemon-reload  &>> $logs
systemctl enable backend &>> $logs
systemctl start backend  &>> $logs
stat $? 