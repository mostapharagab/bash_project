#!/bin/bash

BOLD='\e[1m'
BLUE='\e[34m'
RESET='\e[0m'

echo -e "\n${BOLD}${BLUE}==============================="
echo -e "       TABLE MANAGEMENT MENU"
echo -e "===============================${RESET}\n"

COLUMNS=1
PS3=$'\nChoose an option: '

options=(
    "Create Table"
    "List Tables"
    "Drop Table"
    "Insert into Table"
    "Select From Table"
    "Delete From Table"
    "Update Table"
    "Exit to DB Menu"
)

select option in "${options[@]}"; do
    case $option in
        "Create Table")
            source ./crtTable.sh
            break
            ;;
        "List Tables")
            source ./lstTables.sh
            break
            ;;
        "Drop Table")
            source ./dropTable.sh
            break
            ;;
        "Insert into Table")
            source ./insrtTable.sh
            break
            ;;
        "Select From Table")
            source ./select.sh
            break
            ;;
        "Delete From Table")
            source ./deleteTable.sh
            break
            ;;
        "Update Table")
            source ./updateTable.sh
            break
            ;;
        "Exit to DB Menu")
            cd ../../
            exec ./start.sh
            ;;
        *)
            echo "Invalid Option, Try Again:"
            ;;
    esac
done

