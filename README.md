# ghcr.io/coolcow/entrypoints - Asset Image

This repository provides a minimal **asset image** (built `FROM scratch`) that bundles common entrypoint scripts. This image is not intended to be used directly as a base image, but rather to provide its scripts to other Docker images via [multi-stage builds](https://docs.docker.com/build/building/multi-stage/) using `COPY --from`.

This approach centralizes common script logic, ensures versioning, and allows downstream images to choose their own base operating system while still benefiting from these shared utilities.

## Usage

Instead of using `FROM ghcr.io/coolcow/entrypoints`, you should integrate these scripts into your application's `Dockerfile` using `COPY --from`.

**Example `Dockerfile` for a downstream project:**

```dockerfile
# Stage 1: Fetch the entrypoint scripts from the asset image
FROM ghcr.io/coolcow/entrypoints:v1.1.0 AS entrypoints

# Stage 2: Your actual application image
FROM node:20-alpine # Or any other base image like alpine, ubuntu, python, etc.

# Copy the desired scripts from the asset stage
COPY --from=entrypoints /assets/create_user_group_home.sh /usr/local/bin/create_user_group_home.sh
COPY --from=entrypoints /assets/entrypoint_su-exec.sh /usr/local/bin/entrypoint_su-exec.sh

# Make the scripts executable
RUN chmod +x /usr/local/bin/create_user_group_home.sh \
           /usr/local/bin/entrypoint_su-exec.sh

# Set the entrypoint for your application (e.g., using su-exec)
ENTRYPOINT ["entrypoint_su-exec.sh"]

# Your application-specific setup continues here...
# COPY package.json .
# RUN npm install
# COPY . .
# CMD ["npm", "start"]
```

## Provided Scripts

The `coolcow/entrypoints` asset image provides the following scripts, located in the `/assets/` directory within the image:

*   [`/assets/create_user_group_home.sh`](build/create_user_group_home.sh): Creates a user, group, and home directory. Honors `PUID`/`PGID` if provided.
*   [`/assets/entrypoint_su-exec.sh`](build/entrypoint_su-exec.sh): Creates the user/group/home then executes a command as that user via `su-exec`.
*   [`/assets/entrypoint_crond.sh`](build/entrypoint_crond.sh): Creates the user/group/home, installs a crontab, and runs `crond`.

## Building and Testing

This project uses GitHub Actions to build, test, and publish the asset image. For local development or debugging, you can run the tests manually:

1.  **Build the asset image locally:**
    ```bash
    docker build -t ghcr.io/coolcow/entrypoints:local-test-build -f build/Dockerfile build
    ```
2.  **Run the smoke tests:**
    ```bash
    docker build --build-arg ASSET_IMAGE=ghcr.io/coolcow/entrypoints:local-test-build -f build/Dockerfile.test build
    ```

*   The `Dockerfile` (`build/Dockerfile`) defines the `FROM scratch` asset image.
*   The `Dockerfile.test` (`build/Dockerfile.test`) contains verification steps to ensure the scripts are correctly included and functional.
*   The `build-test-publish.yml` workflow (`.github/workflows/build-test-publish.yml`) orchestrates the build, runs the tests, and pushes the final image to `ghcr.io`.
