from __future__ import print_function # Python 2/3 compatibility
import boto3
import datetime

accessKey = ""
secretKey = ""
region = "eu-west-2"
tagImageDate = datetime.datetime.now().strftime("%Y-%m-%d")
cardId = 00000005
packId = "base-core-1"

dynamodb = boto3.resource(
    'dynamodb',
    aws_access_key_id=accessKey,
    aws_secret_access_key=secretKey,
    region_name=region
)

cardsTable = dynamodb.Table('cardsTable')

response = cardsTable.put_item(
    Item={
        'cardId': cardId,
        'imageUrl': "https://s3.amazon.com/somebucket/someImageFile.png",
        'packId': packId,
        'cardAttributes': {
            'live': 1,
            'quote': "My hands are very large. Very large indeed.",
            'source': {
                'location': "election rally, Texas",
                'date': "10/04/2016",
                'media': "Public Speech"
            },
            'stats': {
                'racism': {
                    'value': 0,
                    'playedCount': 0,
                    'winningCount': 0,
                    'losingCount': 0
                },
                'sexism': {
                    'value': 0,
                    'playedCount': 0,
                    'winningCount': 0,
                    'losingCount': 0
                },
                'political ineptitude': {
                    'value': 0,
                    'playedCount': 0,
                    'winningCount': 0,
                    'losingCount': 0
                },
                'bigotry': {
                    'value': 0,
                    'playedCount': 0,
                    'winningCount': 0,
                    'losingCount': 0
                },
                'confusion': {
                    'value': 0,
                    'playedCount': 0,
                    'winningCount': 0,
                    'losingCount': 0
                }
            }
        },
        'meta': {
            'playedCount': {
                'winningCard': 0,
                'losingCard': 0,
                'played': 0
            }
        }
    }
)