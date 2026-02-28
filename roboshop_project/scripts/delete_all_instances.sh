export AWS_PROFILE="deva"

INSTANCE_IDS=$(aws ec2 describe-instances \
                    --query "Reservations[].Instances[].InstanceId" \
                    --output text
            )

aws ec2 terminate-instances \
        --instance-ids $INSTANCE_IDS \
        --query 'TerminatingInstances[].{InstanceId: InstanceId, PreviousState: PreviousState.Name, CurrentState: CurrentState.Name}' \
        --output table