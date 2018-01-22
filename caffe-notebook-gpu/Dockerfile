FROM linkernetworks/gpu-notebook
USER root
RUN conda install --quiet --yes -c anaconda caffe && \
    conda install --quiet --yes -c python-lmdb && \
    conda clean -tipsy
USER $NB_USER
