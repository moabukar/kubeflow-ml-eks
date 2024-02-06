#!/usr/bin/env bash


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/set_env.sh

# set region
region=
if [ "$#" -eq 1 ]; then
    region=$1
else
    echo "usage: $0 <aws-region>"
    exit 1
fi

image=$IMAGE_NAME
tag=$IMAGE_TAG

# Get the account number associated with the current IAM credentials
account=$(aws sts get-caller-identity --query Account --output text)

if [ $? -ne 0 ]
then
    exit 255
fi

fullname="${account}.dkr.ecr.${region}.amazonaws.com/${image}:${tag}"

# If the repository doesn't exist in ECR, create it.

aws ecr describe-repositories --region ${region} --repository-names "${image}" > /dev/null 2>&1

if [ $? -ne 0 ]
then
    aws ecr create-repository --region ${region} --repository-name "${image}" > /dev/null
fi


# Build the docker image locally with the image name and then push it to ECR
# with the full name.

aws ecr get-login-password --region us-west-2 \
		| docker login --username AWS --password-stdin 763104351884.dkr.ecr.us-west-2.amazonaws.com

docker build  -t ${image} $DIR/..
docker tag ${image} ${fullname}

# Get the login command from ECR and execute it directly
aws ecr get-login-password --region ${region} \
		| docker login --username AWS --password-stdin ${account}.dkr.ecr.${region}.amazonaws.com

docker push ${fullname}
if [ $? -eq 0 ]; then
	echo "Amazon ECR URI: ${fullname}"
	sed -i -e "s|image:.*|image: ${fullname}|g" $DIR/../../charts/maskrcnn/values.yaml
	sed -i -e "s|image:.*|image: ${fullname}|g" $DIR/../../charts/maskrcnn-jupyter/values.yaml
else
	echo "Error: Image build and push failed"
	exit 1
fi