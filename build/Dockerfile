# This Dockerfile builds a minimal, OS-less "asset image" FROM scratch.
# It contains common entrypoint scripts that can be copied into other images
# using multi-stage builds (`COPY --from=...`).

FROM scratch

# Copy scripts to a dedicated assets directory
COPY create_user_group_home.sh \
     entrypoint_su-exec.sh \
     entrypoint_crond.sh \
     /assets/

# Metadata labels describing the image
ENV LABEL_MAINTAINER="Jean-Michel Ruiz (coolcow) <mail@coolcow.org>" \
    LABEL_VENDOR="coolcow.org" \
    LABEL_IMAGE_NAME="ghcr.io/coolcow/entrypoints" \
    LABEL_URL="https://ghcr.io/coolcow/entrypoints" \
    LABEL_VCS_URL="https://github.com/coolcow/docker-entrypoints" \
    LABEL_DESCRIPTION="Minimal asset image containing common entrypoint scripts for coolcow projects." \
    LABEL_LICENSE="GPL-3.0"

ARG LABEL_VERSION="latest"
ARG LABEL_BUILD_DATE
ARG LABEL_VCS_REF

# Build-time metadata as defined at http://label-schema.org
LABEL maintainer=$LABEL_MAINTAINER \
      org.label-schema.build-date=$LABEL_BUILD_DATE \
      org.label-schema.description=$LABEL_DESCRIPTION \
      org.label-schema.name=$LABEL_IMAGE_NAME \
      org.label-schema.schema-version="1.0" \
      org.label-schema.url=$LABEL_URL \
      org.label-schema.license=$LABEL_LICENSE \
      org.label-schema.vcs-ref=$LABEL_VCS_REF \
      org.label-schema.vcs-url=$LABEL_VCS_URL \
      org.label-schema.vendor=$LABEL_VENDOR \
      org.label-schema.version=$LABEL_VERSION


