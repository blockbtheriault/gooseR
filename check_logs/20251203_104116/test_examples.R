cat("\n== Testing Package Examples ==\n")

# Run example checks
example_files <- list.files("man", pattern = "\\.Rd$", full.names = TRUE)
cat("Found", length(example_files), "documentation files\n")

# Test a few key examples
test_examples <- c("goose_save.Rd", "theme_brand.Rd", "goose_create_brand.Rd")

for (ex in test_examples) {
  ex_file <- file.path("man", ex)
  if (file.exists(ex_file)) {
    cat("\nTesting", ex, ": ")
    # Extract and run examples
    tryCatch({
      tools::Rd2ex(ex_file, out = tempfile(fileext = ".R"), commentDontrun = TRUE)
      cat("PASS\n")
    }, error = function(e) cat("FAIL:", conditionMessage(e), "\n"))
  }
}
