FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
# --------------------------------------------------------------------------
# Set the locale
# --------------------------------------------------------------------------
# Note:
#   locale - RStudio and possibly other apps complains about not having set
#            up the language locales
RUN apt-get install -y locales 
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# --------------------------------------------------------------------------
# General purpose tools
# --------------------------------------------------------------------------
# Notes:
#   software-properties-common - contains add-apt-repository
#   apt-transport-https - required while updating packages to achieve CRAN
#   gdebi-core - required to install rstudio (manages dependencies)
# --------------------------------------------------------------------------
RUN apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y --no-install-recommends  \
    software-properties-common \
    apt-transport-https \
    wget \
    unzip \
    gdebi-core \
    git


# --------------------------------------------------------------------------
# R-Base and RStudio-Desktop Setup
# --------------------------------------------------------------------------
# Notes:
#   libxslt1-dev - RStudio does not launch without it
#   dbus - absence generates warning while launching RStudio
#   QT_XKB_CONFIG_ROOT - if not set keyboard does not work
ARG RSTUDIO_VERSION=xenial-1.1.453
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
RUN add-apt-repository 'deb https://ftp.ussg.iu.edu/CRAN/bin/linux/ubuntu xenial/'
RUN apt-get update    
RUN apt-get install -y r-base r-base-dev libxslt1-dev dbus
RUN wget https://download1.rstudio.org/rstudio-$RSTUDIO_VERSION-amd64.deb
RUN gdebi --non-interactive rstudio-$RSTUDIO_VERSION-amd64.deb
RUN rm rstudio-$RSTUDIO_VERSION-amd64.deb
ENV QT_XKB_CONFIG_ROOT /usr/share/X11/xkb


# --------------------------------------------------------------------------
# Jupyter Setup
# --------------------------------------------------------------------------
# Notes:
#   libcanberra-gtk3-module - Avoid firefox launch error "Failed to load 
#     module canberra-gtk-module"
#   dbus-x11 - Avoid firefox launch error "Unable to get session bus...
#     failed... dbus-launch"
#   python-virtualenv - Pre-requisite of Tensorflow while installing Keras
RUN apt-get install -y \
    firefox \
    libcanberra-gtk3-module \
    dbus-x11 \
    python-pip \
    python-dev \
    python-virtualenv \
    ipython \
    ipython-notebook
RUN pip install jupyter
# Adding a R Kernel to Jupyter
RUN apt-get -y install libcurl4-gnutls-dev libssl-dev
RUN Rscript -e "install.packages('devtools')"
RUN Rscript -e "devtools::install_github('IRkernel/IRkernel')"
RUN Rscript -e "IRkernel::installspec(user = FALSE)"
# Adding Keras R Interface
RUN Rscript -e "devtools::install_github('rstudio/keras')"
RUN Rscript -e "library(keras)" -e "install_keras()"
# Adding other CRAN Packages
#   Soft Computing
#RUN Rscript -e "install.packages('RoughtSets')"
RUN Rscript -e "install.packages('anfis')"
RUN Rscript -e "install.packages('sets')"
RUN Rscript -e "install.packages('GA')"

# --------------------------------------------------------------------------
# Cleaning up
# --------------------------------------------------------------------------
RUN apt-get autoremove -y
RUN apt-get autoclean
RUN rm -rf /var/lib/apt/lists/*


# --------------------------------------------------------------------------
# nvidia-docker hooks
# --------------------------------------------------------------------------
LABEL com.nvidia.volumes.needed="nvidia_driver"
ENV PATH /usr/local/nvidia/bin:${PATH} 
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}

ENTRYPOINT [ "/bin/bash" ]