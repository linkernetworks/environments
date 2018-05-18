# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

FROM linkernetworks/base-notebook:master

LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"

USER root

# Install all OS dependencies for fully functional notebook server
RUN apt-get update && apt-get install -yq --no-install-recommends \
    build-essential \
    emacs \
    git \
    inkscape \
    jed \
    libsm6 \
    libxext-dev \
    libxrender1 \
    lmodern \
    netcat \
    pandoc \
    python-dev \
    texlive-fonts-extra \
    texlive-fonts-recommended \
    texlive-generic-recommended \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-xetex \
    unzip \
    vim \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV HOME=/

RUN conda update --yes -n base conda \
    && conda clean -tipsy \
    && fix-permissions $CONDA_DIR

RUN pip install pip==9.0.3 \
    && pip install -U h5py \
    && pip install ipywidgets \
    && jupyter nbextension enable --sys-prefix --py widgetsnbextension \
    && rm -rf ~/.cache/pip

# Disable cache for the following instructions
# When build, use docker build --build-arg CACHE_DATE="$(date)"
ARG CACHE_DATE
# Install aiforge command line tool for all base images.
RUN wget https://raw.githubusercontent.com/linkernetworks/aiforge/master/install.sh -O - | bash

WORKDIR /workspace
