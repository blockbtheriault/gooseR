# gooseR Documentation 🦆

Welcome to the gooseR documentation! gooseR brings the power of AI directly into your R workflow.

## 📚 Documentation

### Vignettes (HTML)
Browse our comprehensive guides online:

- [**Getting Started with gooseR**](articles/getting-started.html) - Installation, setup, and first steps
- [**Survey Data Analysis**](articles/survey-data-analysis.html) - Clean survey data with intelligent renaming
- [**Code Review and Testing**](articles/code-review-testing.html) - Get AI-powered code reviews and generate tests
- [**Memory Management and Workflows**](articles/memory-workflow.html) - Save objects and manage workflows
- [**gooseR Overview**](articles/gooseR-overview.html) - Complete feature reference
- [**Use Case Demonstrations**](articles/use-case-demo.html) - Real-world examples

[**📖 Browse All Vignettes**](articles/index.html)

## 🚀 Quick Start

```r
# Install from GitHub
remotes::install_github("blockbtheriault/gooseR")

# Load and test
library(gooseR)
goose_test_cli()

# Your first goose interaction
goose_ask("What can you help me with in R?")
```

## ✨ Key Features

### New in v0.1.1
- 🔍 **Intelligent Code Analysis** - `goose_honk()` reads and understands your actual code
- 📊 **Survey Data Tools** - Transform long questions into clean variable names
- 🎯 **Workflow Functions** - Plan, handoff, and continue your work seamlessly
- 💾 **Enhanced Memory** - Bulk operations, sessions, and team collaboration
- 🎨 **Beautiful Output** - Formatted responses with syntax highlighting

### Core Capabilities
- **Memory System** - Save and retrieve any R object
- **Brand Themes** - Professional visualizations with one line
- **AI Assistant** - Code reviews, documentation, debugging
- **Advanced Runtime** - Streaming, caching, parallel processing
- **IDE Integration** - RStudio/Positron addins

## 📖 Resources

- [GitHub Repository](https://github.com/blockbtheriault/gooseR)
- [Issue Tracker](https://github.com/blockbtheriault/gooseR/issues)
- [Contributing Guide](https://github.com/blockbtheriault/gooseR/blob/main/CONTRIBUTING.md)
- [Learn About Goose](https://block.github.io/goose/docs/quickstart)

## 🎯 For Different Users

### Data Scientists
- Get AI-powered analysis plans
- Clean messy data intelligently
- Generate tests and documentation
- Save models and results with tags

### Survey Researchers  
- Transform Qualtrics exports instantly
- Pattern-based column renaming
- Preserve question mappings
- Focus on analysis, not cleaning

### R Developers
- Context-aware code reviews
- Generate roxygen2 documentation
- Create test suites automatically
- Debug with AI assistance

### Teams
- Share work with handoffs
- Continue colleagues' analyses
- Manage project memory
- Standardize with brand themes

## 💡 Example Workflow

```r
# Load your data
data <- read.csv("survey.csv")

# Clean column names intelligently
clean_data <- goose_rename_columns(data)

# Get analysis guidance
goose_give_sample(clean_data)
plan <- goose_make_a_plan("exploratory")

# Do your analysis
model <- lm(outcome ~ ., data = clean_data)

# Get code review
goose_honk(severity = "moderate")

# Save your work
goose_save(model, category = "models", tags = c("survey", "final"))

# Create handoff
goose_handoff()
```

---

*gooseR v0.1.1 - Making R development more intelligent, one honk at a time!* 🦆
