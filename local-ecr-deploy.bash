#!/usr/bin/bash

imageName="your-image-name"
region=$(aws configure get region)
accountId=$(aws sts get-caller-identity --query "Account" --output text)




aws ecr get-login-password --region $region | docker login --username AWS --password-stdin $accountId.dkr.ecr.$region.amazonaws.com
aws ecr create-repository \
    --repository-name $imageName \
    --image-scanning-configuration scanOnPush=true \
    --region $region

docker build -t $imageName .
docker images --filter reference=$imageName
docker tag $imageName:latest $accountId.dkr.ecr.$region.amazonaws.com/$imageName:latest
docker push $accountId.dkr.ecr.$region.amazonaws.com/$imageName:latest