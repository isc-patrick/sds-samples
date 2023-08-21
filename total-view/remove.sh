#!/bin/bash

source ./utils.sh

trace "Removing containers..."
docker-compose rm -f

trace "Cleaning IRIS Adaptive Analytics Durable Folder"
rm -rf ./irisaa-volumes/conf
rm -rf ./irisaa-volumes/data

trace "Cleaning IRIS Durable Folder"
rm -rf ./iris-volumes/dur
rm -rf ./iris-volumes/generated-files
