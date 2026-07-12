set -Eeuo pipefail 
export AWS_PROFILE="deva"

script_dir="$(realpath $(dirname $0))"

SECURITY_GROUPS="sg1" 
DOMAIN_NAME="devarshi.live"
ZONE_ID="Z06569691EDOCEFWDOVQV"

read -r INSTANCE_ID PRIVATE_IP < <(
    aws ec2 run-instances \
        --image-id ami-0fd6240f599091088 \
        --instance-type t3.micro \
        --security-groups $SECURITY_GROUPS \
        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$1}]"\
        --count 1 \
        --query "Instances[].[InstanceId, PrivateIpAddress]" \
        --user-data "file://$(cygpath -w ${script_dir}/change_pass.sh)" \
        --output text 
)

aws ec2 wait instance-running --instance-ids $INSTANCE_ID

PUBLIC_IP=$(
    aws ec2 describe-instances \
        --instance-ids $INSTANCE_ID \
        --query "Reservations[0].Instances[0].PublicIpAddress" \
        --output text
)

if [[ -z "$PUBLIC_IP" || "$PUBLIC_IP" == "None" ]]; then 
    echo "failed assign the public Ip address, exiting the script" 
    echo "deleting the instances created" 
    aws ec2 terminate-instances --instance-ids $INSTANCE_ID 
    echo "exting the script" 
    exit 1 
fi


record="$1.devarshi.live"
echo "updating the dns record with the given instance_name: $1, record_name: $record"

aws route53 change-resource-record-sets \
  --hosted-zone-id $ZONE_ID \
  --change-batch "$( jq -n \
                        --arg record $record \
                        --arg ip $PUBLIC_IP \
                        '
                            {
                                Comment: "Upserting an record for the domain",
                                Changes: [
                                    {
                                    Action: "UPSERT",
                                    ResourceRecordSet: {
                                        Name: $record,
                                        Type: "A",
                                        TTL: 1,
                                        ResourceRecords: [
                                        {
                                            Value: $ip
                                        }
                                        ]
                                    }
                                    }
                                ]
                            }
                        '
                )"

echo "Instance created with the Instance-Id: $INSTANCE_ID"
echo "PublicIpAddress: $PUBLIC_IP"
echo "PrivateIpAddress: $PRIVATE_IP"