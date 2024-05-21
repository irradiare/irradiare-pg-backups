#!/bin/bash

docker buildx create --use
docker buildx build --platform linux/amd64,linux/arm64 -t irradiare/irradiare-pg-backups:16-bookworm -t irradiare/irradiare-pg-backups:latest --push .
# docker push irradiare --all-tags

echo "Done building and pushing image"
