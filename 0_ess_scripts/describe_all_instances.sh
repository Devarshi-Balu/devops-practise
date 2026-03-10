export AWS_PROFILE="deva"

# aws ec2 describe-instances \
#   --query "Reservations[].Instances[?State.Name=='running'].{InstanceId:InstanceId, PublicIP:PublicIpAddress, State:State.Name}" \
#   --output table

# the above command may result in a error, due unflattened arrays

# echo "Running Instances" 
# aws ec2 describe-instances \
#   --query "Reservations[].Instances[] | [?State.Name=='running'].{InstanceId: InstanceId, PublicIP: PublicIpAddress, State: State.Name}" \
#   --output table

echo "Displaying All Instances including Not stopped and Terminated" 

aws ec2 describe-instances \
  --query "Reservations[].Instances[].{InstanceId: InstanceId, PublicIP: PublicIpAddress, State: State.Name, Name: Tags[?Key=='Name'].Value | [0]}" \
  --output table