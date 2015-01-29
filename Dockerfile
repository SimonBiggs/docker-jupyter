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
    
RUN pip3 install sympy plotly shapely mpld3

RUN pip install plotly shapely mpld3

RUN useradd -d /home/admin -m admin; \
    echo -e "admin\nadmin" | (passwd --stdin admin); \
    adduser admin sudo

RUN echo '''#/bin/bash
            jupyterhub -f /srv/jupyterhub/jupyterhub_config.py &
            su admin
            /bin/bash''' > /srv/jupyterhub/start_script.sh; \
            chmod +x /srv/jupyterhub/start_script.sh

WORKDIR /home/admin/

CMD /srv/jupyterhub/start_script.sh
