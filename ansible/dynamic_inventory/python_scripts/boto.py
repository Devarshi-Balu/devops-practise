# remember to set an environment variable !! export AWS_PROFILE=<profile-name> 
import boto3 
import json 
ec2 = boto3.client("ec2")
response = ec2.describe_instances()

print(json.dumps(obj=response, indent=4))