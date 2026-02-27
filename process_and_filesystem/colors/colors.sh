#!/bin/bash

set -euo pipefail 

R="\e[31m"
G="\e[32m"
Y="\e[33m"
NO="\e[0m"

## Donot forget to set the No color "\e[0m" after you set the colors at once, if forgotten, The same color continues till 
## till the end of the script

echo  -e "$R This color is RED"
echo -e "What is Donot forget to unset the colors with '\ e [0m' $NO this color"

echo -e "$R This is RED color $NO"
echo -e "$G This is Green color $NO"
echo -e "$Y This is Yellow color $NO"

echoooo


function run() {
    var=20
    for x in "$@"; do 
        echo $x; 
    done
}

run 1 2 3 4 5 6 