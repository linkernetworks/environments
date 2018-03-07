FROM jupyter/minimal-notebook

LABEL maintainer="Narumi"

# Install Tensorflow
RUN pip install -U \
        tensorflow==1.5.0 \
        keras==2.1.4 && \
    rm -rf ~/.cache/pip
