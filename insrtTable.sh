#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

read -p "Enter the table name: " table_file
if [ -z "$table_file" ]; then
    echo -e "${RED}Table name cannot be empty.${NC}"
    exit 1
fi
if ! [[ "$table_file" =~ ^[a-zA-Z_][a-zA-Z0-9_-]*$ ]]; then
    echo -e "${RED}Invalid table name.${NC}"
    exit 1
fi
if [ ! -f "$table_file" ]; then
    echo -e "${RED}Table not found.${NC}"
    exit 1
fi

pk_string=$(head -n 1 "$table_file")
datatype_string=$(sed -n '2p' "$table_file")
columns_line=$(sed -n '3p' "$table_file")

cols_count=$(echo "$columns_line" | tr -cd ',' | wc -c)
cols_count=$((cols_count+1))

pk_index=-1
for ((i=0; i<${#pk_string}; i++)); do
    if [ "${pk_string:$i:1}" = "1" ]; then
        pk_index=$i
        break
    fi
done

if [ $pk_index -lt 0 ]; then
    echo -e "${RED}No primary key defined in this table.${NC}"
    exit 1
fi

pk_col_name=$(echo "$columns_line" | cut -d',' -f $((pk_index+1)))

while true; do
    read -p "Enter value for Primary Key ($pk_col_name): " pk_value
    if [ -z "$pk_value" ]; then
        echo -e "${RED}Primary key cannot be NULL.${NC}"
        continue
    fi
    if awk -F',' -v col=$((pk_index+1)) -v val="$pk_value" 'NR>3 && $col==val {found=1} END{exit !found}' "$table_file"; then
        echo -e "${RED}Duplicate primary key value.${NC}"
        continue
    fi
    if [ "${datatype_string:$pk_index:1}" == "i" ] && ! [[ "$pk_value" =~ ^-?[0-9]+$ ]]; then
        echo -e "${RED}Invalid type. Must be an integer.${NC}"
        continue
    fi
    if [ "${datatype_string:$pk_index:1}" == "s" ] && ! [[ "$pk_value" =~ ^[a-zA-Z0-9_[:space:]]*$ ]]; then
        echo -e "${RED}Invalid type. Must be a string (letters, numbers, spaces, _).${NC}"
        continue
    fi
    break
done

row=""
for ((i=1; i<=cols_count; i++)); do
    if [ $((i-1)) -eq $pk_index ]; then
        val="$pk_value"
    else
        col_name=$(echo "$columns_line" | cut -d',' -f $i)
        dtype="${datatype_string:$((i-1)):1}"
        while true; do
            read -p "Enter value for $col_name (can be empty): " val
            if [ "$dtype" == "i" ] && ! [[ "$val" =~ ^-?[0-9]+$ ]]; then
                echo -e "${RED}Invalid type. Must be an integer.${NC}"
            elif [ "$dtype" == "s" ] && ! [[ "$val" =~ ^[a-zA-Z_[:space:]]*$ ]]; then
                echo -e "${RED}Invalid type. Must be a string (letters, numbers, spaces, _).${NC}"
            else
                break
            fi
        done
    fi

    if [ $i -eq 1 ]; then
        row="$val"
    else
        row="$row,$val"
    fi
done

echo "$row" >> "$table_file"
echo -e "${GREEN}Row inserted successfully.${NC}"
source ./tmenu.sh

