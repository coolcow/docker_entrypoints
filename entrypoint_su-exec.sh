#!/bin/sh

ENTRYPOINT_COMMAND=$1
shift
ENTRYPOINT_PARAMS=$@

# create user group and home
/create_user_group_home.sh \
  $ENTRYPOINT_USER \
  $ENTRYPOINT_GROUP \
  $ENTRYPOINT_HOME

# exec ENTRYPOINT_COMMAND as user
su-exec \
  $ENTRYPOINT_USER \
  $ENTRYPOINT_COMMAND \
  $ENTRYPOINT_PARAMS
