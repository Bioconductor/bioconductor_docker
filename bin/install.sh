#!/bin/bash

set -e

# Set variables
version="20.04"
repo="https://github.com/Bioconductor/bbs"
branch="master"
bbs_files="/tmp/BBS/Ubuntu-files/$version"
bd_files="/tmp/$version"

# Get repository with Ubuntu-files
if [ ! -d "/tmp/BBS" ]; then
  git clone $repo /tmp/BBS 
  cd /tmp/BBS
  if [ $branch != "master" ]; then
    git fetch origin $branch
    git switch $branch
  fi
  cd ~
fi

# Constructing array of apt packages, removing unnecessary packages.
cat $bbs_files/apt_*.txt | awk '/^[^#]/ {print $1}' | sort >> /tmp/bbs_apt_pkgs 
cat $bd_files/apt_*.txt | awk '/^[^#]/ {print $1}' | sort >> /tmp/skip_apt_pkgs
apt_pkgs=$(comm -23 /tmp/bbs_apt_pkgs /tmp/skip_apt_pkgs)

# Constructing array of pip packages, removing unnecessary packages.
cat $bbs_files/pip_*.txt | awk '/^[^#]/ {print $1}' | sort >> /tmp/bbs_pip_pkgs
cat $bd_files/pip_*.txt | awk '/^[^#]/ {print $1}' | sort >> /tmp/skip_pip_pkgs
pip_pkgs=$(comm -23 /tmp/bbs_pip_pkgs /tmp/skip_pip_pkgs)

# Packages always required by Bioconductor Docker
apt_required_pkgs=$(cat $bd_files/apt_required.txt | awk '/^[^#]/ {print $1}')

# Install dependencies

# Install apt packages
apt-get update \
  && apt-get install -y --no-install-recommends apt-utils

apt-get update \
  && apt-get install -y --no-install-recommends $apt_pkgs

apt-get update \
  && apt-get install -y --no-install-recommends $apt_required_pkgs \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install pip packages
pip3 install $pip_pkgs

# Remove files
if test -n "$(find /tmp -maxdepth 1 -name '*_pkgs' -print -quit)"; then
  rm /tmp/*_pkgs
fi
