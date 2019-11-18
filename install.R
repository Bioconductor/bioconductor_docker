if ("BiocManager" %in% rownames(installed.packages()))
    remove.packages("BiocManager")

install.packages("BiocManager", repos="https://cran.rstudio.com")

library(BiocManager)

if(BiocManager::version() != "3.11"){
    BiocManager::install(version="3.11",
                         update=TRUE, ask=FALSE)
}

builtins <- c("Matrix", "KernSmooth", "mgcv", "devtools")

for (builtin in builtins)
    if (!suppressWarnings(require(builtin, character.only=TRUE)))
        suppressWarnings(BiocManager::install(builtin,
                                              version="3.11",
                                              update=TRUE, ask=FALSE))
