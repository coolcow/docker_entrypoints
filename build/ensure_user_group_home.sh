#!/bin/sh

TARGET_UID=${TARGET_UID:-1000}
TARGET_GID=${TARGET_GID:-1000}
TARGET_REMAP_IDS=${TARGET_REMAP_IDS:-1}
TARGET_USER=${TARGET_USER:-target}
TARGET_GROUP=${TARGET_GROUP:-target}
TARGET_HOME=${TARGET_HOME:-/home/target}
TARGET_SHELL=${TARGET_SHELL:-/bin/sh}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

ensure_group() {
  EXISTING_GROUP=$(getent group "$TARGET_GID" | cut -f1 -d ':' || true)
  if [ -n "$EXISTING_GROUP" ]; then
    if [ "$EXISTING_GROUP" != "$TARGET_GROUP" ]; then
      groupmod \
        -n "$TARGET_GROUP" \
        "$EXISTING_GROUP"
    fi
    return
  fi

  if getent group "$TARGET_GROUP" >/dev/null 2>&1; then
    CURRENT_GID=$(getent group "$TARGET_GROUP" | cut -d ':' -f3)
    if [ "$CURRENT_GID" != "$TARGET_GID" ]; then
      groupmod \
        -g "$TARGET_GID" \
        "$TARGET_GROUP"
    fi
    return
  fi

  if command_exists groupadd; then
    groupadd \
      --gid "$TARGET_GID" \
      "$TARGET_GROUP"
  else
    addgroup \
      -g "$TARGET_GID" \
      "$TARGET_GROUP"
  fi
}

update_existing_user() {
  SOURCE_USER=$1

  set -- -d "$TARGET_HOME" -g "$TARGET_GID"
  if [ -n "$TARGET_SHELL" ]; then
    set -- "$@" -s "$TARGET_SHELL"
  fi
  if [ "$SOURCE_USER" != "$TARGET_USER" ]; then
    set -- -l "$TARGET_USER" "$@"
  fi

  usermod "$@" "$SOURCE_USER"
}

create_user() {
  if command_exists useradd; then
    set -- --uid "$TARGET_UID" --gid "$TARGET_GID" --home-dir "$TARGET_HOME"
    if [ -n "$TARGET_SHELL" ]; then
      set -- "$@" --shell "$TARGET_SHELL"
    fi
    if [ ! -d "$TARGET_HOME" ]; then
      set -- "$@" --create-home
    fi
    useradd "$@" "$TARGET_USER"
    return
  fi

  adduser \
    -u "$TARGET_UID" \
    -G "$TARGET_GROUP" \
    -h "$TARGET_HOME" \
    -D \
    "$TARGET_USER"
}

remap_if_conflict() {
  TYPE=$1
  ID=$2
  NAME=$3

  if [ "$TYPE" = "user" ]; then
    FILE_PATH=/etc/passwd
    GETENT_DB=passwd
  else
    FILE_PATH=/etc/group
    GETENT_DB=group
  fi

  EXISTING_NAME=$(getent "$GETENT_DB" "$ID" | cut -d ':' -f1 || true)

  if [ -n "$EXISTING_NAME" ] && [ "$EXISTING_NAME" != "$NAME" ]; then
    NEW_ID=$(awk -F: 'BEGIN{ max=1000 } $3>=max{ max=$3 } END{ print max+1 }' "$FILE_PATH")
    if [ "$TYPE" = "user" ]; then
      usermod -u "$NEW_ID" "$EXISTING_NAME"
    else
      groupmod -g "$NEW_ID" "$EXISTING_NAME"
    fi
  fi
}

if [ "$TARGET_REMAP_IDS" = "1" ]; then
  remap_if_conflict group "$TARGET_GID" "$TARGET_GROUP"
  remap_if_conflict user "$TARGET_UID" "$TARGET_USER"
fi

ensure_group

EXISTING_USER=$(getent passwd "$TARGET_UID" | cut -f1 -d ':' || true)
if [ -n "$EXISTING_USER" ]; then
  groupmod \
    -g "$TARGET_GID" \
    "$TARGET_GROUP"
  update_existing_user "$EXISTING_USER"
else
  create_user
fi

if [ ! -d "$TARGET_HOME" ]; then
  mkdir -p "$TARGET_HOME"
fi

chown \
  "$TARGET_USER:$TARGET_GROUP" \
  "$TARGET_HOME"
