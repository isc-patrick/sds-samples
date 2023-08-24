#!/bin/bash

source ./utils.sh

source ./conf.sh

trace "Removing containers..."
docker-compose rm -f

trace "Cleaning IRIS Adaptive Analytics Durable Folder"
rm -rf ./irisaa-volumes/conf
rm -rf ./irisaa-volumes/data
rm -rf ./irisaa-volumes/log

trace "Cleaning IRIS Durable Folder"
rm -rf ./iris-volumes/DurableSYS
rm -rf ./iris-volumes/generated-files
