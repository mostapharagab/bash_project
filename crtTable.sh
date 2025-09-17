#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

while true; do
    read -p "Enter the new table name: " table_file
    if [[ -z "$table_file" ]]; then
        echo -e "${RED}Table name cannot be empty.${NC}"
        continue
    fi
    if ! [[ "$table_file" =~ ^[a-zA-Z_][a-zA-Z0-9_-]*$ ]]; then
        echo -e "${RED}Invalid table name.${NC}"
        continue
    fi
    if [ -f "$table_file" ]; then
        echo -e "${RED}A table with that name already exists.${NC}"
        continue
    fi
    break
done

while true; do
    read -p "Enter the number of columns: " cols
    if [[ "$cols" =~ ^[1-9][0-9]*$ ]]; then
        break
    else
        echo -e "${RED}Please enter a valid number.${NC}"
    fi
done

columns=()
pk_string=""
pk_set=0
datatypes=""

for ((i=1; i<=cols; i++)); do
    while true; do
        read -p "Enter the name of column $i: " cname
        if [[ -z "$cname" ]]; then
            echo -e "${RED}Column name cannot be empty.${NC}"
            continue
        fi
        if ! [[ "$cname" =~ ^[a-zA-Z_][a-zA-Z0-9_-]*$ ]]; then
            echo -e "${RED}Invalid column name.${NC}"
            continue
        fi
        columns+=("$cname")
        break
    done

    while true; do
        if [[ $pk_set -eq 0 ]]; then
            read -p "Make '$cname' the Primary Key? (yes/no): " ans
            case "$ans" in
                yes) pk_string+="1"; pk_set=1; break ;;
                no)  pk_string+="0"; break ;;
                *)   echo -e "${RED}Please type 'yes' or 'no'.${NC}" ;;
            esac
        else
            pk_string+="0"
            break
        fi
    done

    while true; do
        read -p "Enter datatype for column '$cname' (i=integer, s=string): " dt
        case "$dt" in
            i|s) datatypes+="$dt"; break ;;
            *) echo -e "${RED}Please type 'i' for integer or 's' for string.${NC}" ;;
        esac
    done
done

if [[ $pk_set -eq 0 ]]; then
    echo -e "${RED}Error: You must choose one Primary Key.${NC}"
    exit 1
fi

echo "$pk_string" > "$table_file"
echo "$datatypes" >> "$table_file"

line="${columns[0]}"
for ((i=1; i<${#columns[@]}; i++)); do
    line="$line,${columns[$i]}"
done
echo "$line" >> "$table_file"

echo -e "${GREEN}Table '$table_file' created successfully with datatypes.${NC}"
source ./tmenu.sh

