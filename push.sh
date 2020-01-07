#! /bin/bash

set -e
export AWS_PROFILE=${DEPLOY_PROFILE:?"Required"}
REPO=${TF_VAR_ecr_repo_host:?"Required"}/${TF_VAR_web_server_repo_name:?"Required"}
BUILD_DIR=${BUILD_DIR:?"Required"}

ECS_CLUSTER=${ECS_CLUSTER:?"Required"}
ECS_SERVICE=${ECS_SERVICE:?"Required"}
ECS_TASK_DEFINITION=${ECS_TASK_DEFINITION:?"Required"}
SUBNETS=${SUBNETS:?"Required"}

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
      "name": "web_app_container",
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
