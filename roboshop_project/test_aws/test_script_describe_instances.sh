export AWS_PROFILE="deva" 

IMAGE_ID="ami-0220d79f3f480ecf5"
SECURITY_GROUPS="Security-Group-1" 
DOMAIN_NAME="devarshi.live"
ZONE_ID="Z06569691EDOCEFWDOVQV"

## create instances 
INSTANCE_IDS=$(aws ec2 run-instances \
                    --image-id $IMAGE_ID \
                    --instance-type t3.micro \
                    --security-groups $SECURITY_GROUPS \
                    --count 1 \
                    --query 'Instances[].InstanceId' \
                    --output text
)


## terminate the all the instances instances 
aws ec2 terminate-instances --instance-ids $(aws ec2 describe-instances --query 'Reservations[].Instances[].InstanceId' --output text)
