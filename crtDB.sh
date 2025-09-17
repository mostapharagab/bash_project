#!/bin/bash

mkdir -p ./DBs
cd ./DBs

while true; do
    read -p "Please Enter The Database Name (or type 'exit' to quit): " dbname

    if [[ "$dbname" == "exit" ]]; then
        exit 0
    fi

    if [[ $dbname =~ ^[a-zA-Z_][a-zA-Z0-9_-]*$ ]]; then
        if [ -d "$dbname" ]; then
            echo -e "\e[31mThis database name is already taken, please try again!!\e[0m"
            continue
        else
            mkdir "$dbname"
            echo -e "\e[32mDatabase: ${dbname} created successfully\e[0m"
            break
        fi
    else
        echo -e "\e[31mInvalid name. Please try again.\e[0m"
    fi
done

cp ../tmenu.sh ./"$dbname"
cp ../crtTable.sh ./"$dbname"
cp ../insrtTable.sh ./"$dbname"
cp ../lstTables.sh ./"$dbname"
cp ../updateTable.sh ./"$dbname"
cp ../deleteTable.sh ./"$dbname"
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

