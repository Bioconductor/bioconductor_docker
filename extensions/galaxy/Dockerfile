ARG BASE_IMAGE=ghcr.io/bioconductor/bioconductor_docker
ARG TAG=devel

FROM ${BASE_IMAGE}:${TAG}
RUN apt update -y && apt install -y net-tools python3-bioblend && Rscript -e 'BiocManager::install("hexylena/rGalaxyConnector")' && pip3 install galaxy-ie-helpers --break-system-packages && alias ll='ls -l' && echo "alias ll='ls -l'" >> ~/.bashrc
ENV PIP_USER=0