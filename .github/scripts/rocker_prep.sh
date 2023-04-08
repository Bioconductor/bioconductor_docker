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
if [ "$RVER" = "devel" ];
then
  if [ $((BIOC_MINOR%2)) -eq 0 ];
  then
      echo "Using latest release R since Bioc devel version is even";
      sed -i "s#R_VERSION=$RVER#R_VERSION=latest#g" rocker-versioned2/dockerfiles/r-ver_$RVER.Dockerfile
  else
      echo "Using latest pre-release R since Bioc devel version is even";
      sed -i "s#R_VERSION=$RVER#R_VERSION=patched#g" rocker-versioned2/dockerfiles/r-ver_$RVER.Dockerfile
  fi
fi
