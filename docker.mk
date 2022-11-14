VERSION ?= $(shell semver format '%M.%m.%p%s')
REPO=meduza
IMAGE_NAME=${DOCKER_REPOSITORY}/${REPO}:${VERSION}

docker-release: docker-build docker-push
docker-build: check-args
	docker build --platform linux/amd64 -t ${IMAGE_NAME} .
docker-push: check-args
	docker push ${IMAGE_NAME}
check-args:
ifndef VERSION
	$(error VERSION is undefined)
endif
ifndef DOCKER_REPOSITORY
	$(error DOCKER_REPOSITORY is undefined)
endif
