#!/bin/sh

ENTRYPOINT_COMMAND=$1
shift
ENTRYPOINT_PARAMS=$@

. /usr/local/bin/ensure_user_group_home.sh

su-exec \
  $TARGET_USER \
  $ENTRYPOINT_COMMAND \
  $ENTRYPOINT_PARAMS
