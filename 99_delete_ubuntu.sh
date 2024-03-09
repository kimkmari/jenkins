#!/bin/bash

# 현재 running 중인 jenkins-aws-cli-generate instance 호출
INSTANCE_ID=$(aws ec2 describe-instances \
  --output text \
  --filters Name=instance-state-name,Values=running Name=tag:Name,Values=jenkins-aws-cli-generate \
  --query 'Reservations[*].Instances[*].InstanceId' \
  | awk 'NR==1{print $1}')

#
#PARAMETER_NUM=$#
#if [ "$#" == "1" ];then
#	  INSTANCE_ID=$1
#else
#	INSTANCE_ID=i-028bcc67066f5cd9c
#fi

aws ec2 terminate-instances --instance-ids ${INSTANCE_ID}
