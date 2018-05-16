FROM linkernetworks/minimal-notebook:master

LABEL maintainer="Narumi"

# Install OpenCV and dlib
RUN conda install --quiet --yes \
    dlib \
    opencv \
    && conda clean -tipsy \
    && fix-permissions $CONDA_DIR

# Install PyTorch
RUN conda install --quiet --yes -c pytorch \
    pytorch-cpu==0.4.0 \
    torchvision==0.2.0 \
    && conda clean -tipsy \
    && fix-permissions $CONDA_DIR

RUN conda install --quiet --yes \
    caffe \
    python-lmdb && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR

RUN pip install -U pip==9.0.3 \
    && pip install -U \
    beautifulsoup4 \
    bokeh \
    bson \
    cython \
    docker \
    flask_restful \
    h5py \
    keras \
    matplotlib \
    nltk \
    numpy \
    orderedset \
    pandas \ 
    Pillow \ 
    psutil \
    pymongo \
    requests \
    scikit-image \
    scikit-learn \
    tensorflow \
    && pip install -U \
    "git+https://github.com/ahundt/cocoapi.git#egg=pycocotools&subdirectory=PythonAPI" \
    "git+https://github.com/thtrieu/darkflow.git#egg=darkflow" \
    && rm -rf ~/.cache/pip
