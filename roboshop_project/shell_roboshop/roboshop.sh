set -euo pipefail 

trap 'echo "Command execution failed, Command: $BASH_COMMAND, lineNo: $LINENO, script: $0" ' ERR

export AWS_PROFILE="deva"

IMAGE_ID="ami-0220d79f3f480ecf5"
SECURITY_GROUPS="Security-Group-1" 
DOMAIN_NAME="devarshi.live"
ZONE_ID="Z06569691EDOCEFWDOVQV"

function AssignPublicIp(){
    for _ in {1..10}; do
        PUBLIC_IP=$(aws ec2 describe-instances \
                        --instance-id $INSTANCE_ID \
                        --query 'Reservations[].Instances[].PublicIpAddress' \
                        --output text
                    )

        if [[ "$PUBLIC_IP" != "None" &&  -n "$PUBLIC_IP" ]]; then
            break; 
        fi
        
        sleep 2; 
    done 

    if [[ -z "$PUBLIC_IP" || "$PUBLIC_IP" == "None" ]]; then  # Never forget to quote the variables while using in the conditional blocks
        echo "Failed to assign the public IP!"; 
        exit 1; 
    fi
}


for instance in $@; do 
    INSTANCE_ID=$(aws ec2 run-instances \
                        --image-id $IMAGE_ID \
                        --instance-type t3.micro \
                        --security-groups $SECURITY_GROUPS \
                        --count 1 \
                        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" \
                        --query "Instances[].InstanceId" \
                        --output text 
                )

    PUBLIC_IP=""

    echo "Instance created with the instance id : $INSTANCE_ID, obtaining the IPv4 address" 
    
    # aws ec2 wait instance-running --instance-ids $INSTANCE_ID
    
    # echo "Instance is running, Obtaining the Ipv4 address"

    AssignPublicIp

    echo "assigned the public Ip sucessfully Ipv4 address : $PUBLIC_IP"

    echo "updating the dns record" 

    CHANGE_ID=$(aws route53 change-resource-record-sets \
        --hosted-zone-id $ZONE_ID \
        --change-batch '{
                "Comment": "Creating new record",
                "Changes": [{
                    "Action": "UPSERT",
                    "ResourceRecordSet": {
                        "Name": "'$instance.rb.$DOMAIN_NAME'",
                        "Type": "A",
                        "TTL": 1,
                        "ResourceRecords": [{"Value": "'$PUBLIC_IP'"}]
                    }
                }]
            }' \
        --query 'ChangeInfo.Id' \
        --output text ) 


    # echo "Waiting for DNS change to sync..." ;
    # aws route53 wait resource-record-sets-changed --id "$CHANGE_ID" ;

    echo "Deployment complete. $instance.rb.$DOMAIN_NAME → $PUBLIC_IP" ; 
done