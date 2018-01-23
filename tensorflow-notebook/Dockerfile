FROM jupyter/minimal-notebook

LABEL maintainer="Narumi <weaper@gmail.com>"

# Install Tensorflow
RUN conda install --quiet --yes -c anaconda \
        'tensorflow=1.4.1' \
        'keras=2.1.3' && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR
