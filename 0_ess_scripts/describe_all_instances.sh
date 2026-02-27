export AWS_PROFILE="deva"

# aws ec2 describe-instances \
#   --query "Reservations[].Instances[?State.Name=='running'].{InstanceId:InstanceId, PublicIP:PublicIpAddress, State:State.Name}" \
#   --output table

# the above command may result in a error, due unflattened arrays


aws ec2 describe-instances \
  --query "Reservations[].Instances[] | [?State.Name=='running'].{InstanceId: InstanceId, PublicIP: PublicIpAddress, State: State.Name}" \
  --output table


