FROM linkernetworks/gpu-notebook

LABEL maintainer="Narumi"

# Install Tensorflow
RUN conda install --quiet --yes -c anaconda \
        'tensorflow-gpu=1.4.1' \
        'keras=2.1.3' && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR