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
    read -p "Enter Primary Key value ($pk_col_name) of the row to update: " pk_value
    if [ -z "$pk_value" ]; then
        echo -e "${RED}Primary key cannot be empty.${NC}"
        continue
    fi
    row_num=$(awk -F',' -v col=$((pk_index+1)) -v val="$pk_value" 'NR>3 && $col==val {print NR}' "$table_file")
    if [ -z "$row_num" ]; then
        echo -e "${RED}Primary key value not found.${NC}"
        continue
    fi
    break
done

old_row=$(sed -n "${row_num}p" "$table_file")
IFS=',' read -r -a old_values <<< "$old_row"

new_values=()
for ((i=0; i<cols_count; i++)); do
    col_name=$(echo "$columns_line" | cut -d',' -f $((i+1)))
    dtype="${datatype_string:$i:1}"
    old_val="${old_values[$i]}"

    if [ $i -eq $pk_index ]; then
        new_values+=("$old_val")
        continue
    fi

    while true; do
        read -p "Enter new value for $col_name (current: $old_val, press Enter to keep): " val
        if [ -z "$val" ]; then
            val="$old_val"
        fi
        if [ "$dtype" == "i" ] && ! [[ "$val" =~ ^-?[0-9]+$ ]]; then
            echo -e "${RED}Invalid type. Must be an integer.${NC}"
        elif [ "$dtype" == "s" ] && ! [[ "$val" =~ ^[a-zA-Z0-9_[:space:]]*$ ]]; then
            echo -e "${RED}Invalid type. Must be a string (letters, numbers, spaces, _).${NC}"
        else
            break
        fi
    done
    new_values+=("$val")
done

updated_row="${new_values[0]}"
for ((i=1; i<cols_count; i++)); do
    updated_row="$updated_row,${new_values[$i]}"
done

sed -i "${row_num}s/.*/$updated_row/" "$table_file"

echo -e "${GREEN}Row updated successfully.${NC}"
source ./tmenu.sh

