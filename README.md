# farmcoolcow/entrypoints

![](https://img.shields.io/badge/  alpine  -  latest  -lightgray.svg) ![](https://images.microbadger.com/badges/version/farmcoolcow/entrypoints.svg) ![](https://images.microbadger.com/badges/commit/farmcoolcow/entrypoints.svg) ![](https://images.microbadger.com/badges/image/farmcoolcow/entrypoints.svg) ![](https://images.microbadger.com/badges/license/farmcoolcow/entrypoints.svg)
---

## What is this image for ?

This is a base image based on [alpine:latest](https://hub.docker.com/_/alpine/) that bundles some useful entrypoint scripts.

--- 

* [/create_user_group_home.sh](https://github.com/coolcow/docker_entrypoints/blob/master/create_user_group_home.sh) [user] [group] [home]  

  Creates an **user** a **group** and a **home** directory.  
  The group and the home directory are assigned to the user, as well as ```/bin/sh``` as the default **shell**.  
  If the environment variable ```PUID``` is set, the user is created with this id. Otherwise the user id is set to ```1000```.  
  If the environment variable ```PGID``` is set, the group is created with this id. Otherwise the group id is set to ```1000```.  
  
---

* [/entrypoint_su-exec.sh](https://github.com/coolcow/docker_entrypoints/blob/master/entrypoint_su-exec.sh) [command] [params...]  

  First creates an user, group and home directory, by executing **```/create_user_group_home.sh```** with the parameters ```$ENTRYPOINT_USER``` ```$ENTRYPOINT_GROUP``` ```$ENTRYPOINT_HOME```.  
  Then uses **```su-exec```** to exec ```$ENTRYPOINT_COMMAND``` with the given parameters as the user ```$ENTRYPOINT_USER```.
  > see [farmcoolcow/rclone](https://hub.docker.com/r/farmcoolcow/rclone) to see this entryoint in action.
  
---

* [/entrypoint_crond.sh](https://github.com/coolcow/docker_entrypoints/blob/master/entrypoint_crond.sh) [params...]  

  First creates an user, group and home directory, by executing **```/create_user_group_home.sh```** with the parameters ```$ENTRYPOINT_USER``` ```$ENTRYPOINT_GROUP``` ```$ENTRYPOINT_HOME```.   
  Then sets the crontab file ```$CROND_CRONTAB``` as the crontab of the user ```$ENTRYPOINT_USER```.   
  Finally executes **```crond```** with the given parameters.
  > see [farmcoolcow/rclone-cron](https://hub.docker.com/r/farmcoolcow/rclone-cron) to see this entryoint in action.
  

