#!/bin/bash

### Set EKS info. #########################
REGION_NAME=ap-southeast-2
CLUSTER_NAME=SSP-d-eks
#GROUP_NAME=USER
###########################################

### get account id ########################
ACCOUNT_ID=`aws sts get-caller-identity | jq -r .Account`
###########################################

### define policy #########################
POLICY=$(echo -n '{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"AWS":"arn:aws:iam::'; echo -n "$ACCOUNT_ID"; echo -n ':root"},"Action":"sts:AssumeRole","Condition":{}}]}')
### print ACCOUNT_ID, POLICY
#echo ACCOUNT_ID=$ACCOUNT_ID
#echo POLICY=$POLICY
###########################################

### create role ###########################
aws iam create-role \
  --role-name SSP-d-role-eksadmin \
  --description "Kubernetes administrator role (for AWS IAM Authenticator for Kubernetes)." \
  --assume-role-policy-document "$POLICY" \
  --output text \
  --query 'Role.Arn'

aws iam create-role \
  --role-name SSP-d-role-eksuser \
  --description "Kubernetes developer role (for AWS IAM Authenticator for Kubernetes)." \
  --assume-role-policy-document "$POLICY" \
  --output text \
  --query 'Role.Arn'
###########################################

### create and put policy in ${GROUP_NAME}
#ADMIN_GROUP_POLICY=$(echo -n '{
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Sid": "AllowAssumeOrganizationAccountRole",
#      "Effect": "Allow",
#      "Action": "sts:AssumeRole",
#      "Resource": "arn:aws:iam::'; echo -n "$ACCOUNT_ID"; echo -n ':role/k8sAdmin"
#    }
#  ]
#}')
### pring ADMIN_GROUP_POLICY
#echo ADMIN_GROUP_POLICY=$ADMIN_GROUP_POLICY

#aws iam put-group-policy \
#--group-name ${GROUP_NAME} \
#--policy-name k8sAdmin-policy \
#--policy-document "$ADMIN_GROUP_POLICY"
###########################################

### put role in aws-auth as a master ######
eksctl create iamidentitymapping \
  --cluster ${CLUSTER_NAME} \
  --arn arn:aws:iam::${ACCOUNT_ID}:role/SSP-d-role-eksadmin \
  --username admin \
  --group system:masters

eksctl create iamidentitymapping \
  --cluster ${CLUSTER_NAME} \
  --arn arn:aws:iam::${ACCOUNT_ID}:role/SSP-d-role-eksuser \
  --username dev-user
###########################################

### User Guide
echo "### user setting guide (get kubeconfig) ###############"
echo "aws eks update-kubeconfig --name ${CLUSTER_NAME} --region ${REGION_NAME} --role-arn arn:aws:iam::${ACCOUNT_ID}:role/SSP-d-role-eksadmin"
echo "aws eks update-kubeconfig --name ${CLUSTER_NAME} --region ${REGION_NAME} --role-arn arn:aws:iam::${ACCOUNT_ID}:role/SSP-d-role-eksuser"
echo "#######################################################"
