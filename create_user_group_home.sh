#!/bin/sh

# default PUID if not set
DEFAULT_PGID=1000
# default PGID if not set
DEFAULT_PUID=1000

CREATE_USER=$1
CREATE_GROUP=$2
CREATE_HOME=$3

# set default GroupID and default UserID if not already set
if [ -z $PGID ]; then PGID=$DEFAULT_PGID; fi
if [ -z $PUID ]; then PUID=$DEFAULT_PUID; fi


# does a group with PGID already exist ?
EXISTING_GROUP=$(getent group $PGID | cut -f1 -d ':')
if [ ! -z $EXISTING_GROUP ]; then
  # change name of the existing group
  groupmod \
    -n $CREATE_GROUP \
    $EXISTING_GROUP
else
  # create new group with PGID
  addgroup \
    -g $PGID \
    $CREATE_GROUP  
fi  

# does a user with PUID already exist ?
EXISTING_USER=$(getent passwd $PUID | cut -f1 -d ':')
if [ ! -z $EXISTING__USER ]; then 
  # change login, home, shell and primary group of the existing user
  usermod \
    -l $CREATE_USER \
    -d $CREATE_HOME \
    -s /bin/sh \
    -g $PGID \
    $EXISTING_USER
else
  # create new user with PUID, GROUP and HOME
  adduser \
    -u $PUID \
    -G $CREATE_GROUP \
    -h $CREATE_HOME \
    -D \
    $CREATE_USER  
fi  

# create user, group, and home
chown \
  $CREATE_USER:$CREATE_GROUP \
  $CREATE_HOME
