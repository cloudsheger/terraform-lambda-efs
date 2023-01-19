import json
import urllib.request
import os
def lambda_handler(event, context):
    url = 'http://212.183.159.230/1GB.zip'
    file_name = '/mnt/ztpt-project/tmp-file'
    urllib.request.urlretrieve(url, file_name)
    os.system('ls -l /mnt/ztpt-project')

    return {
      'statusCode': 200,
      'body': json.dumps('Hello from Lambda!')
    }