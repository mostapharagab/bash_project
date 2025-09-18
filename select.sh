#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

read -p "Enter the table name: " table_file
if [ -z "$table_file" ]; then
    echo -e "${RED}Table name cannot be empty.${NC}"
    exit 1
fi
if [ ! -f "$table_file" ]; then
    echo -e "${RED}Table not found.${NC}"
    exit 1
fi

columns_line=$(sed -n '3p' "$table_file")
IFS=',' read -r -a columns <<< "$columns_line"

echo "Columns:"
for i in "${!columns[@]}"; do
    echo "$((i+1))) ${columns[i]}"
done

while true; do
    read -p "Select column number to search by: " col_num
    if ! [[ "$col_num" =~ ^[0-9]+$ ]] || (( col_num < 1 || col_num > ${#columns[@]} )); then
        echo -e "${RED}Invalid column number.${NC}"
    else
        break
    fi
done

read -p "Enter value to search for in column '${columns[$((col_num-1))]}': " search_value

awk -F',' -v col=$col_num -v val="$search_value" 'NR<=3 {next} $col == val {print}' "$table_file"

source ./tmenu.sh

