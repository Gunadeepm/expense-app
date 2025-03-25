#!/bin/bash
component=mysql
logs=/tmp/mysql.log
source common.sh

# mysql version=8.0.x
echo -n "Installing $component server:"
dnf install $component-server -y  &>>logs
status $1

# we have to restart the db to load the configuration
echo -n "Starting the $component server:"
systemctl enable mysqld   &>>logs
systemctl start  mysqld   &>>logs
status $1

# Next, We need to change the default root password in order to start using the database service. 
# Here, we have used password ExpenseApp@1
echo -n "Configuring the database service:"
mysql_secure_installation --set-root-pass ExpenseApp@1   &>>logs
status $1

