#!/bin/bash

source ./utils.sh

source ./conf.sh

trace "Removing containers..."
docker-compose rm -f

trace "Cleaning IRIS Adaptive Analytics Durable Folder"
docker volume rm business-360_irisaa-data
docker volume rm business-360_irisaa-conf
docker volume rm business-360_irisaa-log
rm -rf ./irisaa-volumes/conf
rm -rf ./irisaa-volumes/data
rm -rf ./irisaa-volumes/log

trace "Cleaning IRIS Durable Folder"
rm -rf ./iris-volumes/DurableSYS
rm -rf ./iris-volumes/generated-files

trace "If you are using Windows and some files could not be removed, please use Windows explorer to remove the entire ./iris-volumes/DurableSYS folder."

