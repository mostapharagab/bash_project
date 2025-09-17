#!/bin/bash

mkdir -p ./DBs
cd ./DBs

databases=$(ls -F | grep '/$')

if [ -z "$databases" ]; then
    echo -e "\e[31mNo databases found.\e[0m"
else
    echo -e "\e[32mAvailable Databases:\e[0m"
    echo "$databases"
fi

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

