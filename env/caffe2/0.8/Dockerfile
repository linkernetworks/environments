FROM linkernetworks/minimal-notebook:master

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    libgflags-dev \
    libgoogle-glog-dev \
    libgtest-dev \
    libiomp-dev \
    libleveldb-dev \
    liblmdb-dev \
    libopencv-dev \
    libopenmpi-dev \
    libprotobuf-dev \
    libsnappy-dev \
    openmpi-bin \
    openmpi-doc \
    protobuf-compiler \
    && rm -rf /var/lib/apt/lists/*

RUN conda install --quiet --yes \
    future numpy protobuf \
    && conda clean -tipsy \ 
    && fix-permissions $CONDA_DIR

RUN git clone https://github.com/pytorch/pytorch.git /tmp/pytorch \
    && (cd /tmp/pytorch \
    && git checkout v0.4.0 \
    && git submodule update --init \
    && python setup_caffe2.py install) \
    && rm -rf /tmp/*

ARG CACHE_DATE
ARG SUBMIT_TOOL_NAME=aurora
RUN wget https://raw.githubusercontent.com/linkernetworks/aurora/master/install.sh -O - | bash \
    && mv /usr/local/bin/aurora /usr/local/bin/$SUBMIT_TOOL_NAME
