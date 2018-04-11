FROM linkernetworks/minimal-notebook:master

LABEL maintainer="Narumi"

# Install Tensorflow
RUN conda install --quiet --yes -c anaconda \
    'tensorflow=1.3' \
    'keras=2.1.3' && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR
