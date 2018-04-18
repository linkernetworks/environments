FROM linkernetworks/minimal-notebook:master

LABEL maintainer="Narumi"

# Install Tensorflow
RUN pip install \
    tensorflow==1.3.0 \
    keras \
    h5py \
    && rm -rf ~/.cache/pip