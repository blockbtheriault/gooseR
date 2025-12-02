# Code Review Workflow Demo - gooseR

# Sample R functions to review
slow_mean <- function(x) {
  s <- 0
  for (i in seq_along(x)) s <- s + x[i]
  s / length(x)
}

fast_mean <- function(x) mean(x)

# Workflow (IDE actions demonstrated programmatically)
# goose_addin_review() # In RStudio/Positron: select code and trigger addin
# review <- goose_review_code(deparse(body(slow_mean)))
# tests <- goose_generate_tests(function_name = "slow_mean", examples = list(c(1,2,3)))
# docs <- goose_document(function_name = "slow_mean")
# optimized <- goose_optimize_plot(plot_obj) # Example for ggplot objects

message("Code Review demo ready. Try goose_review_code(), goose_generate_tests().")
