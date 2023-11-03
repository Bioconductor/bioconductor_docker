#!/bin/bash
RVER=$1
BIOCVER=$2
ROCKERPREF=$3
ARCH=$4

git clone --depth 1 https://github.com/rocker-org/rocker-versioned2
sed -i "s#rocker/r-ver:$RVER#$ROCKERPREF-r-ver:$RVER-$ARCH#g" rocker-versioned2/dockerfiles/rstudio_$RVER.Dockerfile
sed -i "s#rocker/rstudio:$RVER#$ROCKERPREF-rstudio:$RVER-$ARCH#g" rocker-versioned2/dockerfiles/tidyverse_$RVER.Dockerfile
sed -i "s#install_quarto.sh#install_quarto.sh || true#g" rocker-versioned2/dockerfiles/rstudio_$RVER.Dockerfile

BIOC_MINOR=$(echo "$BIOCVER" | awk -F'.' '{print $NF}')
echo "Bioconductor Version: $BIOCVER"
if [ "$BIOCVER" = "devel" ]; then
    DEVEL_R_VER=$(curl https://bioconductor.org/config.yaml | grep '"$BIOCVER":' | awk '{print $2}' | sed 's/"//g')
    REL_VER=$(curl https://cran.r-project.org/src/base/VERSION-INFO.dcf | grep "$DEVEL_R_VER" | awk -F':' '{print $1}')
    # if the matching version is under release rather than devel, use patched pre-release rather than devel pre-release
    if [ "$REL_VER" == "Release" ]; then 
        sed -i 's#R_VERSION=$BIOCVER#R_VERSION=patched#g' rocker-versioned2/dockerfiles/r-ver_$BIOCVER.Dockerfile
    fi
fi
