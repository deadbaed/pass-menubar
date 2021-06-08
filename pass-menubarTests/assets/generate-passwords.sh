#!/bin/bash
#

# get 512 random words from english dictionary and store in array

passwords=( $(awk 'BEGIN {srand()} {print rand() " " $0}' /usr/share/dict/usa | sort | head -1024 | awk '{print $2}' | grep -E '^[a-zA-Z0-9_]+$'))

# display each entry of array
for (( i=0; i<${#passwords[@]}; i++ )); do echo ${passwords[i]}; done

# to add new passwords
# echo "password_name" | pass insert -m password_name
