args = commandArgs(trailingOnly=TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else {

  install.packages(c("shiny",
                     "httpuv",
                     "backports",
                     "base64enc",
                     "bitops",
                     "caTools",
                     "digest",
                     "evaluate",
                     "formatR",
                     "highr",
                     "htmltools",
                     "jsonlite",
                     "knitr",
                     "magrittr",
                     "markdown",
                     "mime",
                     "Rcpp",
                     "rmarkdown",
                     "rprojroot",
                     "stringi",
                     "stringr",
                     "yaml",
                     "tidyverse",
                     "gtools",
                     "viridis",
                     "optparse",
                     "plotly",
                     "bookdown",
                     # from r-commended debian pacakge
                     "boot",
                     "class",
                     "cluster",
                     "codetools",
                     "foreign",
                     "kernsmooth",
                     "lattice",
                     "mass",
                     "matrix",
                     "mgcv",
                     "nlme",
                     "nnet",
                     "rpart",
                     "spatial",
                     "survival",
                     # qiime requiments
                     "ape",
                     "biom",
                     "RColorBrewer",
                     "randomForest",
                     "vegan"
                     ),
                    # pass in r_base_mirror
                    repos=args[1],
                    lib=args[2]
                    #lib="/usr/local/lib/R/site-library"
                  )
}
