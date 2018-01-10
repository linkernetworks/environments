FROM jupyter/minimal-notebook

LABEL maintainer="Narumi <weaper@gmail.com>"

USER root

RUN conda install --quiet --yes -c pytorch pytorch \
                                           torchvision &&\
    conda clean -tipsy

USER $NB_USER