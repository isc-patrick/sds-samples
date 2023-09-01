#!/bin/bash

source ./buildtools.sh


docker tag $DOCKER_LOCAL_REPOSITORY:$TAG $DOCKER_REPOSITORY:$TAG
exit_if_error "Could not tag image $DOCKER_LOCAL_REPOSITORY:$TAG to $DOCKER_REPOSITORY:$TAG."

docker push $DOCKER_REPOSITORY:$TAG
exit_if_error "Could not push image $DOCKER_REPOSITORY:$TAG" 
