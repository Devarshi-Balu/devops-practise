# list all the users of a group 

users_of_group=$(getent group devops | cut -d ":" -f4 | tr ',' ' ')

groups_of_user=$(groups deva | cut -d ":" -f2)


# they donot break in the variables assignments 
echo $users_of_group
echo $groups_of_user

# they break in the commands, conditional statements, loops, array creations
touch $users_of_group

arr=($users_of_group)

echo ${arr[@]}

for user in $users_of_group; do 
    echo $user;
done

for x in $(seq 1 ${#arr[@]}); do 
    echo $x
done