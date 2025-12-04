# gooseR Formatting Guide

## The Problem
Beautiful formatted output in the terminal becomes ugly when copied/pasted due to:
- Hard line wraps at 80 characters
- Extra spacing and indentation
- CLI formatting artifacts
- ANSI color codes

## Solutions

### 🎯 Best Practice: Capture Raw, Display Formatted

```r
# Capture the raw response (invisible return)
response <- goose_ask("Review the gooseR package")
# Response is displayed beautifully in terminal

# Later, when you need to copy it:
cat(response)  # Raw text, perfect for copying

# Or save to file:
writeLines(response, "review.txt")
```

### 📋 Method 1: Control Formatting Per Call

```r
# Beautiful display (default)
goose_ask("What is R?")

# Raw output for copying
goose_ask("What is R?", format = FALSE)

# Or use the explicit raw function
goose_ask_raw("What is R?")
```

### 🔄 Method 2: Toggle Global Formatting

```r
# Turn off formatting globally
goose_format_options(auto_format = FALSE)

# Now all responses are raw by default
response <- goose_ask("Explain ggplot2")

# Turn formatting back on
goose_format_options(auto_format = TRUE)
```

### 📝 Method 3: Clean Text After Formatting

```r
# Get formatted response
response <- goose_ask("Review my code")

# Clean it for copying
clean <- goose_clean_text(response)
cat(clean)

# Remove markdown too if needed
plain <- goose_clean_text(response, preserve_markdown = FALSE)
```

### 💾 Method 4: Save Both Versions

```r
# Function to get both formats
goose_ask_both <- function(prompt) {
  raw <- goose_ask(prompt, format = FALSE)
  cat("\n=== FORMATTED VIEW ===\n")
  format_ai_response(raw)
  cat("\n=== COPY-FRIENDLY VERSION ===\n")
  cat(raw)
  invisible(list(raw = raw, formatted = raw))
}

# Use it
result <- goose_ask_both("What is tidyverse?")
```

### 🎨 Method 5: Adjust Formatting Width

```r
# Wider formatting (less wrapping)
goose_format_options(width = 120)

# Or per-call
goose_ask("Explain dplyr", width = 100)

# No wrapping (one long line)
goose_ask("Explain dplyr", width = Inf)
```

## Recommended Workflows

### For Analysis Scripts
```r
# At the top of your script
library(gooseR)

# Capture responses for later use
analysis_review <- goose_ask("Review this analysis approach", format = FALSE)

# Display nicely when needed
format_ai_response(analysis_review)

# Save to documentation
writeLines(analysis_review, "analysis_notes.md")
```

### For Interactive Sessions
```r
# Keep formatting on for readability
goose_format_options(auto_format = TRUE, width = 100)

# When you need to copy something:
response <- goose_ask("Generate SQL query")  # Shows formatted
cat(response)  # Show raw for copying
```

### For Reports/Documentation
```r
# Always capture raw
intro <- goose_ask("Write introduction for my report", format = FALSE)
methods <- goose_ask("Describe this methodology", format = FALSE)
conclusion <- goose_ask("Summarize findings", format = FALSE)

# Combine into document
report <- c(intro, "\n\n", methods, "\n\n", conclusion)
writeLines(report, "report.md")
```

## Quick Reference

| Need | Solution | Code |
|------|----------|------|
| Beautiful display | Default behavior | `goose_ask("...")` |
| Copy-friendly text | Disable formatting | `goose_ask("...", format = FALSE)` |
| Raw always | Use raw function | `goose_ask_raw("...")` |
| Clean up formatted | Remove artifacts | `goose_clean_text(response)` |
| Both formats | Capture invisibly | `r <- goose_ask("..."); cat(r)` |
| Wider display | Adjust width | `goose_ask("...", width = 120)` |
| No colors | Disable colors | `goose_format_options(color = FALSE)` |

## Understanding the Return Value

```r
# When format = TRUE (default):
response <- goose_ask("Hello")
# - Displays formatted output to console
# - Returns raw text INVISIBLY
# - response variable contains raw text

# When format = FALSE:
response <- goose_ask("Hello", format = FALSE)
# - No display to console
# - Returns raw text VISIBLY
# - response variable contains raw text

# Both give you the same raw text in 'response'!
```

## Tips

1. **Default is good for reading** - Keep formatting on for interactive work
2. **Capture for copying** - Store responses in variables when you need to copy
3. **Use `cat()`** - Shows raw text without R's string escaping
4. **Adjust width** - Set wider for less wrapping: `width = 120`
5. **Save important responses** - `writeLines(response, "file.txt")`

## Example: Complete Workflow

```r
library(gooseR)

# Configure for your screen
goose_format_options(
  auto_format = TRUE,  # Beautiful by default
  width = 100,         # Wider for modern screens
  color = TRUE         # Colors if your terminal supports it
)

# Interactive work - beautiful display
goose_ask("What are the best practices for ggplot2?")

# Need to copy something - capture it
query <- goose_ask("Generate a complex SQL query")
# It displays beautifully...

# Now copy the raw version
cat(query)  # Perfect for pasting into SQL editor

# Save for documentation
writeLines(query, "queries/complex_join.sql")

# Quick review without formatting
goose_ask_raw("Is this query efficient?")
```

## Summary

The new formatting system gives you the best of both worlds:
- **Beautiful, readable output** in the terminal by default
- **Clean, copyable text** always available via the invisible return value
- **Full control** when you need it

The key insight: `goose_ask()` always returns the raw text - formatting only affects the display!
