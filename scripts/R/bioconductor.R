## try http:// if https:// URLs are not supported
source("https://bioconductor.org/biocLite.R")
# Install base BioConductor
biocLite(ask=FALSE)
#upgrade bioconductor installer
#biocLite("BiocUpgrade")
# Install the BioConductor packages we want
biocLite(pkgs = c("Biostrings",
                  "GenomicRanges",
                  "BSgenome",
                  "rtracklayer",
                  "motifRG",
                  "Rsubread",
                  "edgeR",
                  "limma",
                  "biomaRt",
                  "org.Hs.eg.db",
                  "scater",
                  "getopt",
                  "MASS",
                  "GOstats",
                  "DESeq2",
                  "metagenomeSeq")
         )
