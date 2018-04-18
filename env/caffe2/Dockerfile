FROM linkernetworks/minimal-notebook:master

RUN conda install --quiet --yes -c caffe2 \
    caffe2==0.8.dev \
    && conda clean -tipsy \
    && fix-permissions $CONDA_DIR
