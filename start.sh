#!/bin/bash



find . -type f -name "*.sh" -exec chmod +x {} \;

BOLD='\e[1m'
BLUE='\e[34m'
RESET='\e[0m'



echo -e "\n${BOLD}${BLUE}==============================="
echo -e "  WELCOME TO BASH SHELL SCRIPT"
echo -e "      DATABASE MANAGEMENT SYSTEM"
echo -e "===============================${RESET}\n"

COLUMNS=1
PS3=$'\nChoose an option: '

select option in "Create Database" "List Databases" "Connect To Databases" "Drop Database" "Exit Program"
do
    case $option in
        "Create Database")
            break
            ;;
        "List Databases")
            break
            ;;
        "Connect To Databases")
            break
            ;;
        "Drop Database")
            break
            ;;
        "Exit Program")
            break
            ;;
        *)
            echo "Invalid Option, Try Again:"
            break
            ;;
    esac
done

if [ "$REPLY" -eq 5 ]; then
    exit 0
elif [ "$REPLY" -eq 1 ]; then
    source ./crtDB.sh
elif [ "$REPLY" -eq 2 ]; then
    source ./lsDB.sh
elif [ "$REPLY" -eq 3 ]; then
    source ./cnDB.sh
elif [ "$REPLY" -eq 4 ]; then
    source ./dropDB.sh
else
    exec ./start.sh
fi

