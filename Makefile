SHELL := /bin/bash

PUBLIC_DOCKER_REGISTRY = docker.io
DOCKER_PROJECT = linkernetworks

BUILD_DATE := $(shell date +%Y.%m.%d.%H:%M:%S)

GIT_SYMREF := $(shell git rev-parse --abbrev-ref HEAD | sed -e 's![^A-Za-z0-9]!-!g')
GIT_REV_SHORT := $(shell git rev-parse --short HEAD)
GIT_DESCRIBE := $(shell git describe --all --long)
BUILD_REVISION := $(GIT_REV_SHORT)

# container image definitions
# IMAGE_TAG := latest
# IMAGE_TAG := $(shell git rev-parse --abbrev-ref HEAD)
ifeq ($(IMAGE_TAG),)
IMAGE_TAG := $(GIT_SYMREF)-$(GIT_REV_SHORT)
endif


# image anchor tag should refers to "latest" or "develop"
ifeq ($(IMAGE_ANCHOR_TAG),)
IMAGE_ANCHOR_TAG := $(GIT_SYMREF)
endif

# DOCKER_BUILD_FLAGS=--quiet
NOTEBOOK_DOCKERFILES := $(sort $(wildcard notebooks/*/Dockerfile$(DOCKERFILE_VARIANT)))
NOTEBOOK_DIRS := $(patsubst %/Dockerfile,%,$(basename $(NOTEBOOK_DOCKERFILES)))
NOTEBOOK_NAMES := $(notdir $(NOTEBOOK_DIRS))
NOTEBOOK_TARGETS := $(addprefix notebook-image-,$(NOTEBOOK_NAMES))

BASE_DOCKERFILES := $(sort $(wildcard base/*/Dockerfile$(DOCKERFILE_VARIANT)))
BASE_DIRS := $(patsubst %/Dockerfile,%,$(basename $(BASE_DOCKERFILES)))
BASE_NAMES := $(notdir $(BASE_DIRS))
BASE_TARGETS := $(addprefix base-image-,$(BASE_NAMES))

# The DOCKERFILE_VARIANT can be specified from the command line arguments
# to build a specific Dockerfile. for example, "Dockerfile.gpu", e.g.,
#
#     make trainer-image-caffe-trainer DOCKERFILE_VARIANT=".gpu"
#
IMAGE_NAMES := $(APP_NAMES)
PUSH_NOTEBOOK_IMAGES := $(addprefix push-public-image-,$(NOTEBOOK_NAMES))
PUSH_BASE_IMAGES := $(addprefix push-public-image-,$(BASE_NAMES))

all: base-images push-base-images notebook-images push-notebook-images 

# the first pattern % will locate the Dockerfile,
# the given DOCKERFILE_VARIANT can be used for specifying which Dockerfile to use.
# when DOCKERFILE_VARIANT is given, the tag :latest won't be used.
notebook-image-%: notebooks/%/Dockerfile$(DOCKERFILE_VARIANT) $(shell find notebooks/$* -type f)
ifeq ($(strip $(DOCKERFILE_VARIANT)),)
	time docker build $(DOCKER_BUILD_FLAGS) \
		--tag $(PUBLIC_DOCKER_REGISTRY)/$(DOCKER_PROJECT)/$*:$(IMAGE_TAG) \
		--tag $(PUBLIC_DOCKER_REGISTRY)/$(DOCKER_PROJECT)/$*:$(IMAGE_ANCHOR_TAG) \
		--file $< \
		$(dir $<)
else
	time docker build $(DOCKER_BUILD_FLAGS) \
		--tag $(PUBLIC_DOCKER_REGISTRY)/$(DOCKER_PROJECT)/$*:$(IMAGE_TAG)$(subst .,-,$(DOCKERFILE_VARIANT)) \
		--tag $(PUBLIC_DOCKER_REGISTRY)/$(DOCKER_PROJECT)/$*:$(IMAGE_ANCHOR_TAG)$(subst .,-,$(DOCKERFILE_VARIANT)) \
		--file $< \
		$(dir $<)
endif

base-image-%: base/%/Dockerfile$(DOCKERFILE_VARIANT) $(shell find base/$* -type f)
ifeq ($(strip $(DOCKERFILE_VARIANT)),)
	time docker build $(DOCKER_BUILD_FLAGS) \
		--tag $(PUBLIC_DOCKER_REGISTRY)/$(DOCKER_PROJECT)/$*:$(IMAGE_TAG) \
		--tag $(PUBLIC_DOCKER_REGISTRY)/$(DOCKER_PROJECT)/$*:$(IMAGE_ANCHOR_TAG) \
		--file $< \
		$(dir $<)
else
	time docker build $(DOCKER_BUILD_FLAGS) \
		--tag $(PUBLIC_DOCKER_REGISTRY)/$(DOCKER_PROJECT)/$*:$(IMAGE_TAG)$(subst .,-,$(DOCKERFILE_VARIANT)) \
		--tag $(PUBLIC_DOCKER_REGISTRY)/$(DOCKER_PROJECT)/$*:$(IMAGE_ANCHOR_TAG)$(subst .,-,$(DOCKERFILE_VARIANT)) \
		--file $< \
		$(dir $<)
endif

notebook-images: $(NOTEBOOK_TARGETS)
base-images: $(BASE_TARGETS)

list-images:
	@echo $(NOTEBOOK_TARGETS) $(BASE_TARGETS)

push-public-image-%: 
ifeq ($(strip $(DOCKERFILE_VARIANT)),)
	docker push $(PUBLIC_DOCKER_REGISTRY)/$(DOCKER_PROJECT)/$*:$(IMAGE_ANCHOR_TAG)
else
	docker push $(PUBLIC_DOCKER_REGISTRY)/$(DOCKER_PROJECT)/$*:$(IMAGE_ANCHOR_TAG)$(subst .,-,$(DOCKERFILE_VARIANT))
endif

push-notebook-images: $(PUSH_NOTEBOOK_IMAGES)
push-base-images: $(PUSH_BASE_IMAGES)