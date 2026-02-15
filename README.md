# ghcr.io/coolcow/entrypoints

This repository provides a minimal Alpine-based (`alpine:latest`) base image that bundles a few lightweight entrypoint scripts:
This image is intended to be used as a base image for other Docker images so the bundled entrypoint scripts can be reused and setup logic is not duplicated.

* [`create_user_group_home.sh`](build/create_user_group_home.sh): creates a user, group and home directory. Honors `PUID`/`PGID` if provided.
* [`entrypoint_su-exec.sh`](build/entrypoint_su-exec.sh): creates the user/group/home then executes a command as that user via `su-exec`.
* [`entrypoint_crond.sh`](build/entrypoint_crond.sh): creates the user/group/home, installs a crontab and runs `crond`.
