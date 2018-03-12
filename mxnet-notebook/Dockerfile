FROM jupyter/minimal-notebook

LABEL maintainer="Narumi"

# Install graphviz
USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends graphviz && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER $NB_USER

# Install MXNet and graphviz
RUN pip install -U mxnet==1.1.0 \
                   graphviz && \
    rm -rf ~/.cache/pip
