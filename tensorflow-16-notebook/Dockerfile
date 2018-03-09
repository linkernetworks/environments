FROM jupyter/minimal-notebook

LABEL maintainer="Narumi"

# Install Tensorflow
RUN pip install -U \
        tensorflow==1.6.0 \
        keras && \
    rm -rf ~/.cache/pip
