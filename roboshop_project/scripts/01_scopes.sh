x="global"

echo "value of x before the functon call $x" 

func(){
    echo $x
    x="modified"
    echo "in the func call : $x";

    if [[ -n $x ]]; then 
        x="modified in the if condition"
    fi

    echo $x
    AWS_PROFILE=localstack
}

(func) # creates its own scope 


echo "value after the function call : $x"
echo $AWS_PROFILE