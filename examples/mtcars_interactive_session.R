#!/usr/bin/env Rscript
# ============================================================================
# Interactive gooseR Session with mtcars
# Run these commands in your R console for an interactive experience
# ============================================================================

# Load libraries
library(gooseR)
library(ggplot2)
library(dplyr)

# ----------------------------------------------------------------------------
# 1. Quick Start: Save mtcars for Goose to remember across sessions
# ----------------------------------------------------------------------------

# This makes mtcars available to Goose even after R session ends
goose_save(mtcars, "mtcars_full", category = "datasets", 
           tags = c("cars", "classic", "32_observations"),
           description = "Complete Motor Trend cars dataset from 1974")

# ----------------------------------------------------------------------------
# 2. Ask Goose for analysis ideas
# ----------------------------------------------------------------------------

# Get suggestions for analysis
goose_ask("What are 3 interesting analyses I could do with the mtcars dataset?")

# Get help with a specific question
goose_ask("In mtcars, what's the relationship between displacement and fuel efficiency?")

# ----------------------------------------------------------------------------
# 3. Save your analysis progress
# ----------------------------------------------------------------------------

# Do some analysis
my_analysis <- mtcars %>%
  mutate(
    efficiency_class = case_when(
      mpg > 25 ~ "High",
      mpg > 18 ~ "Medium", 
      TRUE ~ "Low"
    ),
    power_to_weight = hp / wt
  )

# Save it with context
goose_save(
  my_analysis,
  name = "mtcars_enhanced",
  category = "analysis",
  tags = c("efficiency_classes", "power_ratio", "feature_engineering"),
  description = "mtcars with efficiency classifications and power-to-weight ratio"
)

# ----------------------------------------------------------------------------
# 4. Get AI help with your code
# ----------------------------------------------------------------------------

# Review your analysis approach
goose_review_code("
  mtcars %>%
    group_by(cyl) %>%
    summarise(avg_mpg = mean(mpg)) %>%
    arrange(desc(avg_mpg))
", context = "Analyzing fuel efficiency by cylinder count")

# Get help fixing an error
goose_explain_error(
  "Error: object 'carb' not found",
  context = "Trying to filter mtcars by carburetor count"
)

# ----------------------------------------------------------------------------
# 5. Create beautiful visualizations with Block branding
# ----------------------------------------------------------------------------

# Load Block theme
load_brand("block")

# Create plot with Block styling
p <- ggplot(mtcars, aes(x = hp, y = mpg)) +
  geom_point(aes(color = factor(cyl)), size = 3) +
  geom_smooth(method = "lm", se = TRUE, alpha = 0.2) +
  labs(
    title = "Horsepower vs Fuel Efficiency",
    subtitle = "Motor Trend Car Road Tests (1974)",
    x = "Horsepower",
    y = "Miles per Gallon",
    color = "Cylinders"
  ) +
  theme_brand()

print(p)

# Get suggestions to improve the plot
goose_optimize_plot(
  deparse(substitute(p)),
  goal = "Make this more suitable for an executive presentation"
)

# ----------------------------------------------------------------------------
# 6. Build and document a model
# ----------------------------------------------------------------------------

# Create model
mpg_model <- lm(mpg ~ wt + hp + am, data = mtcars)

# Save it for future use
goose_save(
  mpg_model,
  name = "mpg_predictor",
  category = "models",
  tags = c("linear_model", "mpg_prediction", "3_variables"),
  description = "Predicts MPG from weight, horsepower, and transmission type"
)

# Generate tests for model predictions
goose_generate_tests("
predict_mpg <- function(weight, horsepower, manual = TRUE) {
  newdata <- data.frame(wt = weight, hp = horsepower, am = as.numeric(manual))
  predict(mpg_model, newdata)
}
")

# ----------------------------------------------------------------------------
# 7. Retrieve your saved work later
# ----------------------------------------------------------------------------

# See everything you've saved
goose_list()

# Load specific analysis
my_saved_analysis <- goose_load("mtcars_enhanced", category = "analysis")
head(my_saved_analysis)

# Find items by tag
efficiency_items <- goose_list(tags = "efficiency")
print(efficiency_items)

# ----------------------------------------------------------------------------
# 8. Use templates for common tasks
# ----------------------------------------------------------------------------

# Use a data summary template
goose_template_apply(
  "data_summary",
  data = mtcars,
  group_vars = c("cyl", "am"),
  summary_vars = c("mpg", "hp", "wt")
)

# ----------------------------------------------------------------------------
# 9. Collaborate with Goose on insights
# ----------------------------------------------------------------------------

# Ask for business insights
goose_ask(
  "Based on the mtcars analysis I've saved, what would be the key takeaways 
   for a car manufacturer in 1974?"
)

# Get help with statistical interpretation  
summary_output <- capture.output(summary(mpg_model))
goose_ask(
  paste("Help me interpret this model output for a non-technical audience:",
        paste(summary_output, collapse = "\n"))
)

# ----------------------------------------------------------------------------
# 10. Clean up when done (optional)
# ----------------------------------------------------------------------------

# Remove specific items
# goose_delete("mtcars_full", category = "datasets")

# Or keep everything for next session!
cat("\n✅ All your mtcars analysis is saved in gooseR memory!\n")
cat("📝 Access it anytime with: goose_list() and goose_load()\n")
cat("🤖 Ask Goose about it in future conversations!\n")
