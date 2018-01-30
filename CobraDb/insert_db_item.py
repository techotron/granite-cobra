import boto3
import datetime

accessKey = ""
secretKey = ""
region = "eu-west-1"
tagImageDate = datetime.datetime.now().strftime("%Y-%m-%d")
tagProduct = "timecloud"
tagEnvironment = "dev"
tagContact = "eddy.snow@intapp.com"
tagTeam = "DevOps"

ec2 = boto3.resource(
    'ec2',
    aws_access_key_id=accessKey,
    aws_secret_access_key=secretKey,
    region_name=region
)
