## try http:// if https:// URLs are not supported
r = getOption("repos")
r["CRAN"] = "https://mirror.aarnet.edu.au/pub/CRAN/"
options(repos = r)

if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install()


# source("https://bioconductor.org/biocLite.R")
# # Install base BioConductor
# biocLite(ask=FALSE)
# #upgrade bioconductor installer
# #biocLite("BiocUpgrade")
# # Install the BioConductor packages we want
# biocLite(pkgs = c("Biostrings",
#                   "GenomicRanges",
#                   "GenomicFeatures",
#                   "BSgenome",
#                   "rtracklayer",
#                   "plyranges",
#                   "motifRG",
#                   "Rsubread",
#                   "edgeR",
#                   "limma",
#                   "biomaRt",
#                   "org.Hs.eg.db",
#                   "scater",
#                   "getopt",
#                   "MASS",
#                   "GOstats",
#                   "DESeq2",
#                   "metagenomeSeq")
#          )
