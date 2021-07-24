FROM docker:20.10-dind
COPY --from=docker/buildx-bin:0.6.0 /buildx /usr/libexec/docker/cli-plugins/docker-buildx
RUN docker buildx version
