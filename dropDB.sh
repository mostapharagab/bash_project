#!/bin/bash

mkdir -p ./DBs
cd ./DBs

while true; do
    read -p "Please Enter The Database Name You Want to Drop (or type 'exit' to quit): " dbname

    if [[ "$dbname" == "exit" ]]; then
        exit 0
    fi

    if [[ $dbname =~ ^[a-zA-Z_][a-zA-Z0-9_-]*$ ]]; then
        if [ -d "$dbname" ]; then
            rm -r "$dbname"
            echo -e "\e[32mDropped Successfully\e[0m"
            break
        else
            echo -e "\e[31mDatabase does not exist. Please try again.\e[0m"
        fi
    else
        echo -e "\e[31mInvalid name. Please try again.\e[0m"
    fi
done

cd ../

PS3="Choose an option: "
select opt in "Get to Menu" "Exit Program"; do
    case $opt in
        "Get to Menu")
            ./start.sh
            break
            ;;
        "Exit Program")
            exit 0
            ;;
        *)
            echo -e "\e[31mInvalid choice. Please try again.\e[0m"
            ;;
    esac
done

