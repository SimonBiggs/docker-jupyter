FROM jupyter/jupyterhub:latest

MAINTAINER Simon Biggs <mail@simonbiggs.net>


ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y upgrade


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
    

RUN apt-get -y install julia; \
    julia -e 'Pkg.update()'; \
    julia -e 'Pkg.add("IJulia")'
    

RUN apt-get -y install r-base-dev

RUN echo 'r <- getOption("repos")' > ~/.Rprofile; \
    echo 'r["CRAN"] <- "http://cran.us.r-project.org"' >> ~/.Rprofile; \
    echo 'options(repos = r)' >> ~/.Rprofile; \
    echo 'rm(r)' >> ~/.Rprofile
    
RUN mkdir -p ~/.R; echo "PKG_CXXFLAGS = '-std=c++11'" > ~/.R/Makevars

RUN cd ~;\
    R -e 'install.packages("RCurl")';\
    R -e 'install.packages("devtools")'

RUN echo -e "library(devtools)\ninstall_github('armstrtw/rzmq')\ninstall_github('takluyver/IRdisplay')\ninstall_github('takluyver/IRkernel')\nIRkernel::installspec()\nquit()" > ~/.install_IRkernel 

RUN cd ~;\
    R -f ~/.install_IRkernel
  
    
RUN useradd -d /home/admin -m admin; \
    echo "admin:admin" | chpasswd; \
    adduser admin sudo

CMD jupyterhub -f /srv/jupyterhub/jupyterhub_config.py
