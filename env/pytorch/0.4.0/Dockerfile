FROM linkernetworks/minimal-notebook:master

LABEL maintainer="Narumi"

# Install PyTorch
RUN conda install --quiet --yes -c pytorch \
    pytorch-cpu==0.4.0 \
    torchvision==0.2.0 \
    && conda clean -tipsy \
    && fix-permissions $CONDA_DIR

ARG CACHE_DATE
RUN wget https://raw.githubusercontent.com/linkernetworks/aurora/master/install.sh -O - | bash
