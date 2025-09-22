#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'


if [ $? -ne 0 ]; then
    echo -e "${RED}Failed to enter DBs directory.${NC}"
    exit 1
fi

while true; do
    read -p "Enter the table name you want to drop (or type 'exit' to quit): " table_name

    if [ "$table_name" = "exit" ]; then
        exit 0
    fi

    if [ -z "$table_name" ]; then
        echo -e "${RED}Table name cannot be empty.${NC}"
        continue
    fi

    if ! echo "$table_name" | grep -qE '^[a-zA-Z_][a-zA-Z0-9_-]*$'; then
        echo -e "${RED}Invalid table name.${NC}"
        continue
    fi

    if [ ! -f "$table_name" ]; then
        echo -e "${RED}Table not found.${NC}"
        continue
    fi

    rm -f "$table_name"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Table '$table_name' dropped successfully.${NC}"
    else
        echo -e "${RED}Failed to drop the table.${NC}"
    fi
    break
done


PS3="Choose an option: "
select opt in "Get to Table Menu" "Exit Program"; do
    if [ "$opt" = "Get to Table Menu" ]; then
        ./tmenu.sh
        break
    elif [ "$opt" = "Exit Program" ]; then
        exit 0
    else
        echo -e "${RED}Invalid choice. Please try again.${NC}"
    fi
done

