# The suggested name for this image is: bioconductor/bioconductor_docker:devel
ARG BASE_IMAGE=rocker/rstudio
ARG arm64_tag=latest
ARG amd64_tag=latest
FROM ${BASE_IMAGE}:${arm64_tag} AS base-arm64
# This will persist in final image
ENV BIOCONDUCTOR_USE_CONTAINER_REPOSITORY=FALSE

FROM ${BASE_IMAGE}:${amd64_tag} AS base-amd64
# This will persist in final image
ENV BIOCONDUCTOR_USE_CONTAINER_REPOSITORY=TRUE

# Set automatically when building with --platform
ARG TARGETARCH
ENV TARGETARCH=${TARGETARCH:-amd64}
FROM base-$TARGETARCH AS base

## Set Dockerfile version number
ARG BIOCONDUCTOR_VERSION=3.18

##### IMPORTANT ########
## The PATCH version number should be incremented each time
## there is a change in the Dockerfile.
ARG BIOCONDUCTOR_PATCH=22

ARG BIOCONDUCTOR_DOCKER_VERSION=${BIOCONDUCTOR_VERSION}.${BIOCONDUCTOR_PATCH}

## Do not use binary repositories during container creation
## Avoid using binaries produced for older version of same container
ENV BIOCONDUCTOR_USE_CONTAINER_REPOSITORY=FALSE

# Add Bioconductor system dependencies
# Add host-site-library# DEVEL: Add sys env variables to DEVEL image
# Variables in Renviron.site are made available inside of R.
# Add libsbml CFLAGS
ADD bioc_scripts/install_bioc_sysdeps.sh /tmp/
RUN bash /tmp/install_bioc_sysdeps.sh $BIOCONDUCTOR_VERSION \
    && echo "R_LIBS=/usr/local/lib/R/host-site-library:\${R_LIBS}" > /usr/local/lib/R/etc/Renviron.site \
    && curl -OL http://bioconductor.org/checkResults/devel/bioc-LATEST/Renviron.bioc \
    && sed -i '/^IS_BIOC_BUILD_MACHINE/d' Renviron.bioc \
    && cat Renviron.bioc | grep -o '^[^#]*' | sed 's/export //g' >>/etc/environment \
    && cat Renviron.bioc >> /usr/local/lib/R/etc/Renviron.site \
    && echo BIOCONDUCTOR_VERSION=${BIOCONDUCTOR_VERSION} >> /usr/local/lib/R/etc/Renviron.site \
    && echo BIOCONDUCTOR_DOCKER_VERSION=${BIOCONDUCTOR_DOCKER_VERSION} >> /usr/local/lib/R/etc/Renviron.site \
    && echo 'LIBSBML_CFLAGS="-I/usr/include"' >> /usr/local/lib/R/etc/Renviron.site \
    && echo 'LIBSBML_LIBS="-lsbml"' >> /usr/local/lib/R/etc/Renviron.site \
    && rm -rf Renviron.bioc

ARG TARGETARCH
ENV TARGETARCH=${TARGETARCH:-amd64}

FROM base-$TARGETARCH AS final
COPY --from=base / /

LABEL name="bioconductor/bioconductor_docker" \
      version=$BIOCONDUCTOR_DOCKER_VERSION \
      url="https://github.com/Bioconductor/bioconductor_docker" \
      vendor="Bioconductor Project" \
      maintainer="maintainer@bioconductor.org" \
      description="Bioconductor docker image with system dependencies to install all packages." \
      license="Artistic-2.0"

# Reset args in last layer
ARG BIOCONDUCTOR_VERSION=3.18
ARG BIOCONDUCTOR_PATCH=22
ARG BIOCONDUCTOR_DOCKER_VERSION=${BIOCONDUCTOR_VERSION}.${BIOCONDUCTOR_PATCH}

# Set automatically when building with --platform
ARG TARGETPLATFORM
ENV TARGETPLATFORM=${TARGETPLATFORM:-linux/amd64}

## Set env variables
ENV PLATFORM=${TARGETPLATFORM}
ENV LIBSBML_CFLAGS="-I/usr/include"
ENV LIBSBML_LIBS="-lsbml"
ENV BIOCONDUCTOR_DOCKER_VERSION=$BIOCONDUCTOR_DOCKER_VERSION
ENV BIOCONDUCTOR_VERSION=$BIOCONDUCTOR_VERSION
ENV BIOCONDUCTOR_NAME="bioconductor_docker"

# Init command for s6-overlay
CMD ["/init"]
