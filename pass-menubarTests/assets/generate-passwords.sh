#!/bin/bash
#

# get 512 random words from english dictionary and store in array
passwords=( $(awk 'BEGIN {srand()} {print rand() " " $0}' /usr/share/dict/usa | sort | head -512 | awk '{print $2}'))

# display each entry of array
for (( i=0; i<${#passwords[@]}; i++ )); do echo ${passwords[i]}; done
