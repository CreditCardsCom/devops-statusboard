#!/bin/bash

if [ -z $ARTIFACTORY_USER ]; then
  echo "ARTIFACTORY_USER not set."
  exit 1
fi

if [ -z $ARTIFACTORY_KEY ]; then
  echo "ARTIFACTORY_KEY not set."
  exit 1
fi

DOCKER_REPO='packages.creditcards.com:5001'
NAME=`echo $TRAVIS_REPO_SLUG | cut -d '/' -f2`
IMAGE_NAME="$DOCKER_REPO/$NAME:$TRAVIS_TAG"

docker login -u $ARTIFACTORY_USER -p $ARTIFACTORY_KEY $DOCKER_REPO
docker build -t $IMAGE_NAME .
docker push $IMAGE_NAME
