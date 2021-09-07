#!/bin/bash

set -e

# Set variables
version="20.04"
repo="https://github.com/Bioconductor/BBS"
branch="master"
bbs="/tmp/BBS/Ubuntu-files/$version"
bioconductor_docker="/tmp/$version"
bbs_apt_files="apt_required_compile_R.txt apt_required_build.txt apt_bioc.txt apt_cran.txt"
bbs_pip_files="pip_pkgs.txt pip_spb.txt"

# Get repository with Ubuntu-files
if [ ! -d "/tmp/BBS" ]; then
  git clone -b $branch --depth 1 $repo /tmp/BBS 
fi

cd $bbs

# Write a sorted list of BBS apt packages, skipping any commented lines.
cat $bbs_apt_files | awk '/^[^#]/ {print $1}' | sort >> /tmp/bbs_apt_pkgs 
# Write a sorted list of apt packages to remove from the install list,
# excluding any commented lines.
cat $bioconductor_docker/apt_skip.txt | awk '/^[^#]/ {print $1}' | sort >> /tmp/skip_apt_pkgs
# Write a file listing the apt packages to install, removing all packages
# in skip_apt_pkgs.
comm -23 /tmp/bbs_apt_pkgs /tmp/skip_apt_pkgs >> /tmp/install_apt_pkgs

# Write a file with pip packages to install.
cat $bbs_pip_files | awk '/^[^#]/ {print $1}' | sort >> /tmp/bbs_pip_pkgs
cat $bioconductor_docker/pip_skip.txt | awk '/^[^#]/ {print $1}' | sort >> /tmp/skip_pip_pkgs
comm -23 /tmp/bbs_pip_pkgs /tmp/skip_pip_pkgs >> /tmp/install_pip_pkgs

cd ~

# Packages always required by Bioconductor Docker
cat $bioconductor_docker/apt_required.txt | awk '/^[^#]/ {print $1}' >> /tmp/install_apt_pkgs
apt_pkgs=$(cat /tmp/install_apt_pkgs)
pip_pkgs=$(cat /tmp/install_pip_pkgs)

# Install dependencies

# Install apt packages
apt-get update \
  && apt-get install -y --no-install-recommends apt-utils

apt-get install -y --no-install-recommends $apt_pkgs \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install pip packages
pip3 install $pip_pkgs
rm -rf ~/.cache/pip

# Remove files
if test -n "$(find /tmp -maxdepth 1 -name '*_pkgs' -print -quit)"; then
  cd /tmp
  rm bbs_apt_files bbs_pip_files
  rm -rf BBS
  cd
fi
