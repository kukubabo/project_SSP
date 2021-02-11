#!/bin/bash

### Set EKS info. #########################
REGION_NAME=ap-southeast-2
CLUSTER_NAME=SSP-d-eks
#GROUP_NAME=USER
###########################################

### get account id ########################
ACCOUNT_ID=`aws sts get-caller-identity | jq -r .Account`
###########################################

### delete role in aws-auth as a master ###
eksctl delete iamidentitymapping \
  --cluster ${CLUSTER_NAME} \
  --arn arn:aws:iam::${ACCOUNT_ID}:role/SSP-d-role-eksadmin --username admin

eksctl delete iamidentitymapping \
  --cluster eksworkshop-eksctlv \
  --arn arn:aws:iam::${ACCOUNT_ID}:role/SSP-d-role-eksuser --username dev-user
###########################################

### delete role ###########################
aws iam delete-role \
  --role-name SSP-d-role-eksadmin
aws iam delete-role \
  --role-name SSP-d-role-eksuser
###########################################
