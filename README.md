# gooseR 🦆📊

An R package that integrates R with Goose AI, providing a comprehensive toolkit for AI-powered data analysis, visualization, and development assistance.

## Features

### 🧠 AI-Powered Development
- **Code Review & Optimization** - Get instant feedback on your R code
- **Error Debugging** - Understand and fix errors with AI assistance
- **Documentation Generation** - Auto-generate roxygen2 documentation
- **Test Creation** - Generate comprehensive unit tests

### 💾 Smart Memory Integration
- **Persistent Storage** - Save and load R objects with Goose memory
- **Tag-Based Organization** - Organize objects with categories and tags
- **Global/Local Scopes** - Choose between project and system-wide storage

### 🎨 Universal Branding System
- **Dynamic Themes** - Apply consistent branding to all visualizations
- **Block Brand Built-in** - Official Block design system included
- **Light/Dark Modes** - Support for theme variants
- **Export to CSS** - Use your brand across web applications

### ⚡ Advanced AI Features
- **Streaming Responses** - Real-time AI responses for better UX
- **Intelligent Caching** - Speed up repeated queries with SQLite cache
- **Parallel Processing** - Run multiple AI queries simultaneously
- **Template System** - Create reusable prompt templates

## Installation

### Prerequisites
- R version 4.3 or higher
- [Goose CLI](https://github.com/block/goose) installed and configured

### Install from GitHub

```r
# Install devtools if needed
install.packages("devtools")

# Install gooseR
devtools::install_github("blockbtheriault/gooseR")
```

## Quick Start

### 1. Test Your Setup

```r
library(gooseR)

# Test Goose CLI connection - PRIMARY SETUP METHOD
goose_test_cli()

# You should see:
# ✓ Goose CLI found at: /path/to/goose
# ✓ Goose CLI is working!
# ✓ You're ready to use gooseR!
```

### 2. Basic AI Queries

```r
# Ask Goose anything
goose_ask("How do I create a correlation matrix in R?")

# Get code review
my_code <- "for(i in 1:length(x)) { y[i] <- x[i]^2 }"
goose_review_code(my_code, language = "R")

# Debug an error
goose_explain_error("Error: object 'x' not found", 
                    context = "Trying to plot data")
```

### 3. Memory Integration

```r
# Save R objects with Goose memory
my_model <- lm(mpg ~ wt, data = mtcars)
goose_save(my_model, "fuel_efficiency_model", 
           category = "models", 
           tags = c("mtcars", "regression"))

# List saved objects
goose_list(category = "models")

# Load saved objects
model <- goose_load("fuel_efficiency_model")
```

### 4. Beautiful Visualizations with Block Branding

```r
library(ggplot2)

# Create plot with Block theme
ggplot(mtcars, aes(wt, mpg, color = factor(cyl))) +
  geom_point(size = 3) +
  theme_brand("block", variant = "light") +
  scale_color_manual(values = brand_palette("block", "primary"))

# Export brand CSS for web apps
brand_css("block", output = "block_styles.css")
```

### 5. Advanced Features

```r
# Parallel processing
queries <- c(
  "Explain PCA",
  "Explain random forests",
  "Explain neural networks"
)
results <- goose_batch(queries, max_workers = 3)

# Use templates
goose_template_apply("code_review",
  language = "R",
  code = "function(x) mean(x, na.rm = TRUE)",
  focus = "performance and edge cases"
)

# Streaming responses (Phase 4)
goose_stream("Write a detailed data analysis plan")
```

## Phase Status

| Phase | Status | Features |
|-------|--------|----------|
| **Phase 1** | ✅ Complete | Memory Integration |
| **Phase 2** | ✅ Complete | Universal Branding System |
| **Phase 3** | ✅ Complete | CLI Integration & AI Assistant |
| **Phase 4** | ⚠️ Fixed | Streaming, Caching, Async, Templates |
| **Phase 5** | 📋 Planned | IDE Integration |

See [PHASES_STATUS.md](PHASES_STATUS.md) for detailed progress.

## Examples by Phase

### Phase 1: Memory Integration
```r
# Save analysis results
results <- analyze_sales_data()
goose_save(results, "q4_sales_analysis", 
           category = "analysis",
           tags = c("sales", "2025Q4"))

# Load and continue work
analysis <- goose_load("q4_sales_analysis")
```

### Phase 2: Branding
```r
# Create custom brand
goose_create_brand()  # Interactive wizard

# Apply to RMarkdown
brand_rmd_template("my_brand", "report.Rmd")
```

### Phase 3: AI Assistant
```r
# Generate documentation
code <- "calculate_roi <- function(revenue, cost) {
  (revenue - cost) / cost * 100
}"
goose_document(code)

# Optimize visualization
p <- ggplot(data, aes(x, y)) + geom_point()
goose_optimize_plot(p, goal = "publication-ready")
```

### Phase 4: Advanced Features (Testing)
```r
# Cache responses for speed
goose_cached("Explain machine learning", max_age = 86400)

# Async operations
library(promises)
goose_async("Complex analysis") %...>%
  { cat("Result:", .) }
```

## Troubleshooting

### Goose CLI Not Found
```r
# Specify path explicitly
goose_test_cli("/usr/local/bin/goose")

# Or add to PATH in ~/.Rprofile
Sys.setenv(PATH = paste("/usr/local/bin", Sys.getenv("PATH"), sep = ":"))
```

### Missing Dependencies
```r
# Install all dependencies
deps <- c("jsonlite", "R6", "ggplot2", "yaml", "glue",
          "future", "promises", "DBI", "RSQLite", "digest")
install.packages(deps)
```

### Phase 4 Functions Not Working
Phase 4 features require additional setup:
```r
# Install Phase 4 dependencies
install.packages(c("processx", "later", "rappdirs", "future.apply"))

# Test streaming
goose_stream("Hello, streaming world!")
```

## Contributing

This is an internal Block project. For questions or contributions:
- GitHub Issues: [gooseR Issues](https://github.com/blockbtheriault/gooseR/issues)
- Contact: Brandon Theriault (Block People Analytics & Research Team)

## License

MIT License - See [LICENSE](LICENSE) file for details.

## Acknowledgments

- Block People Analytics & Research (PAR) Team
- Goose AI Development Team
- R Community

---

**Current Version:** 0.0.0.9000 (Development)  
**Last Updated:** December 2, 2025  
**Maintainer:** Brandon Theriault (@blockbtheriault)
