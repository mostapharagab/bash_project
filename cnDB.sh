#!/bin/bash

mkdir -p ./DBs
cd ./DBs

while true; do
    read -p "Please Enter The Database Name You Want to Connect To (or type 'exit' to quit): " dbname

    if [[ "$dbname" == "exit" ]]; then
        exit 0
    fi

    if [[ $dbname =~ ^[a-zA-Z_][a-zA-Z0-9_-]*$ && -d "$dbname" ]]; then
        echo -e "\e[32mConnected Successfully\e[0m"
        break
    else
        echo -e "\e[31mInvalid name or database does not exist. Please try again.\e[0m"
    fi
done

cd "./$dbname"
source ./tmenu.sh
pwd

