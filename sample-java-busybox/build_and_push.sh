#!/bin/bash

source ./buildtools.sh

echo "Building iris image now..."
docker build --force-rm -t $IMAGE_NAME .
exit_if_error "Could not build the image $IMAGE_NAME"

docker push $IMAGE_NAME
exit_if_error "Could not push image $IMAGE_NAME" 
