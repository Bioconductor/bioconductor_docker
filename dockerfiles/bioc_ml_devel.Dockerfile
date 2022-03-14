# The suggested name for this image is: bioconductor/bioconductor_docker:devel
FROM rocker/ml:devel

## Set Dockerfile version number
ARG BIOCONDUCTOR_VERSION=3.15

##### IMPORTANT ########
## The PATCH version number should be incremented each time
## there is a change in the Dockerfile.
ARG BIOCONDUCTOR_PATCH=0

ARG BIOCONDUCTOR_DOCKER_VERSION=${BIOCONDUCTOR_VERSION}.${BIOCONDUCTOR_PATCH}

LABEL name="bioconductor/bioconductor_docker" \
      version=$BIOCONDUCTOR_DOCKER_VERSION \
      url="https://github.com/Bioconductor/bioconductor_docker" \
      vendor="Bioconductor Project" \
      maintainer="maintainer@bioconductor.org" \
      description="Bioconductor docker image with system dependencies to install all packages." \
      license="Artistic-2.0"

##  Add Bioconductor Requirements
ADD bioc_scripts /tmp/bioc_scripts
# ADD bioc_scripts/install_bioc_sysdeps.sh /tmp/
# ADD bioc_scripts/install.R /tmp/
# ADD bioc_scripts/add_bioc_devel_env_variables.sh /tmp/

## Add host-site-library
RUN echo "R_LIBS=/usr/local/lib/R/host-site-library:\${R_LIBS}" > /usr/local/lib/R/etc/Renviron.site \
    && echo "BIOCONDUCTOR_VERSION=${BIOCONDUCTOR_VERSION}" >> /usr/local/lib/R/etc/Renviron.site \
    && echo "BIOCONDUCTOR_DOCKER_VERSION=${BIOCONDUCTOR_DOCKER_VERSION}" >> /usr/local/lib/R/etc/Renviron.site

# 1. Install Bioconductor system depdencies
RUN bash /tmp/bioc_scripts/install_bioc_sysdeps.sh

# 2. Install specific version of BiocManager and libraries
# RUN R -f /tmp/bioc_scripts/install.R

# 3. DEVEL: Add sys env variables to DEVEL image
RUN bash /tmp/bioc_scripts/add_bioc_devel_env_variables.sh

# Add Env variables for specific packages
ENV LIBSBML_CFLAGS="-I/usr/include"
ENV LIBSBML_LIBS="-lsbml"
ENV BIOCONDUCTOR_DOCKER_VERSION=$BIOCONDUCTOR_DOCKER_VERSION
ENV BIOCONDUCTOR_VERSION=$BIOCONDUCTOR_VERSION

# Init command for s6-overlay
CMD ["/init"]
