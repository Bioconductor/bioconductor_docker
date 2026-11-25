#!/bin/bash
BIOCVER=$1
FILETOPATCH=$2

# R version (x.y.z) that Bioconductor devel builds against
DEVEL_R_VER=$(curl -s https://master.bioconductor.org/config.yaml | awk -F'"' '/^r_version_associated_with_devel:/ {print $2}')
# R version currently under development on CRAN (x.y.z)
CRAN_DEVEL_VER=$(curl -s https://cran.r-project.org/src/base/VERSION-INFO.dcf | awk '/^Devel:/ {print $2}')
echo "Bioconductor devel R: $DEVEL_R_VER; CRAN R-devel: $CRAN_DEVEL_VER"
# Compare major.minor only: if Bioconductor devel is not on the R-devel series
# (e.g., right after an R x.y.0 release), use the patched pre-release instead
if [ "${DEVEL_R_VER%.*}" != "${CRAN_DEVEL_VER%.*}" ]; then
    sed -i 's#\(R_VERSION=\)\(["]\?\)devel\2#\1\2patched\2#g' "$FILETOPATCH"
fi

cat "$FILETOPATCH"
