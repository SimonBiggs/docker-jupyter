FROM jupyter/jupyterhub:latest

MAINTAINER Simon Biggs <mail@simonbiggs.net>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y upgrade

RUN apt-get -y install python-numpy python3-numpy \
    python-scipy python3-scipy \
    python-matplotlib python3-matplotlib \
    python-pandas python3-pandas \
    python-sympy \
    python-nose2 python3-nose2 \
    python-mpi4py python3-mpi4py \
    cython cython3 \
    python-mako python3-mako \
    libgeos-dev gfortran
    
RUN pip3 install sympy plotly shapely

RUN pip install plotly shapely
    
RUN mkdir /root/notebooks/

WORKDIR /root/notebooks/

EXPOSE 8000

CMD jupyterhub --no-browser --ip=0.0.0.0 --port=8000
