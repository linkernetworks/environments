FROM linkernetworks/minimal-notebook:master

LABEL maintainer="Narumi"

# Install Tensorflow
RUN pip install \
    tensorflow==1.4.1 \
    keras \
    && rm -rf ~/.cache/pip
