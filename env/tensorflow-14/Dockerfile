FROM linkernetworks/minimal-notebook:master

LABEL maintainer="Narumi"

# Install Tensorflow
RUN pip install \
    tensorflow==1.4.1 \
    keras \
    h5py \
    && rm -rf ~/.cache/pip
