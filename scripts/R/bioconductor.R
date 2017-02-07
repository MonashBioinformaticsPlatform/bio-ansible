## try http:// if https:// URLs are not supported
source("https://bioconductor.org/biocLite.R")
# Install base BioConductor
biocLite(ask=FALSE)
# Install the BioConductor packages we want
biocLite(c("Biostrings",
           "GenomicRanges",
           "BSgenome",
           "rtracklayer",
           "motifRG",
           "Rsubread",
           "edgeR",
           "limma",
           "biomaRt",
           "org.Hs.eg.db",
           "GOstats")
         )
