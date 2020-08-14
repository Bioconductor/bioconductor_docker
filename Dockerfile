# The suggested name for this image is: bioconductor/bioconductor_docker:devel
FROM rocker/rstudio:4.0.2

## Set Dockerfile version number
## This parameter should be incremented each time there is a change in the Dockerfile

ARG BIOCONDUCTOR_DOCKER_VERSION=3.12.16

LABEL name="bioconductor/bioconductor_docker" \
      version=$BIOCONDUCTOR_DOCKER_VERSION \
      url="https://github.com/Bioconductor/bioconductor_docker" \
      vendor="Bioconductor Project" \
      maintainer="maintainer@bioconductor.org" \
      description="Bioconductor docker image with system dependencies to install most packages." \
      license="Artistic-2.0"

# nuke cache dirs before installing pkgs; tip from Dirk E fixes broken img
RUN rm -f /var/lib/dpkg/available && rm -rf  /var/cache/apt/*

# issues with '/var/lib/dpkg/available' not found
# this will recreate
RUN dpkg --clear-avail

# This is to avoid the error
# 'debconf: unable to initialize frontend: Dialog'
ENV DEBIAN_FRONTEND noninteractive

# Update apt-get
RUN apt-get update \
	&& apt-get install -y --no-install-recommends apt-utils \
	&& apt-get install -y --no-install-recommends \
	## Basic deps
	gdb \
	libxml2-dev \
	python3-pip \
	libz-dev \
	liblzma-dev \
	libbz2-dev \
	libpng-dev \
	## sys deps from bioc_full
	pkg-config \
	fortran77-compiler \
	byacc \
	automake \
	curl \
	## This section installs libraries
	libpcre2-dev \
	libnetcdf-dev \
	libhdf5-serial-dev \
	libfftw3-dev \
	libopenbabel-dev \
	libopenmpi-dev \
	libxt-dev \
	libudunits2-dev \
	libgeos-dev \
	libproj-dev \
	libcairo2-dev \
	libtiff5-dev \
	libreadline-dev \
	libgsl0-dev \
	libgslcblas0 \
	libgtk2.0-dev \
	libgl1-mesa-dev \
	libglu1-mesa-dev \
	libgmp3-dev \
	libhdf5-dev \
	libncurses-dev \
	libbz2-dev \
	libxpm-dev \
	liblapack-dev \
	libv8-dev \
	libgtkmm-2.4-dev \
	libmpfr-dev \
	libmodule-build-perl \
	libapparmor-dev \
	libprotoc-dev \
	librdf0-dev \
	libmagick++-dev \
	libsasl2-dev \
	libpoppler-cpp-dev \
	libprotobuf-dev \
	libpq-dev \
	libperl-dev \
	## software - perl extentions and modules
	libarchive-extract-perl \
	libfile-copy-recursive-perl \
	libcgi-pm-perl \
	libdbi-perl \
	libdbd-mysql-perl \
	libxml-simple-perl \
	libmysqlclient-dev \
	default-libmysqlclient-dev \
	libgdal-dev \
	## new libs
	libglpk-dev \
	## Databases and other software
	sqlite \
	openmpi-bin \
	mpi-default-bin \
	openmpi-common \
	openmpi-doc \
	tcl8.6-dev \
	tk-dev \
	default-jdk \
	imagemagick \
	tabix \
	ggobi \
	graphviz \
	protobuf-compiler \
	jags \
	## Additional resources
	xfonts-100dpi \
	xfonts-75dpi \
	biber \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

## Python installations
RUN apt-get update \
	&& apt-get install -y software-properties-common \
	&& add-apt-repository universe \
	&& apt-get update \
	&& apt-get -y --no-install-recommends install python2 python-dev \
	&& curl https://bootstrap.pypa.io/get-pip.py --output get-pip.py \
	&& python2 get-pip.py \
	&& pip2 install wheel \
	## Install sklearn and pandas on python
	&& pip2 install sklearn \
	pandas \
	pyyaml \
	cwltool \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf get-pip.py

## FIXME
## These two libraries don't install in the above section--WHY?
RUN apt-get update \
	&& apt-get -y --no-install-recommends install \
	libmariadb-dev-compat \
	libjpeg-dev \
	libjpeg-turbo8-dev \
	libjpeg8-dev \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# # Install libsbml and xvfb
RUN cd /tmp \
	## libsbml
	&& curl -O https://s3.amazonaws.com/linux-provisioning/libSBML-5.10.2-core-src.tar.gz \
	&& tar zxf libSBML-5.10.2-core-src.tar.gz \
	&& cd libsbml-5.10.2 \
	&& ./configure --enable-layout \
	&& make \
	&& make install \
	## Clean libsbml, and tar.gz files
	&& rm -rf /tmp/libsbml-5.10.2 \
	&& rm -rf /tmp/libSBML-5.10.2-core-src.tar.gz \
	## apt-get clean and remove cache
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

RUN echo "R_LIBS=/usr/local/lib/R/host-site-library:\${R_LIBS}" > /usr/local/lib/R/etc/Renviron.site \
	&& echo "options(defaultPackages=c(getOption('defaultPackages'),'BiocManager'))" >> /usr/local/lib/R/etc/Rprofile.site

ADD install.R /tmp/

RUN R -f /tmp/install.R

# DEVEL: Add sys env variables to DEVEL image
RUN curl -O http://bioconductor.org/checkResults/devel/bioc-LATEST/Renviron.bioc \
	&& cat Renviron.bioc | grep -o '^[^#]*' | sed 's/export //g' >>/etc/environment \
	&& cat Renviron.bioc >> /usr/local/lib/R/etc/Renviron.site \
	&& echo BIOCONDUCTOR_DOCKER_VERSION=${BIOCONDUCTOR_DOCKER_VERSION} >> /usr/local/lib/R/etc/Renviron.site \
	&& rm -rf Renviron.bioc

ENV BIOCONDUCTOR_DOCKER_VERSION=$BIOCONDUCTOR_DOCKER_VERSION

# Init command for s6-overlay
CMD ["/init"]
