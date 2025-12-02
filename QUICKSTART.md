# gooseR Quick Start Guide 🦆

Welcome to gooseR! This guide will get you up and running in 5 minutes.

## Installation

```r
# Install from GitHub
devtools::install_github("blockbtheriault/gooseR")

# Load the package
library(gooseR)
```

## Your First gooseR Session

### 1. Save an R Object

```r
# Create a simple model
model <- lm(mpg ~ wt + hp, data = mtcars)

# Save it to Goose memory
goose_save(
  model,
  name = "my_first_model",
  category = "models",
  tags = c("regression", "tutorial"),
  description = "My first gooseR model"
)
```

**Output:**
```
✔ Saved 'my_first_model' to Goose memory (category: 'models')
ℹ Tags: regression, tutorial
```

### 2. List Your Saved Objects

```r
# See all saved objects
goose_list()
```

**Output:**
```
── Goose Memory Objects ──
Found 1 object

           name category class   size              tags
1 my_first_model   models    lm 7.2 Kb regression, tutorial
```

### 3. Load an Object

```r
# Load your model back
loaded_model <- goose_load("my_first_model", category = "models")

# Use it immediately
summary(loaded_model)
predict(loaded_model, newdata = data.frame(wt = 3.0, hp = 150))
```

**Output:**
```
✔ Loaded 'my_first_model' from Goose memory
```

## Common Workflows

### Model Versioning

```r
# Save different versions
goose_save(model_v1, "model_v1", category = "experiments", tags = "v1")
goose_save(model_v2, "model_v2", category = "experiments", tags = "v2")
goose_save(model_v3, "model_v3", category = "experiments", tags = c("v3", "production"))

# List all experiments
goose_list(category = "experiments")

# Filter for production models
goose_list(tags = "production")
```

### Saving Analysis Results

```r
# Save your analysis results
results <- data.frame(
  metric = c("RMSE", "MAE", "R²"),
  value = c(2.54, 2.01, 0.83)
)

goose_save(
  results,
  name = "model_performance_2024_q4",
  category = "results",
  tags = c("metrics", "2024-Q4")
)
```

### Complex Objects

```r
# Save a complete analysis bundle
analysis <- list(
  model = trained_model,
  data = processed_data,
  predictions = predictions,
  metrics = performance_metrics,
  metadata = list(
    date = Sys.Date(),
    analyst = "Brandon Theriault",
    purpose = "Q4 2024 retention analysis"
  )
)

goose_save(
  analysis,
  name = "retention_analysis_2024_q4",
  category = "analysis_bundles",
  tags = c("complete", "production", "retention")
)
```

## Key Functions

| Function | Purpose | Example |
|----------|---------|---------|
| `goose_save()` | Save R objects to memory | `goose_save(model, "name", category = "models")` |
| `goose_load()` | Load saved objects | `goose_load("name", category = "models")` |
| `goose_list()` | List all saved objects | `goose_list(category = "models")` |
| `goose_delete()` | Delete saved objects | `goose_delete("name", category = "models")` |

## Filtering & Search

```r
# List by category
goose_list(category = "models")

# Filter by tags
goose_list(tags = "production")

# Filter by multiple tags
goose_list(tags = c("production", "2024"))
```

## Best Practices

### 1. Use Descriptive Names
```r
# ✅ Good
goose_save(model, "retention_model_2024_q4", ...)

# ❌ Avoid
goose_save(model, "model1", ...)
```

### 2. Organize with Categories
```r
# Use consistent categories
category = "models"           # For trained models
category = "datasets"         # For processed data
category = "results"          # For analysis results
category = "analysis_bundles" # For complete analyses
```

### 3. Tag Everything
```r
# Tags make searching easy
tags = c("production", "2024-Q4", "retention", "active")
```

### 4. Add Descriptions
```r
# Future you will thank present you
description = "Production retention model trained on Q4 2024 data, includes manager quality metric"
```

## Tips & Tricks

### Check What's Stored
```r
# See everything in Goose memory
goose_list()

# Count objects by category
all_objects <- goose_list()
table(all_objects$category)
```

### Clean Up Old Objects
```r
# Delete objects you no longer need
goose_delete("old_model", category = "experiments", confirm = FALSE)
```

### Global vs Local Storage
```r
# Save to global memory (default)
goose_save(model, "name", global = TRUE)

# Save to project-local memory
goose_save(model, "name", global = FALSE)
```

## Example: Complete Analysis Workflow

```r
library(gooseR)
library(tidyverse)

# 1. Load data (or use your own)
data <- mtcars

# 2. Train model
model <- lm(mpg ~ wt + hp + cyl, data = data)

# 3. Save model
goose_save(
  model,
  name = "mpg_predictor_v1",
  category = "models",
  tags = c("production", "v1"),
  description = "Production MPG predictor"
)

# 4. Generate predictions
predictions <- predict(model, data)

# 5. Calculate metrics
metrics <- data.frame(
  rmse = sqrt(mean((data$mpg - predictions)^2)),
  mae = mean(abs(data$mpg - predictions)),
  r_squared = summary(model)$r.squared
)

# 6. Save metrics
goose_save(
  metrics,
  name = "mpg_predictor_v1_metrics",
  category = "results",
  tags = c("metrics", "v1")
)

# 7. List everything
goose_list()
```

## Getting Help

```r
# Function documentation
?goose_save
?goose_load
?goose_list

# Package documentation
?gooseR

# Run the demo
source(system.file("demo", "memory_demo.R", package = "gooseR"))
```

## Next Steps

1. **Try it yourself** - Save some of your own models and data
2. **Explore the demo** - Run `/demo/memory_demo.R` for comprehensive examples
3. **Read the README** - Check out `README.md` for more details
4. **Stay tuned** - Phase 2 (visualization enhancement) coming soon!

## Need Help?

- 📖 [Full Documentation](https://github.com/blockbtheriault/gooseR)
- 🐛 [Report Issues](https://github.com/blockbtheriault/gooseR/issues)
- 💬 Ask Goose! (You're already using it!)

---

**Happy analyzing with gooseR! 🦆**
