args = commandArgs(trailingOnly=TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else {

  install.packages(c("Rcpp",
                     "httpuv",
                     "rmarkdown",
                     "tidyverse",
                     "viridis",
                     "formatR",
                     "shiny",
                     "plotly"
                     ),
                    # pass in r_base_mirror
                    repos=args[1],
                    lib="/usr/local/lib/R/site-library"
                  )
}
