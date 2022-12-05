FROM clickable/ci-16.04-arm64:6.24.0

ENV DEBIAN_FRONTEND=noninteractive \
    DOCKER_HOST=unix:///var/run/docker.sock \
    volume /var/run/docker.sock:/var/run/docker.sock

