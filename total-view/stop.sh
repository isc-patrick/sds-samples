#!/bin/bash

source ./utils.sh

source ./conf.sh

trace "Stopping..."

docker-compose stop 
exit_if_error "Could not stop composition."

trace "Composition stopped."