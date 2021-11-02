#!/bin/bash

## example redshift-import-110221-1214
BUCKET_NAME=FILL_IN_HERE  
curl -O -l https://raw.githubusercontent.com/linuxacademy/content-aws-database-specialty/master/S06_Additional%20Database%20Services/redshift-data.csv
sleep 3
aws s3 mb s3://${BUCKET_NAME}
aws s3api put-object --bucket ${BUCKET_NAME} --key redshift-data.csv --body redshift-data.csv
curl -O -l https://raw.githubusercontent.com/linuxacademy/content-aws-database-specialty/master/S06_Additional%20Database%20Services/redshift-data.json
sleep 3
aws dynamodb create-table --table-name redshift-import --attribute-definitions AttributeName=ID,AttributeType=N --key-schema AttributeName=ID,KeyType=HASH --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5
aws dynamodb list-tables
aws dynamodb batch-write-item --request-items file://redshift-data.json
aws dynamodb scan --table-name redshift-import


# arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess
# arn:aws:iam::aws:policy/AmazonDynamoDBReadOnlyAccess

aws iam create-role --role-name redshift-import --tags Key=name,Value=redshift-import --assume-role-policy-document file://assume-role-policy-document.json
aws iam get-role --role-name redshift-import
aws iam attach-role-policy --role-name redshift-import --policy-arn arn:aws:iam::aws:policy/AmazonDynamoDBReadOnlyAccess
aws iam attach-role-policy --role-name redshift-import --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess
aws iam list-attached-role-policies --role-name redshift-import


sudo yum install postgresql
export REDSHIFT_ROLE_ARN=$(aws iam list-roles | jq .Roles | jq -r '.[].Arn | select(contains("redshift-import"))')
export PGHOST=$(aws redshift describe-clusters | jq -r .Clusters[0].Endpoint.Address)
export CLUSTER_IDENTIFIER=$(aws redshift describe-clusters | jq -r .Clusters[0].ClusterIdentifier)
aws redshift modify-cluster-iam-roles  --cluster-identifier $CLUSTER_NAME --add-iam-roles $REDSHIFT_ROLE_ARN
