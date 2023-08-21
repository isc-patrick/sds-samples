#!/bin/bash

source ./utils.sh

trace "Starting..."

if [ ! -f ./CONF_DOCKER_GTW ];
then
    trace "Configuring ./CONF_DOCKER_GTW with default Gateway of 172.20.0.1. If IRIS Adaptive Analytics doesn't start with this default configuration, please read the README.md file."
    printf "172.20.0.1" >> ./CONF_DOCKER_GTW
fi

if [ ! -f ./CONF_DOCKER_SUBNET ];
then
    trace "Configuring ./CONF_DOCKER_SUBNET with default Gateway of 172.20.0.1. If IRIS Adaptive Analytics doesn't start with this default configuration, please read the README.md file."
    printf "172.20.0.0/16" >> ./CONF_DOCKER_SUBNET
fi

if [ ! -f ./CONF_FRONTEND_LOCAL_PORT ];
then
    trace "Configuring ./CONF_FRONTEND_LOCAL_PORT with default host port for Angular frontend."
    printf "8081" >> ./CONF_FRONTEND_LOCAL_PORT
fi

if [ ! -f ./CONF_IRIS_LOCAL_JDBC_PORT ];
then
    trace "Configuring ./CONF_IRIS_LOCAL_JDBC_PORT with default host port for IRIS JDBC."
    printf "41972" >> ./CONF_IRIS_LOCAL_JDBC_PORT
fi

if [ ! -f ./CONF_IRIS_LOCAL_WEB_PORT ];
then
    trace "Configuring ./CONF_IRIS_LOCAL_WEB_PORT with default host port for IRIS Management Portal."
    printf "42773" >> ./CONF_IRIS_LOCAL_WEB_PORT
fi

export CONF_DOCKER_SUBNET=$(head -1 ./CONF_DOCKER_SUBNET)

export CONF_DOCKER_GTW=$(head -1 ./CONF_DOCKER_GTW)

export CONF_FRONTEND_LOCAL_PORT=$(head -1 ./CONF_FRONTEND_LOCAL_PORT)

export CONF_IRIS_LOCAL_JDBC_PORT=$(head -1 ./CONF_IRIS_LOCAL_JDBC_PORT)

export CONF_IRIS_LOCAL_WEB_PORT=$(head -1 ./CONF_IRIS_LOCAL_WEB_PORT)

export VERSION=$(head -1 ./VERSION)

if [ ! -f ./licenses/iris.key ];
then
    exit_with_error "Could not find file './licenses/iris.key'."
fi

if [ ! -f ./licenses/AtScaleLicense.json ];
then
    exit_with_error "Could not find file './licenses/AtScaleLicense.json'. "
fi

trace "Making sure ./iris-volumes can be writable for other users so that irisowner inside the container can create dur folder..."
if [ ! -d ./iris-volumes/dur ];
then
    chmod o+rwx ./iris-volumes
fi

trace "Making sure ./iris-volumes has the generated-files folder"
if [ ! -d ./iris-volumes/generated-files ];
then
    mkdir -p ./iris-volumes/generated-files
    chmod og+rwx ./iris-volumes/generated-files
fi

trace "Making sure ./irisaa-volumes can be writable for other users so that atscale inside the container can create its conf and data folders..."
if [ ! -d ./irisaa-volumes/conf ];
then
    chmod o+rwx ./iris-volumes
    mkdir -p ./irisaa-volumes/conf
    chmod o+w,g+w ./irisaa-volumes/conf
fi

if [ ! -d ./irisaa-volumes/data ];
then
    chmod o+rwx ./iris-volumes
    mkdir -p ./irisaa-volumes/data
    chmod o+w,g+w ./irisaa-volumes/data
fi

trace "Starting the composition..."
docker-compose up --remove-orphans -d
exit_if_error "Could not start composition."

trace "Composition started."