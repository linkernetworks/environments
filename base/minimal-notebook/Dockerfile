# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

FROM jupyter/base-notebook

LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"

USER root

# Install all OS dependencies for fully functional notebook server
RUN apt-get update && apt-get install -yq --no-install-recommends \
    build-essential \
    git \
    unzip \
    vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV HOME=/

RUN pip install pip==9.0.3 \
    && pip install -U h5py \
    && rm -rf ~/.cache/pip

# Install aiforge command line tool for all base images.
RUN wget https://raw.githubusercontent.com/linkernetworks/aiforge/master/install.sh -O - | bash
