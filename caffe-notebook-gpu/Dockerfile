FROM linkernetworks/gpu-notebook
LABEL maintainer="chrisjan"
USER root
RUN conda install --quiet --yes -c anaconda caffe && \
    conda install --quiet --yes -c anaconda python-lmdb && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR
