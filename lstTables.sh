#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'



tables=$(ls | grep -vE '\.sh$' | grep -E '^[a-zA-Z_][a-zA-Z0-9_-]*$')


if [ -z "$tables" ]; then
    echo -e "${RED}No tables found.${NC}"
else
    echo -e "${GREEN}Available Tables:${NC}"
    echo "$tables"
fi


PS3="Choose an option: "
select opt in "Get to Table Menu" "Exit Program"; do
    case $opt in
        "Get to Table Menu")
            ./tmenu.sh
            break
            ;;
        "Exit Program")
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid choice. Please try again.${NC}"
            ;;
    esac
done

