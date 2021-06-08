#!/bin/bash
#

# get 512 random words from english dictionary and store in array
passwords=( $(awk 'BEGIN {srand()} {print rand() " " $0}' /usr/share/dict/usa | sort | head -512 | awk '{print $2}' | grep -E '^[a-zA-Z0-9_]+$'))

# add each entry of array to password store
for i in "${passwords[@]}"
do
	echo $i | pass insert -m $i
done
