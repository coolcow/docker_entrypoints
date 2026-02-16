#!/bin/sh

CROND_PARAMS=$@
if [ -z $CROND_CRONTAB ]; then
    echo "missing environment variable: CROND_CRONTAB"
    exit 1
fi

# create user group and home
/ensure_user_group_home.sh

# configure and exec cron deamon
crontab \
  -u $TARGET_USER \
  $CROND_CRONTAB

crond \
  $CROND_PARAMS
