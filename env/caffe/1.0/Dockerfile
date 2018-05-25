FROM linkernetworks/minimal-notebook:master
LABEL maintainer="chrisjan"
RUN conda install --quiet --yes -c anaconda \
    caffe \
    python-lmdb && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR

# Disable cache for the following instructions
# When build, use docker build --build-arg CACHE_DATE="$(date)"
ARG CACHE_DATE
ARG SUBMIT_TOOL_NAME=aurora
RUN wget https://raw.githubusercontent.com/linkernetworks/aurora/master/install.sh -O - | bash \
    && mv /usr/local/bin/aurora /usr/local/bin/$SUBMIT_TOOL_NAME
