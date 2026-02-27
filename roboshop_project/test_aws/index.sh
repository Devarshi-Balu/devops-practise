export AWS_PROFILE=deva

INSTANCE_ID=$(aws ec2 run-instances \
                    --image-id ami-0220d79f3f480ecf5 \
                    --instance-type t3.micro \
                    --security-groups Security-Group-1 \
                    --count 1 \
                    --query 'Instances[0].InstanceId' \
                    --output text
                ) 

aws ec2 wait instance-running --instance-ids $INSTANCE_ID

PUBLIC_IP=$(aws ec2 describe-instances \
                --instance-ids $INSTANCE_ID \
                --query 'Reservations[0].Instances[0].PublicIpAddress' \
                --output text
            )
