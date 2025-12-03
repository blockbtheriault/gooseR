#!/usr/bin/env Rscript
# ============================================================================
# gooseR + mtcars: Interactive AI-Enhanced Data Analysis Demo
# ============================================================================

library(gooseR)
library(ggplot2)
library(dplyr)

# ============================================================================
# 1. MEMORY INTEGRATION - Save mtcars analysis for Goose to remember
# ============================================================================

# Save the dataset with metadata for Goose
goose_save(
  mtcars,
  name = "mtcars_dataset",
  category = "demo_data",
  tags = c("cars", "mpg", "classic", "regression"),
  description = "Motor Trend Car Road Tests dataset from 1974"
)

# Create and save a summary analysis
mtcars_summary <- mtcars %>%
  group_by(cyl, am) %>%
  summarise(
    avg_mpg = mean(mpg),
    avg_hp = mean(hp),
    avg_wt = mean(wt),
    n = n(),
    .groups = "drop"
  )

goose_save(
  mtcars_summary,
  name = "mtcars_summary_by_cyl_transmission",
  category = "analysis",
  tags = c("summary", "grouped", "mpg_analysis"),
  description = "Summary statistics grouped by cylinders and transmission type"
)

# Save a linear model
mpg_model <- lm(mpg ~ wt + hp + am, data = mtcars)
goose_save(
  mpg_model,
  name = "mpg_prediction_model",
  category = "models",
  tags = c("linear_regression", "mpg", "prediction"),
  description = "Linear model predicting MPG from weight, horsepower, and transmission"
)

cat("✅ Saved mtcars data, summary, and model to Goose memory\n\n")

# ============================================================================
# 2. AI-ASSISTED ANALYSIS - Get insights about the data
# ============================================================================

# Ask Goose to explain the dataset
cat("🤖 Getting AI insights about mtcars...\n")
mtcars_explanation <- goose_ask(
  "Analyze the mtcars dataset I just saved and tell me:
   1. What are the most important factors affecting fuel efficiency?
   2. Are there any surprising patterns in the data?
   3. What would be the best visualization to show the relationship between mpg and other variables?"
)
cat(mtcars_explanation, "\n\n")

# Get code review for our model
model_review <- goose_review_code(
  "mpg_model <- lm(mpg ~ wt + hp + am, data = mtcars)",
  context = "Building a model to predict fuel efficiency"
)
cat("📊 Model Review:\n", model_review, "\n\n")

# ============================================================================
# 3. BRANDED VISUALIZATIONS - Create Block-styled plots
# ============================================================================

# Load Block branding
load_brand("block")

# Create a branded scatter plot
p1 <- ggplot(mtcars, aes(x = wt, y = mpg, color = factor(cyl))) +
  geom_point(size = 3) +
  geom_smooth(method = "lm", se = FALSE, alpha = 0.5) +
  labs(
    title = "Fuel Efficiency vs Weight",
    subtitle = "Grouped by Number of Cylinders",
    x = "Weight (1000 lbs)",
    y = "Miles Per Gallon",
    color = "Cylinders"
  ) +
  theme_brand()

ggsave("mtcars_mpg_weight_block.png", p1, width = 10, height = 6)
cat("✅ Created Block-branded scatter plot\n")

# Create a branded bar chart
p2 <- mtcars %>%
  group_by(cyl, am) %>%
  summarise(avg_mpg = mean(mpg), .groups = "drop") %>%
  mutate(transmission = ifelse(am == 0, "Automatic", "Manual")) %>%
  ggplot(aes(x = factor(cyl), y = avg_mpg, fill = transmission)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(
    title = "Average MPG by Cylinders and Transmission",
    x = "Number of Cylinders",
    y = "Average MPG",
    fill = "Transmission"
  ) +
  theme_brand(variant = "light")

ggsave("mtcars_mpg_bars_block.png", p2, width = 10, height = 6)
cat("✅ Created Block-branded bar chart\n\n")

# ============================================================================
# 4. AI-POWERED COLOR PALETTE - Get suggestions for the visualization
# ============================================================================

cat("🎨 Getting AI color suggestions...\n")
color_suggestion <- goose_suggest_colors(
  context = "automotive data visualization",
  n_colors = 4,
  style = "professional"
)
cat("Suggested colors:", color_suggestion, "\n\n")

# ============================================================================
# 5. OPTIMIZATION - Let AI improve our plot
# ============================================================================

plot_code <- '
ggplot(mtcars, aes(x = hp, y = mpg)) +
  geom_point() +
  geom_smooth()
'

optimized_plot <- goose_optimize_plot(
  plot_code,
  goal = "Make this more informative and visually appealing"
)
cat("📈 Optimized plot code:\n", optimized_plot, "\n\n")

# ============================================================================
# 6. DOCUMENTATION GENERATION - Create roxygen docs
# ============================================================================

cat("📝 Generating documentation...\n")
docs <- goose_document(
  "analyze_mpg",
  code = "
  analyze_mpg <- function(data, grouping_var = 'cyl') {
    data %>%
      group_by(!!sym(grouping_var)) %>%
      summarise(
        mean_mpg = mean(mpg),
        sd_mpg = sd(mpg),
        n = n()
      )
  }
  "
)
cat(docs, "\n\n")

# ============================================================================
# 7. TEST GENERATION - Create tests for our analysis
# ============================================================================

cat("🧪 Generating tests...\n")
tests <- goose_generate_tests("
get_efficient_cars <- function(data, min_mpg = 20) {
  data[data$mpg >= min_mpg, ]
}
")
cat(tests, "\n\n")

# ============================================================================
# 8. INTERACTIVE EXPLORATION - List what we saved
# ============================================================================

cat("📦 All saved gooseR objects:\n")
saved_items <- goose_list()
print(saved_items)

# ============================================================================
# 9. ADVANCED: Create a complete analysis report
# ============================================================================

cat("\n🚀 Creating comprehensive analysis with AI assistance...\n")

# Save correlation matrix
cor_matrix <- cor(mtcars[, c("mpg", "cyl", "disp", "hp", "wt", "qsec")])
goose_save(
  cor_matrix,
  name = "mtcars_correlations",
  category = "analysis",
  tags = c("correlation", "relationships"),
  description = "Correlation matrix of key mtcars variables"
)

# Ask for a comprehensive analysis
comprehensive_analysis <- goose_ask(
  "Based on the mtcars data, model, and correlation matrix I've saved,
   create a brief executive summary of the key findings about fuel efficiency
   that would be suitable for a business presentation."
)

cat("\n📊 EXECUTIVE SUMMARY:\n")
cat("=" * 60, "\n")
cat(comprehensive_analysis, "\n")
cat("=" * 60, "\n")

# ============================================================================
# 10. CLEANUP DEMO - Show how to manage memory
# ============================================================================

cat("\n🧹 Memory Management Demo:\n")
cat("Current memory usage:\n")
memory_stats <- goose_list(category = "demo_data")
print(memory_stats)

# Example of selective deletion (commented out to preserve data)
# goose_delete(name = "mtcars_dataset", category = "demo_data")
# cat("Deleted mtcars_dataset from memory\n")

cat("\n✨ Demo complete! The mtcars analysis is now saved in Goose memory\n")
cat("You can ask Goose about this analysis in future conversations!\n")
