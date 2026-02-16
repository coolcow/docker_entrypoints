#!/bin/sh

ENTRYPOINT_COMMAND=$1
shift
ENTRYPOINT_PARAMS=$@

# create user group and home
/ensure_user_group_home.sh

# exec ENTRYPOINT_COMMAND as user
su-exec \
  $TARGET_USER \
  $ENTRYPOINT_COMMAND \
  $ENTRYPOINT_PARAMS
