#!/bin/bash
set -e
export MSYS_NO_PATHCONV=1

. ./env.sh

AWS_PROFILE=${AWS_PROFILE}
JENKINS_SG=${JENKINS_SG}

# ==========================================================================================================

# aws ec2 describe-images -> AMI 정보 검색 CLI 명령어
# --filters option 정보 검색 결과를 필터링 해주는 옵션-> ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64 인 AMI 검색
# --query option 출력 형식을 지정하는데 사용되는 옵션 -> ImageId과 CreationDate만 반환할 수 있도록 설정
# --output text option 텍스트 포멧으로 결과가 나오도록 해주는 옵션
# --region 설치할 지역 지정 옵션
# 최신 AMI 가져오는 법  | | sort -k2 -r \  | head -n1
# 하나만 프린트 해오기  | awk '{print $1}')

UBUNTU_AMI_ID=$(aws ec2 describe-images \
 --filters Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64* \
 --query 'Images[*].[ImageId,CreationDate]' --output text \
 --region ap-northeast-2 \
 | sort -k2 -r \
 | head -n1 | awk '{print $1}')

echo ${UBUNTU_AMI_ID}
echo ${JENKINS_SG}
# ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20220921.1-47489723-7305-4e22-8b22-b0d57054f216
# ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20220921.1
UBUNTU_AMI_ID=ami-025dc74c3d96ebf57
#VPC_ID=$(aws ec2 describe-vpcs --output text --query "Vpcs[*].[Tags[?Key=='Name'].Value|[0],VpcId]" | grep ${FILTER} | awk '{print $2}')
VPC_ID=${VPC_ID}

#SUBNET_ID=$(aws ec2 describe-subnets --output text --query "Subnets[*].[SubnetId,CidrBlock,AvailabilityZone,Tags[?Key=='Name'].Value|[0]]" | grep ${FILTER} | grep "public1" | awk '{print $1}')
SUBNET_ID=${SUBNET_ID}

echo ${VPC_ID}
echo ${SUBNET_ID}

# if [ "${USERDATA_FILE}x" == "x" ];then
aws ec2 run-instances \
  --image-id ${UBUNTU_AMI_ID} \
  --count 1 \
  --instance-type t3.large \
  --key-name ${KEY_NAME} \
  --subnet-id ${SUBNET_ID} \
  --security-group-ids ${JENKINS_SG} \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=jenkins-aws-cli-generate}]' \
  --block-device-mappings 'DeviceName=/dev/sda1,Ebs={VolumeSize=100}' \
  --user-data file://userdata.txt


# else
#   aws ec2 run-instances \
#     --image-id ${UBUNTU_AMI_ID} \
#     --count 1 \
#     --instance-type t3.small \
#     --key-name webserver \
#     --security-group-ids ${JENKINS_SG} \
#     --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=aws-cli-generate}]' \
#     --user-data file://ud.txt
# fi

# i-0e3557b4268045519
