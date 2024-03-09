#!/bin/bash

aws ec2 describe-instances \
  --output text \
  --query "Reservations[*].Instances[*].[Tags[?Key=='Name'].Value|[0],InstanceId,PublicIpAddress,PrivateIpAddress,State.Name]" \
  --region ap-northeast-2 | grep aws-cli-generate

# 현재 running 중인 jenkins-aws-cli-generate instance 호출
INSTANCE_ID=$(aws ec2 describe-instances \
  --output text \
  --filters Name=instance-state-name,Values=running Name=tag:Name,Values=jenkins-aws-cli-generate \
  --query 'Reservations[*].Instances[*].InstanceId' \
  | awk 'NR==1{print $1}')

echo $INSTANCE_ID