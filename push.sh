#! /bin/bash

set -e
export AWS_PROFILE=${AWS_PROFILE:-"ecs-deploy"}
REPO=${REPO:-"381040904611.dkr.ecr.eu-central-1.amazonaws.com/sample-django-app"}
BUILD_DIR=${BUILD:-"/home/eugene/dev/contracts/avanan/example_django_app"}

ECS_CLUSTER=${ECS_CLUSTER:-"arn:aws:ecs:eu-central-1:381040904611:cluster/splunk"}
ECS_SERVICE=${ECS_SERVICE:-"arn:aws:ecs:eu-central-1:381040904611:service/web-server-service"}
ECS_TASK_DEFINITION=${ECS_TASK_DEFINITION:-"arn:aws:ecs:eu-central-1:381040904611:task-definition/service"}
SUBNETS=${SUBNETS:-'["subnet-426da63f", "subnet-7ded7d16", "subnet-dd3a8690"]'}

while getopts "bdm" OPTION; do
    case $OPTION in
    b)
        BUILD=true
        ;;
    d)
        UPDATE=true
        ;;
    m)
        MIGRATE=true
        ;;
    *)
        echo "Incorrect options provided"
        exit 1
        ;;
    esac
done

if [[ $BUILD = true ]]
then
  TAG_NAME="${REPO}:latest"
  $(aws ecr get-login --no-include-email)
  docker build ${BUILD_DIR} -t $TAG_NAME
  docker push $TAG_NAME
fi

if [[ $MIGRATE = true ]]
then
  aws ecs run-task \
    --cluster $ECS_CLUSTER \
    --task-definition $ECS_TASK_DEFINITION \
    --launch-type "FARGATE" \
    --network-configuration "
{
  \"awsvpcConfiguration\": {
    \"subnets\": ${SUBNETS},
    \"assignPublicIp\": \"ENABLED\"
  }
}
" \
    --overrides '
{
  "containerOverrides": [
    {
      "name": "splunk_public_container",
      "command": ["python", "manage.py", "migrate"]
    }
  ]
}
'
fi

if [[ $UPDATE = true ]]
then
  aws ecs update-service \
    --force-new-deployment \
    --cluster $ECS_CLUSTER \
    --service $ECS_SERVICE
fi
