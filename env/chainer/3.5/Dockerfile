FROM linkernetworks/minimal-notebook:master

# Install Chainer
RUN pip install -U \
    chainer==3.5.0 \
    && rm -rf ~/.cache/pip

ARG CACHE_DATE
RUN wget https://raw.githubusercontent.com/linkernetworks/aurora/master/install.sh -O - | bash
