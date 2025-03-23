#!bin/bash
root() {
    if [ $(id -u) -ne 0]; then
        echo -e "\e[31m You should have the root access to perform this task! \e[0m"
    fi 
}


