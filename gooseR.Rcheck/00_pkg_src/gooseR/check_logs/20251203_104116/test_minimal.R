cat("\n== Minimal Dependencies Test ==\n")

# Test what works without optional packages
suppressPackageStartupMessages(library(gooseR))

cat("1. Basic functions available: ")
fns <- c("goose_save", "goose_load", "theme_brand", "load_brand")
if (all(fns %in% ls("package:gooseR"))) cat("PASS\n") else cat("FAIL\n")

cat("2. CLI integration check: ")
if (goose_check_installation()) cat("PASS\n") else cat("FAIL\n")

cat("3. Brand creation (non-interactive): ")
tryCatch({
  brand_id <- paste0("test_", format(Sys.time(), "%H%M%S"))
  path <- goose_create_brand(brand_id, interactive = FALSE)
  if (file.exists(path)) cat("PASS\n") else cat("FAIL\n")
}, error = function(e) cat("FAIL:", conditionMessage(e), "\n"))
