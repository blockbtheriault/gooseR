# gooseR <img src="man/figures/logo.png" align="right" height="139" />

<!-- badges: start -->
[![R-CMD-check](https://github.com/blockbtheriault/gooseR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/blockbtheriault/gooseR/actions/workflows/R-CMD-check.yaml)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

> **Seamless R Integration for Goose AI** 🦆

gooseR bridges R and [Goose AI](https://github.com/block/goose), enabling AI-augmented data analysis workflows. Save R objects to Goose memory, enhance visualizations with Block branding, and manage reproducible data science projects.

## ✨ Features

### 🧠 Memory Integration
- **Save R objects to Goose memory** - Models, datasets, and analysis artifacts persist across sessions
- **Smart retrieval** - Load objects by name, category, or tags
- **Metadata tracking** - Automatic documentation of object class, size, and creation time
- **Global & local storage** - Project-specific or user-wide memory

### 🎨 Universal Branding System ✅
- **Brand Configuration** - Define complete brand identity in YAML format
- **ggplot2 Themes** - Generate consistent, branded themes for all visualizations
- **RMarkdown Templates** - Create branded report templates with integrated CSS
- **CSS Generation** - Export brand styles for web projects
- **Color Palettes** - Access brand colors for categorical, sequential, and diverging scales
- **Interactive Creation** - Build new brands through interactive CLI prompts
- **Multi-brand Support** - Manage multiple brand configurations

### 🔧 Workflow Management (Coming Soon)
- **Project templates** - Cookiecutter-style setup for people analytics, data science, and reporting
- **Dependency tracking** - Monitor data lineage and reproducibility
- **Team collaboration** - Share workflows and analysis patterns

## 📦 Installation

```r
# Install from GitHub (development version)
# install.packages("devtools")
devtools::install_github("blockbtheriault/gooseR")
```

## 🚀 Quick Start

### Memory Integration

```r
library(gooseR)

# Save a model to Goose memory
model <- lm(mpg ~ wt + hp, data = mtcars)
goose_save(
  model, 
  name = "mtcars_model_v1",
  category = "models",
  tags = c("regression", "mtcars", "production"),
  description = "Linear model predicting mpg from weight and horsepower"
)
#> ✔ Saved 'mtcars_model_v1' to Goose memory (category: 'models')
#> ℹ Tags: regression, mtcars, production

# Save analysis results
results <- data.frame(
  metric = c("R²", "RMSE", "MAE"),
  value = c(0.83, 2.54, 2.01)
)
goose_save(results, "model_performance", category = "results")

# List all saved objects
goose_list()
#> ── Goose Memory Objects ──
#> Found 2 objects
#> 
#>              name category   class    size                    tags
#> 1 mtcars_model_v1   models      lm  7.2 Kb regression, mtcars, ...
#> 2 model_performance results data.frame 1.1 Kb                    

# Filter by category
goose_list(category = "models")

# Filter by tags
goose_list(tags = "production")

# Load a saved object
loaded_model <- goose_load("mtcars_model_v1", category = "models")
#> ✔ Loaded 'mtcars_model_v1' from Goose memory

# Use it immediately
summary(loaded_model)
predict(loaded_model, newdata = data.frame(wt = 3.0, hp = 150))
```

### Real-World Example: Model Versioning

```r
library(gooseR)
library(tidyverse)

# Experiment with different models
models <- list(
  simple = lm(mpg ~ wt, data = mtcars),
  complex = lm(mpg ~ wt + hp + cyl + am, data = mtcars),
  interaction = lm(mpg ~ wt * hp, data = mtcars)
)

# Save all models with metadata
iwalk(models, ~{
  goose_save(
    .x,
    name = paste0("mtcars_", .y, "_model"),
    category = "experiments",
    tags = c("mtcars", "regression", .y),
    description = paste("Model variant:", .y)
  )
})

# Later, compare all experimental models
experiment_models <- goose_list(category = "experiments")
print(experiment_models)

# Load the best performing model
best_model <- goose_load("mtcars_complex_model", category = "experiments")
```

### Universal Branding System

```r
library(gooseR)
library(ggplot2)

# Apply Block branding to your visualizations
ggplot(mtcars, aes(x = wt, y = mpg, color = factor(cyl))) +
  geom_point(size = 3) +
  scale_color_manual(values = brand_palette("block", "monochrome")) +
  labs(
    title = "Vehicle Performance Analysis",
    subtitle = "Weight vs Fuel Efficiency",
    caption = "© 2025 Block Inc."
  ) +
  theme_brand("block", variant = "light")  # Light theme with Inter font

# Dark theme variant
ggplot(data, aes(x = quarter, y = revenue)) +
  geom_col(fill = "white") +
  theme_brand("block", variant = "dark")  # Dark theme

# Custom fonts in your brand
# Brands can specify any font (e.g., Inter, Roboto, custom fonts)
# The system will use fallbacks if fonts aren't installed

# Create a new brand for your organization
goose_create_brand("my_company")
#> Enter brand name: My Company
#> Define your brand colors:
#> Primary color (hex, e.g., #0055FF): #2E7D32
#> Primary contrast color (hex, e.g., #FFFFFF): #FFFFFF
#> ...
#> Brand configuration created: ~/.config/goose/brands/my_company/my_company_brand.yaml

# Generate branded RMarkdown template
brand_rmd_template("block", 
                  title = "Q4 2025 Analytics Report",
                  output_file = "report.Rmd")

# Export CSS for web projects
brand_css("block", output_file = "assets/block.css")
```

### Integration with Analysis Workflows

```r
# At the start of your analysis
library(gooseR)
library(tidyverse)

# Load previously saved data
employee_data <- goose_load("employee_survey_2024", category = "datasets")

# Run your analysis
retention_model <- glm(
  attrition ~ tenure + satisfaction + manager_quality,
  data = employee_data,
  family = binomial()
)

# Save results for later or sharing with team
goose_save(
  retention_model,
  name = "retention_model_2024_q4",
  category = "production_models",
  tags = c("attrition", "production", "2024-Q4"),
  description = "Retention model for Q4 2024 - includes manager quality metric"
)

# Save model diagnostics
diagnostics <- data.frame(
  auc = 0.78,
  accuracy = 0.82,
  precision = 0.75,
  recall = 0.71
)
goose_save(diagnostics, "retention_model_2024_q4_diagnostics", 
           category = "model_metrics")
```

## 🎯 Use Cases

### For Data Scientists
- **Model versioning** - Track experiments and compare model performance
- **Reproducibility** - Save intermediate analysis artifacts
- **Collaboration** - Share models and datasets with team members

### For People Analytics
- **Survey analysis** - Store cleaned survey data and analysis results
- **Predictive models** - Version retention, performance, and engagement models
- **Reporting** - Save processed data for recurring reports

### For Research
- **Experiment tracking** - Document analysis iterations
- **Data provenance** - Track data transformations and cleaning steps
- **Publication** - Archive analysis artifacts for reproducibility

## 🗺️ Roadmap

### ✅ v0.1.0 (Phase 1 - Complete)
- [x] Core memory integration (`goose_save`, `goose_load`, `goose_list`, `goose_delete`)
- [x] Tag-based filtering and search
- [x] Metadata tracking
- [x] Global and local memory support

### ✅ v0.2.0 (Phase 2 - Complete)
- [x] Universal branding system (`theme_brand()`, `brand_palette()`)
- [x] Brand configuration in YAML format
- [x] Interactive brand creation (`goose_create_brand()`)
- [x] RMarkdown template generation (`brand_rmd_template()`)
- [x] CSS export for web projects (`brand_css()`)
- [x] Block brand as reference implementation

### 📋 v0.3.0 (Planned)
- [ ] AI-powered code review (`goose_review_code()`)
- [ ] Data validation (`goose_validate_data()`)
- [ ] Automated EDA suggestions (`goose_explore_data()`)

### 🔮 v0.4.0 (Future)
- [ ] Project templates (`goose_init_project()`)
- [ ] Dependency tracking
- [ ] Interactive visualization enhancement

## 🤝 Contributing

gooseR is in active development! Contributions, ideas, and feedback are welcome.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

MIT License - see [LICENSE](LICENSE) file for details

## 🙏 Acknowledgments

- Built for the [Goose AI](https://github.com/block/goose) project by Block
- Inspired by the need for AI-augmented data analysis workflows
- Developed by the People Analytics & Research (PAR) Team at Block

## 📚 Learn More

- [Goose Documentation](https://block.github.io/goose/)
- [Package Documentation](https://blockbtheriault.github.io/gooseR/) (Coming Soon)
- [Example Gallery](https://github.com/blockbtheriault/gooseR/tree/main/examples) (Coming Soon)

---

**Built with 🦆 by [Brandon Theriault](https://github.com/blockbtheriault) at Block**
