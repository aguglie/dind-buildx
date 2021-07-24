# Docker in Docker with buildx
Docker in docker `20.10.7` with buildx `0.6.0`, tested and used in `.gitlab-ci.yml` pipeline, useful to build multi-arch images (amd64 and arm).

```bash
# docker --version
Docker version 20.10.7, build f0df350
```

##  Gitlab-ci boilerplate
`.gitlab-ci.yml` working example: builds an image and pushes it to gitlab's container registry. 

```yaml
variables:
  DOCKER_HOST: tcp://docker:2375/
  DOCKER_DRIVER: overlay2

stages:
  - build

docker-build-master:
  image: guglio/dind-buildx:latest
  stage: build
  services:
    - docker:20.10-dind
  before_script:
    - docker login -u "$CI_REGISTRY_USER" -p "$CI_REGISTRY_PASSWORD" $CI_REGISTRY
  script:
    - docker run --rm --privileged multiarch/qemu-user-static --reset -p yes; docker buildx create --use
    - docker buildx build --push --platform linux/arm/v7,linux/arm64/v8,linux/amd64 --tag "$CI_REGISTRY_IMAGE" .
  only:
    - master


docker-build-tag:
  image: guglio/dind-buildx:latest
  stage: build
  services:
    - docker:20.10-dind
  before_script:
    - docker login -u "$CI_REGISTRY_USER" -p "$CI_REGISTRY_PASSWORD" $CI_REGISTRY
  script:
    - docker run --rm --privileged multiarch/qemu-user-static --reset -p yes; docker buildx create --use
    - docker buildx build --push --platform linux/arm/v7,linux/arm64/v8,linux/amd64 --tag "$CI_REGISTRY_IMAGE:$CI_COMMIT_TAG" .
  only:
    - tags

```
