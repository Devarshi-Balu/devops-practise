#!/bin/bash

if [[ $# -eq 0 ]]; then 
    echo "Atleast one package must be specified"; 
    exit 1;
else
    uv pip install $*;
fi

echo "script execution completed" 
