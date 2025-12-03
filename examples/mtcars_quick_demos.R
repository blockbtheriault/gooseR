#!/usr/bin/env Rscript
# ============================================================================
# Quick gooseR + mtcars Examples
# ============================================================================

library(gooseR)
library(ggplot2)
library(dplyr)

# ----------------------------------------------------------------------------
# Example 1: Save mtcars subsets for different analysis contexts
# ----------------------------------------------------------------------------

# High performance cars
performance_cars <- mtcars %>%
  filter(hp > 200) %>%
  arrange(desc(hp))

goose_save(
  performance_cars,
  name = "high_performance_cars",
  category = "mtcars_analysis",
  tags = c("performance", "horsepower", "sports"),
  description = "Cars with >200 HP from mtcars dataset"
)

# Fuel efficient cars
efficient_cars <- mtcars %>%
  filter(mpg > 25) %>%
  arrange(desc(mpg))

goose_save(
  efficient_cars,
  name = "fuel_efficient_cars",
  category = "mtcars_analysis", 
  tags = c("efficiency", "economy", "mpg"),
  description = "Cars with >25 MPG from mtcars dataset"
)

cat("✅ Saved performance and efficiency subsets\n\n")

# ----------------------------------------------------------------------------
# Example 2: Use AI to explain statistical findings
# ----------------------------------------------------------------------------

# Run a quick ANOVA
aov_result <- aov(mpg ~ factor(cyl) + factor(am), data = mtcars)

# Get AI explanation
explanation <- goose_explain_error(
  capture.output(summary(aov_result)),
  context = "ANOVA results for mtcars MPG analysis"
)
cat("🤖 AI Explanation of ANOVA:\n", explanation, "\n\n")

# ----------------------------------------------------------------------------
# Example 3: Create and save multiple models for comparison
# ----------------------------------------------------------------------------

models <- list(
  simple = lm(mpg ~ wt, data = mtcars),
  medium = lm(mpg ~ wt + hp, data = mtcars),
  complex = lm(mpg ~ wt + hp + am + factor(cyl), data = mtcars)
)

# Save all models with metadata
for(name in names(models)) {
  goose_save(
    models[[name]],
    name = paste0("mpg_model_", name),
    category = "models",
    tags = c("regression", name, "comparison"),
    description = paste("MPG prediction model -", name, "complexity")
  )
}

# Compare models
model_comparison <- data.frame(
  model = names(models),
  r_squared = sapply(models, function(m) summary(m)$r.squared),
  aic = sapply(models, AIC),
  variables = sapply(models, function(m) length(coef(m)))
)

goose_save(
  model_comparison,
  name = "model_comparison_results",
  category = "analysis",
  tags = c("model_selection", "comparison", "metrics"),
  description = "Comparison of three MPG prediction models"
)

print(model_comparison)
cat("\n")

# ----------------------------------------------------------------------------
# Example 4: Create Block-branded visualization with AI-suggested improvements
# ----------------------------------------------------------------------------

# Basic plot
p <- ggplot(mtcars, aes(x = wt, y = mpg)) +
  geom_point(aes(size = hp, color = factor(cyl))) +
  theme_brand()

# Get AI suggestions for improvement
plot_suggestions <- goose_ask(
  "I have a scatter plot of mtcars showing weight vs mpg, with point size 
   representing horsepower and color showing cylinders. What would make this 
   more effective for a business presentation?"
)
cat("📊 Plot improvement suggestions:\n", plot_suggestions, "\n\n")

# ----------------------------------------------------------------------------
# Example 5: Generate insights for specific questions
# ----------------------------------------------------------------------------

# Question 1: Transmission impact
transmission_insight <- goose_ask(
  paste("Based on this data:",
        "Automatic transmission cars (am=0):", mean(mtcars$mpg[mtcars$am==0]), "MPG",
        "Manual transmission cars (am=1):", mean(mtcars$mpg[mtcars$am==1]), "MPG",
        "Is this difference practically significant for consumers?")
)
cat("🚗 Transmission Insight:\n", transmission_insight, "\n\n")

# ----------------------------------------------------------------------------
# Example 6: Create a function with AI-generated documentation
# ----------------------------------------------------------------------------

# Define function
analyze_by_group <- function(data, group_var, metric_var) {
  data %>%
    group_by(!!sym(group_var)) %>%
    summarise(
      mean = mean(!!sym(metric_var)),
      median = median(!!sym(metric_var)),
      sd = sd(!!sym(metric_var)),
      n = n(),
      .groups = "drop"
    )
}

# Generate documentation
docs <- goose_document(
  "analyze_by_group",
  code = deparse(analyze_by_group)
)
cat("📝 Generated Documentation:\n", docs, "\n\n")

# Use the function
cyl_analysis <- analyze_by_group(mtcars, "cyl", "mpg")
print(cyl_analysis)

# ----------------------------------------------------------------------------
# Example 7: Interactive memory management
# ----------------------------------------------------------------------------

cat("\n📦 Current gooseR memory contents:\n")
all_saved <- goose_list()
print(all_saved)

# Find specific items
cat("\n🔍 Finding all models:\n")
models_in_memory <- goose_list(tags = "regression")
print(models_in_memory)

cat("\n✨ Examples complete! Use goose_list() to see everything saved.\n")
