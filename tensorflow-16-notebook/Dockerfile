FROM jupyter/minimal-notebook

LABEL maintainer="Narumi"

# Install Tensorflow
RUN pip3 install -U \
        tensorflow==1.6.0 \
        keras && \
    rm -rf ~/.cache/pip
