FROM linkernetworks/minimal-notebook:master

LABEL maintainer="Narumi"

# Install Tensorflow
RUN pip install -U \
    tensorflow==1.8.0 \
    keras \
    && rm -rf ~/.cache/pip

ARG CACHE_DATE
RUN wget https://raw.githubusercontent.com/linkernetworks/aurora/master/install.sh -O - | bash
