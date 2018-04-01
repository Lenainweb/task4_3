#!/bin/bash

# A script that backs up the specified directory
# script launch parameters: ./backup.sh </path/to/backup/folder> <number of backups>

MAX_NUM=100
WAY_FILE="/tmp/backups/"
if ! [ -e "$WAY_FILE" ] ; then
    mkdir "$WAY_FILE"
fi
str_argv=$*
end_argv=${!#}
num_argv=$#
argv=$( echo $str_argv | sed 's/\w*$//' | sed 's/.$//')

# Exists file
if ! [ -e "$argv" ] ; then
    echo "Error: task4_3: No folder $argv
Use:   task4_3.sh [folder] [number back-up]" >&2
    exit 1
fi
# Number or Not Number
if (echo "$end_argv" | grep -E -q "^?[0-9]+$"); then
    # Number
    if [ $end_argv -gt $MAX_NUM ] ; then
        echo "Error: task4_3: Big number $end_argv
Use less than $MAX_NUM" >&2
    exit 2
    fi
    # The number equals null
    if [ $end_argv -le 0 ] ; then
        echo "Error: task4_3: The number equals null $end_argv
Use from 1 to $MAX_NUM" >&2
    exit 3
    fi
# Not Number
else
    echo "Error: task4_3: Not Number $end_argv
Use:   task4_3.sh [folder] [number back-up]" >&2
exit 4
fi
name_back="$( echo "$argv" | cut -c 2- | tr  '/' '-' | tr  ' ' '_' )"      # | tr  ':' '-' 
name_date="$name_back+_-$( date +%Y%m%d%H%M%S )"
name_full="$name_date.tar.gz"

count_file=$(find "$WAY_FILE" -type f -name "$name_back*" | wc -l)
max_i=$(($count_file-$end_argv+1))


if [ $count_file -lt $end_argv ] ; then
    tar -cvzf "$name_full" "$argv" && mv "$name_full" "$WAY_FILE"

else
    
    i=1
    for file_del in $(find "$WAY_FILE" -type f -name "$name_back*" | sort -n )
        do 
        
        rm -f "$file_del"
        if [ $max_i -eq $i ] ; then
            break
        fi
        ((i ++))

    done
    tar -cvzf "$name_full" "$argv" && mv "$name_full" "$WAY_FILE" 
fi
