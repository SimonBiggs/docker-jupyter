FROM jupyter/jupyterhub:latest

MAINTAINER Simon Biggs <mail@simonbiggs.net>


ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y upgrade


# Python 2 and 3 SciPy stack and more
RUN apt-get -y install \
    python-mpi4py python3-mpi4py \
    cython cython3 \
    python-mako python3-mako \
    libgeos-dev gfortran
    
RUN apt-get -y build-dep \
    python-numpy python-scipy \
    python-matplotlib python-pandas \
    python-sympy python-nose2
    
RUN pip install \
    numpy scipy matplotlib pandas sympy nose2 \
    plotly shapely mpld3 terminado --upgrade

RUN pip3 install \
    numpy scipy matplotlib pandas sympy nose2 \
    plotly shapely mpld3 terminado --upgrade

# Julia installation
RUN apt-get install software-properties-common python-software-properties -y && \
    add-apt-repository ppa:staticfloat/juliareleases && \
    add-apt-repository ppa:staticfloat/julia-deps && \
    apt-get update && \
    apt-get install julia -y && \
    apt-get install libnettle4
    
RUN julia -e 'Pkg.add("IJulia")'
RUN julia -e 'Pkg.add("Gadfly")'
RUN julia -e 'Pkg.add("RDatasets")'
    
# R installation
RUN apt-get install -y r-base r-base-dev r-cran-rcurl libreadline-dev
RUN pip2 install rpy2 && pip3 install rpy2
RUN echo 'options(repos=structure(c(CRAN="http://cran.rstudio.com")))' > ~/.Rprofile
RUN mkdir -p ~/.R; echo "PKG_CXXFLAGS = '-std=c++11'" > ~/.R/Makevars
RUN echo "install.packages(c('ggplot2', 'XML', 'plyr', 'randomForest', 'Hmisc', 'stringr', 'RColorBrewer', 'reshape', 'reshape2'))" | R --no-save
RUN echo "install.packages(c('RCurl', 'devtools', 'dplyr'))" | R --no-save
RUN echo "library(devtools); install_github('rgbkrk/rzmq'); install_github('takluyver/IRdisplay'); install_github('takluyver/IRkernel'); IRkernel::installspec()" | R --no-save

# Add default user
RUN useradd -d /home/admin -m admin; \
    echo "admin:admin" | chpasswd; \
    adduser admin sudo

# Start jupyterhub on boot
CMD jupyterhub -f /srv/jupyterhub/jupyterhub_config.py
