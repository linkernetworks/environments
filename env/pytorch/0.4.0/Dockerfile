ARG BASE_IMAGE=linkernetworks/minimal-notebook:master
FROM $BASE_IMAGE

LABEL maintainer="Narumi"

# Install PyTorch
RUN conda install --quiet --yes -c pytorch \
    pytorch-cpu==0.4.0 \
    torchvision==0.2.0 \
    && conda clean -tipsy \
    && fix-permissions $CONDA_DIR

ARG CACHE_DATE
ARG SUBMIT_TOOL_NAME=aurora
RUN wget https://raw.githubusercontent.com/linkernetworks/aurora/master/install.sh -O - | bash \
    && if [ "$SUBMIT_TOOL_NAME" != "aurora" ]; then mv /usr/local/bin/aurora /usr/local/bin/$SUBMIT_TOOL_NAME; fi
