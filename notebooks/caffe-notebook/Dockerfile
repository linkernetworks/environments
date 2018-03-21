FROM jupyter/minimal-notebook
LABEL maintainer="chrisjan"
RUN conda install --quiet --yes -c anaconda \
        caffe \
        python-lmdb && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR
