#!/bin/bash

## example redshift-import-110221-1214
BUCKET_NAME=FILL_IN_HERE  
curl -O -l https://raw.githubusercontent.com/linuxacademy/content-aws-database-specialty/master/S06_Additional%20Database%20Services/redshift-data.csv
aws s3 mb s3://${BUCKET_NAME}
aws s3api put-object --bucket ${BUCKET_NAME} --key redshift-data.csv --body redshift-data.csv
curl -O -l https://raw.githubusercontent.com/linuxacademy/content-aws-database-specialty/master/S06_Additional%20Database%20Services/redshift-data.json
aws dynamodb create-table --table-name redshift-import --attribute-definitions AttributeName=ID,AttributeType=N --key-schema AttributeName=ID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5
