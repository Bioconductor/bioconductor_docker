ARG BASE_IMAGE=bioconductor/bioconductor_docker
ARG TAG=RELEASE_3_21

FROM ${BASE_IMAGE}:${TAG}
RUN apt update -y && apt install -y net-tools python3-bioblend nginx && \
    Rscript -e 'BiocManager::install(c("Biobase", "BiocGenerics", "Biostrings", "cummeRbund", "DESeq2", "dplyr", "edgeR", "GenomeInfoDb", "ggplot2", "ggvis", "Gviz", "hexylena/rGalaxyConnector", "impute", "IRanges", "limma", "RCurl", "reshape2", "Rgraphviz", "RODBC", "Rsamtools", "S4Vectors", "shiny", "SummarizedExperiment", "tidyr", "XML"))' && \
    pip3 install galaxy-ie-helpers --break-system-packages && \
    chown -R rstudio:rstudio /usr/local/lib/R/library && \
    chown -R rstudio:rstudio /usr/local/lib/R/doc && \
    echo "alias ll='ls -l'" >> ~/.bashrc && \
    echo "rstudio ALL=(ALL) NOPASSWD: /usr/bin/s6-svscanctl" >> /etc/sudoers && \
    apt-get autoremove -y && apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*

RUN mkdir -p /etc/services.d/nginx
COPY service-nginx-start /etc/services.d/nginx/run
COPY proxy.conf /etc/nginx/sites-enabled/default
COPY shutdown.R /home/rstudio/shutdown.R

ENV PIP_USER=0

EXPOSE 8780
