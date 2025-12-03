.libPaths(c("/tmp/test_lib_20251203_104046", .libPaths()))
suppressPackageStartupMessages(library(gooseR))

cat("\n== Core Functionality Tests ==\n")

# Test 1: Version check
cat("1. Version check: ")
v <- goose_version()
if (is.character(v) && nchar(v) > 0) cat("PASS\n") else cat("FAIL\n")

# Test 2: Brand loading
cat("2. Load Block brand: ")
tryCatch({
  config <- load_brand("block")
  if (validate_brand(config)) cat("PASS\n") else cat("FAIL\n")
}, error = function(e) cat("FAIL:", conditionMessage(e), "\n"))

# Test 3: Theme creation
cat("3. Create theme: ")
tryCatch({
  suppressPackageStartupMessages(library(ggplot2))
  theme <- theme_brand("block")
  if (inherits(theme, "theme")) cat("PASS\n") else cat("FAIL\n")
}, error = function(e) cat("FAIL:", conditionMessage(e), "\n"))

# Test 4: Palette generation
cat("4. Brand palette: ")
tryCatch({
  pal <- brand_palette("block", "categorical", 5)
  if (length(pal) == 5 && all(grepl("^#", pal))) cat("PASS\n") else cat("FAIL\n")
}, error = function(e) cat("FAIL:", conditionMessage(e), "\n"))

# Test 5: Memory save/load
cat("5. Memory operations: ")
tryCatch({
  test_obj <- data.frame(x = 1:3, y = 4:6)
  goose_save(test_obj, "test_local_20251203_104046", global = FALSE, overwrite = TRUE)
  loaded <- goose_load("test_local_20251203_104046", global = FALSE)
  if (identical(test_obj, loaded)) cat("PASS\n") else cat("FAIL\n")
  goose_delete("test_local_20251203_104046", global = FALSE, confirm = FALSE)
}, error = function(e) cat("FAIL:", conditionMessage(e), "\n"))

cat("\nCore tests complete\n")
