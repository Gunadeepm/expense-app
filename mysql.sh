#!/bin/bash
component=mysql
logs=/tmp/mysql.log
source common.sh

if [ -z $1 ]; then 
    echo -e "\e[31m mysql root user password \e[0m"
    echo -e "Example usage: \n\t \e[35m sudo bash $0 password \e[0m"
    exit 1
fi
# mysql version=8.0.x
echo -n "Installing $component server:"
dnf install $component-server -y  &>>logs
status $?

# we have to restart the db to load the configuration
echo -n "Starting the $component server:"
systemctl enable mysqld   &>>logs
systemctl start  mysqld   &>>logs
status $?

# Next, We need to change the default root password in order to start using the database service. 
# Here, we have used password ExpenseApp@1
echo -n "Configuring the database service:"
mysql_secure_installation --set-root-pass $1 &>>logs
status $?

