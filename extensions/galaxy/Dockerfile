ARG BASE_IMAGE=ghcr.io/bioconductor/bioconductor_docker
ARG TAG=3.20

FROM ${BASE_IMAGE}:${TAG}
RUN apt update -y && apt install -y net-tools python3-bioblend && \
    Rscript -e 'BiocManager::install(c("Biobase", "BiocGenerics", "Biostrings", "cummeRbund", "DESeq2", "dplyr", "edgeR", "GenomeInfoDb", "ggplot2", "ggvis", "Gviz", "hexylena/rGalaxyConnector", "IRanges", "limma", "RCurl", "reshape2", "Rgraphviz", "RODBC", "Rsamtools", "S4Vectors", "shiny", "SummarizedExperiment", "tidyr", "XML"))' && \
    pip3 install galaxy-ie-helpers --break-system-packages && \
    chown -R rstudio:rstudio /usr/local/lib/R/library && \
    chown -R rstudio:rstudio /usr/local/lib/R/doc && \
    echo "alias ll='ls -l'" >> ~/.bashrc && \
    apt-get autoremove -y && apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*
ENV PIP_USER=0
