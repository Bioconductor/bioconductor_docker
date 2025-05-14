#!/bin/bash
set -e

# This script needs to be separated from the Dockerfile because we mount persistent disks in the
# /home/rstudio directory and when we mount the PD, everything in that directory gets wiped.
# Therefore, we will run this script from Leonardo after the PD is mounted

RSTUDIO_USER_HOME=/home/rstudio

# Because of how R_PATH is run '/root' is being added as the base dir name for this R_PATH.
# This chunk of code checks to see if root is coming from this location and replaces it
# with a blank space.
R_PATH=`Rscript -e "cat(Sys.getenv('R_LIBS_USER'))"`
CHECK_ROOT='/root'
if [[ "$R_PATH" == *"$CHECK_ROOT"* ]]; then
    R_PATH="${R_PATH/\/root\//}"
fi

BIOCONDUCTOR_VERSION=`printenv BIOCONDUCTOR_DOCKER_VERSION | sed 's/\(^[0-9].[0-9][0-9]\).*/\1/g'`
R_PACKAGE_DIR=${RSTUDIO_USER_HOME}/${R_PATH}-${BIOCONDUCTOR_VERSION}

# The sudo command to make the directory here confirms it's running as root.
sudo -E -u rstudio mkdir -p ${R_PACKAGE_DIR}

echo R_LIBS=${R_PACKAGE_DIR} >> /usr/local/lib/R/etc/Renviron.site
