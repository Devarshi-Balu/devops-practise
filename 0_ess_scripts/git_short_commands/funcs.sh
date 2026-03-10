#this function runs in a subshell by creating a new process
function random_push_devops() (
    set -euo pipefail # this setting will not persist outside the function

    trap 'echo "There is an error in the scirpt $0, command: $BASH_COMMAND, line_number: $LINENO"' ERR

    echo "-------starting ----------"

    curr_branch=$(git branch --show-current)

    if [[ "$curr_branch" != "practise" ]]; then
        echo "Current branch is not practise"
        echo "Staging changes and switching branch"

        git add -A
        git switch practise
    fi

    git reset --soft HEAD~1

    git add -A
    git commit -m "random_push_commit"
    git push --force origin practise

    git log --oneline --all --graph

    echo 
    echo "-----Push Completed-------"
)