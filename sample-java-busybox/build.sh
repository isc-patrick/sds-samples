#!/bin/bash

source ./buildtools.sh

# if [ "$1" == "all" ];
# then
#     echo "Building java-project jar file..."
#     mvn clean package -f ./java-project/pom.xml
#     exit_if_error "Could not build kafka adapter."

#     echo "java-project jar file built!"
# else
#     if [ ! -d ./java-project/target ];
#     then
#         exit_with_error "The jar file is not available for building the image!"
#     fi
# fi

echo "Building iris image now..."
docker build --force-rm -t $IMAGE_NAME .
exit_if_error "Could not build the image $IMAGE_NAME"

docker tag $IMAGE_NAME $LOCAL_IMAGE_NAME
exit_if_error "Could not tag the image $IMAGE_NAME as $LOCAL_IMAGE_NAME"

# skaffold build --default-repo=$DOCKER_REPOSITORY --tag=$TAG
# exit_if_error "Could not build $IMAGE_NAME image."
