#!/bin/bash

CONFIG_BUCKET=${CONFIG_BUCKET:-application-environments}
ENVIRONMENT=${ENVIRONMENT:-development}

if [[ "$ENVIRONMENT" == "production" ]]; then
  aws s3 cp s3://$CONFIG_BUCKET/devops-statusboard/$ENVIRONMENT/sys.config .
fi

./bin/dashboard foreground
