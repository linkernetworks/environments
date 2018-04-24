FROM jupyter/base-notebook

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    vim \
    && rm -rf /var/lib/apt/lists/*

ENV HOME=/

RUN pip install pip==9.0.3 \
    && pip install -U h5py \
    && rm -rf ~/.cache/pip

# Install aiforge command line tool for all base images.
RUN wget https://raw.githubusercontent.com/linkernetworks/aiforge/master/install.sh -O - | bash