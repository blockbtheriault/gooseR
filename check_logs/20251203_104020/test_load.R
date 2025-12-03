.libPaths(c("/tmp/test_lib_20251203_104118", .libPaths()))
suppressPackageStartupMessages({
  library(gooseR)
  library(ggplot2)
})

cat("== Load Test ==\n")
cat("Package version:", as.character(packageVersion("gooseR")), "\n")
cat("goose_version():", goose_version(), "\n")
