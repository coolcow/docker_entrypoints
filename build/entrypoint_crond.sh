#!/bin/sh

CROND_PARAMS=$@
if [ -z $CROND_CRONTAB ]; then
    echo "missing environment variable: CROND_CRONTAB"
    exit 1
fi

. /usr/local/bin/ensure_user_group_home.sh

crontab -u $TARGET_USER $CROND_CRONTAB

crond $CROND_PARAMS
