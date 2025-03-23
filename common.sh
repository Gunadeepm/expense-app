status() {
    if [ $? -eq 0 ]; then 
        echo -e "\e[32m Success \e[0m"
    else
        echo -e "\e[31m Failure \e[0m"
    fi
}

root() {
    if [ $(id -u) -ne 0]; then
        echo -e "\e[31m You should have the root access to perform this task! \e[0m"
    fi 
}


