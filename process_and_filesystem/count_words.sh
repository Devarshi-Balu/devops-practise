#!/bin/bash

# use this format to run the file 
# bash count_words.sh <word_to_count> <filepath>

word_to_count=$1
file=$2

echo "Total Number of words in the File = $(wc -w  < "$file")"

grep -w "$word_to_count" "$file" | 
    awk -v target="$word_to_count" -v file="$file" -F "[ ,]" \
    '
        BEGIN {
            count = 0
            main_runs = 0
            print "parsing starts"
        }

        {   
            main_runs++
            for (i = 1; i <= NF; i++){
                if ($i == target){
                    count++
                }
            }
        }

        END {
            print "total main_runs = ", main_runs
            print "No.of occurances = ", count 
        }
    '

