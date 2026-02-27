export AWS_PROFILE=deva

DOMAIN_NAME=devarshi.live

aws route53 change-resource-record-sets \
  --hosted-zone-id Z06569691EDOCEFWDOVQV \
  --change-batch '{
    "Changes": [
      {
        "Action": "UPSERT",
        "ResourceRecordSet": {
          "Name": "'$DOMAIN_NAME'",
          "Type": "A",
          "TTL": 1,
          "ResourceRecords": [
            { "Value": "0.0.0.0" }
          ]
        }
      }
    ]
  }'