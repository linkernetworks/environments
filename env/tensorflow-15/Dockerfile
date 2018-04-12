FROM linkernetworks/minimal-notebook:master

LABEL maintainer="Narumi"

# Install Tensorflow
RUN pip install -U \
    tensorflow==1.5.1 \
    keras && \
    rm -rf ~/.cache/pip
