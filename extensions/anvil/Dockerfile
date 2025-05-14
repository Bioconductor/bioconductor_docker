ARG BASE_IMAGE=us.gcr.io/broad-dsp-gcr-public/terra-jupyter-bioconductor
ARG TAG=2.2.7

FROM ${BASE_IMAGE}:${TAG}

USER root

ENV R_VERSION="4.5.0"
ENV R_HOME="/usr/local/lib/R"
ENV TZ="Etc/UTC"
ENV CRAN="https://p3m.dev/cran/__linux__/jammy/latest"
ENV LANG=en_US.UTF-8
ENV PATH=/usr/local/bin:$PATH
ENV S6_VERSION="v2.1.0.2"
ENV RSTUDIO_VERSION="2025.05.0+496"
ENV DEFAULT_USER="rstudio"

ENV RSTUDIO_PORT="8001"
ENV RSTUDIO_HOME="/etc/rstudio"
ENV RSTUDIO_USERSETTING="/home/rstudio/.config/rstudio/rstudio-prefs.json"

COPY rserver.conf $RSTUDIO_HOME/
COPY set_up_package_dir.sh ${RSTUDIO_HOME}/scripts/
COPY rstudio-prefs.json $RSTUDIO_USERSETTING

RUN apt-get update && apt-get install -y --no-install-recommends gnupg lsb-release \
    && mkdir -p /rocker_scripts $R_HOME/etc \
    && echo "deb http://packages.cloud.google.com/apt cloud-sdk main" > /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
    && apt-get update \
    && apt-get install -yq --no-install-recommends google-cloud-sdk \
    && wget -q https://github.com/rocker-org/rocker-versioned2/archive/e3a7d1f.tar.gz -O /tmp/rocker-scripts.tar.gz \
    && tar -xzf /tmp/rocker-scripts.tar.gz -C /tmp \
    && cp -r /tmp/rocker-versioned2-*/scripts/* /rocker_scripts/ \
    && chmod +x /rocker_scripts/*.sh \
    && rm -rf /tmp/rocker-scripts.tar.gz /tmp/rocker-versioned2-* \
    && if grep -q '1000' /etc/passwd; then usermod -l $DEFAULT_USER $(id -un 1000); fi \
    && /rocker_scripts/setup_R.sh \
    && /rocker_scripts/install_rstudio.sh \
    && /rocker_scripts/install_pandoc.sh \
    && /rocker_scripts/install_quarto.sh \
    && ln -s $(grep "^${DEFAULT_USER}:" /etc/passwd | cut -d: -f6) /home/${DEFAULT_USER} \
    && pip3 -V \
    && usermod -g users rstudio \
    && pip3 install --no-cache-dir -U crcmod terra-notebook-utils torch \
    && curl -L https://github.com/Bioconductor/bioconductor_docker/raw/refs/heads/devel/bioc_scripts/install_bioc_sysdeps.sh | sh \
    && R -e "BiocManager::install(c('AnVIL', 'AnVILBase', 'AnVILGCP', 'DataBiosphere/Ronaldo', 'shiny', 'bigrquery', 'googleCloudStorageR', 'tidyverse', 'Seurat', 'markdown', 'SingleCellExperiment', 'GenomicFeatures', 'GenomicAlignments', 'ShortRead', 'DESeq2', 'AnnotationHub', 'ExperimentHub', 'ensembldb', 'scRNAseq', 'scran', 'Rtsne'))" \
    && find ${RSTUDIO_HOME}/scripts -name '*.sh' -type f | xargs chmod +x \
    && echo "PIP_USER=true" >>  /usr/local/lib/R/etc/Renviron.site \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && usermod -o -u 1000 rstudio \
    && find / \( -path /proc -o -path /sys -o -path /dev \) -prune -o -user 1001 -exec chown -h 1000 {} \;

EXPOSE $RSTUDIO_PORT

ENTRYPOINT ["/bin/sh"]
CMD ["/init"]
