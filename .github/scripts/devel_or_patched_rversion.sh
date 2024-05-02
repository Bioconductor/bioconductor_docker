#!/bin/bash
BIOCVER=$1
FILETOPATCH=$2

DEVEL_R_VER=$(curl https://bioconductor.org/config.yaml | grep '_devel:' | awk '{print $2}' | sed 's/"//g')
REL_VER=$(curl https://cran.r-project.org/src/base/VERSION-INFO.dcf | grep "$DEVEL_R_VER" | awk -F':' '{print $1}')
# if the matching version is not under devel, use patched pre-release rather than devel pre-release
if [ "$REL_VER" != "Devel" ]; then 
    sed -i 's#\(R_VERSION=\)\(["]\?\)devel\2#\1\2patched\2#g' "$FILETOPATCH"
fi

cat "$FILETOPATCH"
