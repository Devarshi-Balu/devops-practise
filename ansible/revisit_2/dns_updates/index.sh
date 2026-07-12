export AWS_PROFILE="deva"

readonly IMAGE_ID="ami-0220d79f3f480ecf5"
readonly SECURITY_GROUPS="sg1" 
readonly DOMAIN_NAME="ans.devarshi.live"
readonly ZONE_ID="Z06569691EDOCEFWDOVQV"

instance_name="web"
ip_address="127.0.0.1"

aws route53 change-resource-record-sets \
            --hosted-zone-id "$ZONE_ID" \
            --change-batch "$(
                jq -n \
                    --arg ip $ip_address \
                    --arg record_name "$instance_name.$DOMAIN_NAME" \
                    '
                    {
                        Comment: "Upserting an A record to Route53",
                        Changes: [
                            {
                            Action: "UPSERT",
                            ResourceRecordSet: {
                                Name: $record_name,
                                Type: "A",
                                TTL: 300,
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