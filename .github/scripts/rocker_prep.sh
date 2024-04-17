#!/bin/bash
RVER=$1
BIOCVER=$2
ROCKERPREF=$3
ARCH=$4

git clone --depth 1 https://github.com/rocker-org/rocker-versioned2
sed -i "s#rocker/r-ver:$RVER#$ROCKERPREF-r-ver:$RVER-$ARCH#g" rocker-versioned2/dockerfiles/rstudio_$RVER.Dockerfile
sed -i "s#rocker/rstudio:$RVER#$ROCKERPREF-rstudio:$RVER-$ARCH#g" rocker-versioned2/dockerfiles/tidyverse_$RVER.Dockerfile
sed -i "s#install_quarto.sh#install_quarto.sh || true#g" rocker-versioned2/dockerfiles/rstudio_$RVER.Dockerfile

echo "Bioconductor Version: $BIOCVER"
if [ "$RVER" == "devel" ]; then
  bash .github/scripts/devel_or_patched_rversion.sh "$BIOCVER" "rocker-versioned2/dockerfiles/r-ver_$RVER.Dockerfile"
fi
