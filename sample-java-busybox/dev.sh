#!/bin/bash

source ./buildtools.sh

echo "Starting skaffold dev..."
skaffold dev -p dev --port-forward=true --default-repo local-registry:5000 --cleanup=false --tail=false --tag=$TAG

trace "Skaffold has stopped syncing your code changes, but the project is still running on the cluster."
msg "If you need to stop the project and delete its resources from the cluster, run the ./dev-delete.sh script. "