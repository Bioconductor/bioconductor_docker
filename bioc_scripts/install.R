install.packages("BiocManager", repos="https://cran.rstudio.com")

BiocManager::install(version="3.15", update=TRUE, ask=FALSE)

BiocManager::install(c('devtools', 'AnVIL'))
