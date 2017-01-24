args = commandArgs(trailingOnly=TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else {

  install.packages(c("rmarkdown",
                     "tidyverse",
                     "viridis",
                     "shiny"
                     ),
                    # pass in r_base_mirror
                    repos=args[1]
                  )
}
