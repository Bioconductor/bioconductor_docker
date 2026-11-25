#!/bin/bash
RVER=$1
BIOCVER=$2
ROCKERPREF=$3
ARCH=$4

git clone --depth 1 https://github.com/rocker-org/rocker-versioned2
sed -i "s#rocker/r-ver:$RVER#$ROCKERPREF-r-ver:$RVER-$ARCH#g" rocker-versioned2/dockerfiles/rstudio_$RVER.Dockerfile
sed -i "s#rocker/rstudio:$RVER#$ROCKERPREF-rstudio:$RVER-$ARCH#g" rocker-versioned2/dockerfiles/tidyverse_$RVER.Dockerfile
sed -i "s#RUN /rocker_scripts/install_quarto.sh#RUN /rocker_scripts/install_quarto.sh || true#g" rocker-versioned2/dockerfiles/rstudio_$RVER.Dockerfile
# Get latest version of rstudio to use
source /etc/os-release
LATEST_RSTUDIO_VERSION=$(curl https://dailies.rstudio.com/rstudio/latest/index.json | grep -A300 '"server"' | grep -A15 '"noble-amd64"' | grep '"version"' | sed -n 's/.*: "\(.*\)".*/\1/p' | head -1)
sed -i "/^ENV RSTUDIO_VERSION=/c\ENV RSTUDIO_VERSION=\"$LATEST_RSTUDIO_VERSION\"" rocker-versioned2/dockerfiles/rstudio_devel.Dockerfile
# CRAN publishes the patched pre-release as R-patched.tar.gz; rocker still requests R-latest.tar.gz (404)
sed -i "s#base-prerelease/R-latest.tar.gz#base-prerelease/R-patched.tar.gz#g" rocker-versioned2/scripts/install_R_source.sh
# fs >= 2.1.0 (dependency of shiny/rmarkdown) needs system libuv headers
sed -i "s#^    libxt-dev \\\\#    libxt-dev \\\\\n    libuv1-dev \\\\#" rocker-versioned2/scripts/install_shiny_server.sh

echo "Bioconductor Version: $BIOCVER"
if [ "$RVER" == "devel" ]; then
  bash .github/scripts/devel_or_patched_rversion.sh "$BIOCVER" "rocker-versioned2/dockerfiles/r-ver_$RVER.Dockerfile"
  bash .github/scripts/devel_or_patched_rversion.sh "$BIOCVER" "rocker-versioned2/dockerfiles/rstudio_$RVER.Dockerfile"
  bash .github/scripts/devel_or_patched_rversion.sh "$BIOCVER" "rocker-versioned2/dockerfiles/tidyverse_$RVER.Dockerfile"
  bash .github/scripts/devel_or_patched_rversion.sh "$BIOCVER" "rocker-versioned2/dockerfiles/shiny_$RVER.Dockerfile"
fi
