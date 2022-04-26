install.packages("BiocManager", repos="https://cran.rstudio.com")

BiocManager::install(version="devel", update=TRUE, ask=FALSE)

BiocManager::install(c('devtools'))
