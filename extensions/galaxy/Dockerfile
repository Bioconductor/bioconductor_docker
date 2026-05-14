ARG BASE_IMAGE=bioconductor/bioconductor_docker
ARG TAG=RELEASE_3_23

FROM ${BASE_IMAGE}:${TAG}
RUN apt update -y && apt install -y net-tools python3-bioblend nginx && \
    Rscript -e 'BiocManager::install("remotes", ask = FALSE); \
        packages <- c( \
            "AnnotationDbi", "AnnotationHub", "apeglm", "Biobase", \
            "BiocFileCache", "BiocGenerics", "BiocNeighbors", \
            "BiocParallel", "BiocSingular", "Biostrings", "BSgenome", \
            "batchelor", "clusterProfiler", "ComplexHeatmap", \
            "DelayedArray", "DelayedMatrixStats", "DESeq2", "DOSE", \
            "DropletUtils", "DT", "dplyr", "edgeR", "EnhancedVolcano", \
            "ensembldb", "enrichplot", "ExperimentHub", "fgsea", \
            "GenomeInfoDb", "GenomicAlignments", "GenomicFeatures", \
            "GenomicRanges", "ggplot2", "ggvis", "GO.db", "GSEABase", \
            "GSVA", "Gviz", "HDF5Array", "iSEE", "impute", "IRanges", \
            "knitr", "limma", "MatrixGenerics", "org.Hs.eg.db", \
            "org.Mm.eg.db", "patchwork", "pheatmap", "plotly", \
            "qvalue", "RCurl", "reshape2", "Rgraphviz", "rhdf5", \
            "rhdf5filters", "rmarkdown", "RODBC", "Rsamtools", \
            "rtracklayer", "S4Vectors", "scater", "scran", "scuttle", \
            "shiny", "SingleCellExperiment", "sparseMatrixStats", \
            "SummarizedExperiment", "sva", "tidyr", "tidyverse", \
            "tximeta", "tximport", "VariantAnnotation", "XML" \
        ); \
        BiocManager::install(packages, ask = FALSE); \
        remotes::install_github("hexylena/rGalaxyConnector", upgrade = "never")' && \
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
