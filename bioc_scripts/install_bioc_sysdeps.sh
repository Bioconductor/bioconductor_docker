#!/bin/bash
set -e

# This is to avoid the error
# 'debconf: unable to initialize frontend: Dialog'
export DEBIAN_FRONTEND=noninteractive

## Update apt-get
apt-get update

apt-get install -y --no-install-recommends apt-utils

## Basic Deps
apt-get install -y --no-install-recommends \
    gdb \
	libxml2-dev \
	python3-pip \
	libz-dev \
	liblzma-dev \
	libbz2-dev \
	libpng-dev \
	libgit2-dev

## sys deps from bioc_full
apt-get install -y --no-install-recommends \
	pkg-config \
	fortran77-compiler \
	byacc \
	automake \
	curl

## This section installs libraries
apt-get install -y --no-install-recommends \
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
	libpq-dev

## software - perl extentions and modules
apt-get install -y --no-install-recommends \
	libperl-dev \
	libarchive-extract-perl \
	libfile-copy-recursive-perl \
	libcgi-pm-perl \
	libdbi-perl \
	libdbd-mysql-perl \
	libxml-simple-perl \
	libmysqlclient-dev \
	default-libmysqlclient-dev \
	libgdal-dev

## new libs
apt-get install -y --no-install-recommends \
    libglpk-dev \
    libeigen3-dev

## Databases and other software
apt-get install -y --no-install-recommends \
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
	jags

## Additional resources
apt-get install -y --no-install-recommends \
	xfonts-100dpi \
	xfonts-75dpi \
	biber \
    libsbml5-dev \
    libzmq3-dev \
    python3-dev

## More additional resources
apt-get -y --no-install-recommends install \
	libmariadb-dev-compat \
	libjpeg-dev \
	libjpeg-turbo8-dev \
	libjpeg8-dev

## Python installations
pip3 install sklearn pandas pyyaml

## clean up
apt-get clean
apt-get autoremove -y
apt-get autoclean -y
rm -rf /var/lib/apt/lists/*