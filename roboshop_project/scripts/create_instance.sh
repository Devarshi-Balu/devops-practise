#!/bin/bash 
set -euo pipefail 
trap 'echo "Error with the command at command: $BASH_COMMAND, line_number: $LINENO, Script_path: $0' ERR

export AWS_PROFILE="deva"

IMAGE_ID="ami-0220d79f3f480ecf5"
SECURITY_GROUPS="Security-Group-1" 
DOMAIN_NAME="devarshi.live"
ZONE_ID="Z06569691EDOCEFWDOVQV"

INSTANCE_ID=$( aws ec2 run-instances \
                    --image-id $IMAGE_ID \
                    --instance-type t3.micro \
                    --security-groups "$SECURITY_GROUPS" \
                    --count 1 \
                    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$1}]"
                    --key-name key-1 \
                    --query "Instances[].InstanceId" \
                    --output text
            )

PUBLIC_IP=""

for x in {1..10}; do 
    PUBLIC_IP=$( aws ec2 describe-instances \
                        --instance-ids "$INSTANCE_ID" \
                        --query "Reservations[].Instances[].PublicIpAddress" \
                        --output text
                )

    if [[ -n "$PUBLIC_IP" && "$PUBLIC_IP" != "None" ]]; then 
        break; 
    fi

    sleep 2
done


if [[ -z "$PUBLIC_IP" || "$PUBLIC_IP" == "None" ]]; then 
    echo "failed assign the public Ip address" 
    echo "deleting the instances created" 
    aws ec2 terminate-instances --instance-ids $INSTANCE_ID  --query "TerminatingInstances[].{InstanceId: InstanceId, CurrentState: }"
    echo "exting the script" 
    exit 1 
fi

echo "Instance created with the Instance-Id: $INSTANCE_ID, PublicIpAddress: $PUBLIC_IP" 
