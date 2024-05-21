#!/bin/bash

mkdir -p ~/.aws
envsubst < /backup-scripts/aws_config > ~/.aws/config
sed -i "s/'//g" ~/.aws/config
sed -i 's/\"//g' ~/.aws/config

envsubst < /backup-scripts/cron-config > /backup-scripts/backups-cron
sed -i "s/'//g" /backup-scripts/backups-cron
sed -i 's/\"//g' /backup-scripts/backups-cron

printenv > /etc/environment

crontab /backup-scripts/backups-cron
cron -f


