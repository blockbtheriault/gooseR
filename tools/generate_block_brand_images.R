# tools/generate_block_brand_images.R
# Generate Block brand demo images for README (monochrome + sans-serif)
# Requires: ggplot2; prefers using gooseR::theme_brand if available

suppressPackageStartupMessages({
  library(ggplot2)
})

# Try to load package from source if running inside repo
if (requireNamespace("devtools", quietly = TRUE)) {
  try(devtools::load_all("."), silent = TRUE)
}

# Safe theme wrapper to ensure brand is available
brand_theme <- function() {
  if (exists("theme_brand", mode = "function")) {
    # Loaded from local source via devtools::load_all()
    theme_brand("block")
  } else if (requireNamespace("gooseR", quietly = TRUE)) {
    # Use installed package if available
    gooseR::theme_brand("block")
  } else {
    message("gooseR not available; falling back to minimal theme (no branding)")
    theme_minimal(base_size = 12)
  }
}

# Output directory for assets
assets_dir <- file.path("docs", "assets")
if (!dir.exists(assets_dir)) dir.create(assets_dir, recursive = TRUE)

# 1) Line chart (time series)
set.seed(42)
line_df <- data.frame(
  month = factor(month.abb[1:12], levels = month.abb[1:12]),
  value = cumsum(rnorm(12, 2, 1))
)

p_line <- ggplot(line_df, aes(month, value, group = 1)) +
  geom_line(color = "#000000", linewidth = 1.2) +
  geom_point(color = "#000000", size = 2) +
  labs(title = "Trend over time", x = "Month", y = "Value") +
  brand_theme()

ggsave(file.path(assets_dir, "block_line_chart.png"), p_line, width = 8, height = 4.5, dpi = 200)

# 2) Bar chart (categorical)
bar_df <- data.frame(
  category = factor(c("A", "B", "C", "D"), levels = c("A", "B", "C", "D")),
  value = c(12, 19, 7, 15)
)

p_bar <- ggplot(bar_df, aes(category, value)) +
  geom_col(fill = "#000000") +
  labs(title = "Category comparison", x = "Category", y = "Value") +
  brand_theme()

ggsave(file.path(assets_dir, "block_bar_chart.png"), p_bar, width = 8, height = 4.5, dpi = 200)

message("Assets generated in docs/assets: block_line_chart.png, block_bar_chart.png")
