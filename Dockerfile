FROM nvidia/cuda:11.6.2-cudnn8-devel-ubuntu20.04

# Set bash as default shell
ENV SHELL=/bin/bash

# Create a working directory
WORKDIR /workspace/

# Build with some basic utilities
RUN apt-get update && apt-get install -y \
    python3-pip \
    apt-utils \
    git wget

# alias python='python3'
RUN ln -s /usr/bin/python3 /usr/bin/python

RUN pip install \
    numpy \
    torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu116 \
    jupyterlab ipywidgets jupyter-archive 

RUN jupyter nbextension enable --py widgetsnbextension

# copy will almost always invalid the cache
COPY . /discoart/

COPY .docker/models/* /models/

RUN cd /discoart && pip install --compile .

COPY notebooks/*

# Support for single volume containers
ADD docker/start.sh /start.sh

CMD [ "/start.sh" ]
EXPOSE 8888