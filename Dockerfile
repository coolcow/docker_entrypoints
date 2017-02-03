FROM alpine

MAINTAINER Jean-Michel Ruiz (coolcow) <mail@coolcow.org>

# Build-time metadata as defined at http://label-schema.org

ARG BUILD_DATE
ARG VCS_REF
ARG IMAGE_NAME
ARG VERSION="latest"

LABEL maintainer="Jean-Michel Ruiz (coolcow) <mail@coolcow.org>" \
      org.label-schema.build-date="$BUILD_DATE" \
      org.label-schema.description="Docker base image with su-exec and crond entrypoint scripts, based on alpine." \
      org.label-schema.name="$IMAGE_NAME" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.url="https://hub.docker.com/r/$IMAGE_NAME/" \
      org.label-schema.license="GPL-3.0" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/farmcoolcow/docker_entrypoints" \
      org.label-schema.vendor="coolcow.org" \
      org.label-schema.version="$VERSION"


# Install shadow (for usermod and groupmod) and su-exec

RUN apk --no-cache --update add \
      shadow \
      su-exec

COPY create_user_group_home.sh \
     entrypoint_su-exec.sh \
     entrypoint_crond.sh \
     /

RUN chmod +x \
      /create_user_group_home.sh \
      /entrypoint_su-exec.sh \
      /entrypoint_crond.sh

