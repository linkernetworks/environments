FROM linkernetworks/minimal-notebook:master

# Install Chainer
RUN pip install -U \
    chainer==3.5.0 \
    && rm -rf ~/.cache/pip

ARG CACHE_DATE
ARG SUBMIT_TOOL_NAME=aurora
RUN wget https://raw.githubusercontent.com/linkernetworks/aurora/master/install.sh -O - | bash \
    && move /usr/local/bin/aiforge $SUBMIT_TOOL_NAME