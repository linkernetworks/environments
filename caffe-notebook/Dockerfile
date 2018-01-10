FROM ubuntu:16.04
MAINTAINER chrisjan
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        cmake \
        wget \
        git \
        libatlas-base-dev \
        libboost-all-dev \
        libgflags-dev \
        libgoogle-glog-dev \
        libhdf5-serial-dev \
        libleveldb-dev \
        liblmdb-dev \
        libopencv-dev \
        libsnappy-dev \
        pkg-config \
        python3 \
        python3-dev \
        python3-pip \
        python3-setuptools \
        software-properties-common \
        zip \
        unzip \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN pip3 --no-cache-dir install --upgrade pip && \
    pip3 --no-cache-dir install numpy scipy Pillow h5py jupyter matplotlib lmdb
RUN apt-get update -qq && apt-get install -qqy protobuf-compiler libprotobuf-dev
ENV CAFFE_ROOT=/opt/caffe
WORKDIR $CAFFE_ROOT
RUN git clone -b 1.0 https://github.com/BVLC/caffe.git . && \
    cd python && pip3 install -r requirements.txt && cd .. && \
    mkdir build && cd build && \
    cmake -DCPU_ONLY=1 -Dpython_version=3 .. && \
    make -j"$(nproc)"
ENV PYCAFFE_ROOT $CAFFE_ROOT/python
ENV PYTHONPATH $PYCAFFE_ROOT:$PYTHONPATH
ENV PATH $CAFFE_ROOT/build/tools:$PYCAFFE_ROOT:$PATH
RUN echo "$CAFFE_ROOT/build/lib" >> /etc/ld.so.conf.d/caffe.conf && ldconfig
RUN pip3 --no-cache-dir install --upgrade python-dateutil
RUN mkdir /batch
WORKDIR /batch
COPY start-notebook.sh /usr/local/bin/
CMD ["start-notebook.sh"]
