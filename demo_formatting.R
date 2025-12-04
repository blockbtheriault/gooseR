#!/usr/bin/env Rscript
# Demo: gooseR Formatting System
# Shows how to handle formatted vs raw output

library(devtools)
load_all()

cat("\n=== gooseR Formatting Demo ===\n\n")

# Example text that would come from goose_ask
example_response <- "## GooseR Package Review

The gooseR package represents a **groundbreaking integration** between R and AI capabilities, seamlessly bridging the gap between traditional statistical computing and modern AI-assisted development.

### Key Features
- Memory management with Goose-compatible metadata
- Universal branding systems with Block themes  
- Advanced AI features like streaming and caching
- Natural language code review and debugging

### Performance Improvements
1. **10-20x speedup** with intelligent caching
2. **95% reduction** in processing time via parallel execution
3. Seamless integration with existing R workflows

The package transforms the R development experience by enabling natural language interactions for code review, error debugging, and visualization optimization.

```r
# Example code
result <- goose_ask('Review my code')
format_ai_response(result)
```

Most impressively, gooseR gives R users an AI pair programmer that understands both their code and their intent."

cat("1. DEFAULT FORMATTED OUTPUT (Beautiful in terminal):\n")
cat("=" , rep("=", 50), "\n", sep = "")
format_ai_response(example_response, width = 70)

cat("\n\n2. RAW TEXT (Ugly in terminal, good for copying):\n")
cat("=" , rep("=", 50), "\n", sep = "")
cat(example_response)

cat("\n\n3. CLEANED TEXT (Removes formatting artifacts):\n")
cat("=" , rep("=", 50), "\n", sep = "")
clean <- goose_clean_text(example_response)
cat(clean)

cat("\n\n4. PLAIN TEXT (No markdown):\n")
cat("=" , rep("=", 50), "\n", sep = "")
plain <- goose_clean_text(example_response, preserve_markdown = FALSE)
cat(plain)

cat("\n\n=== Key Insights ===\n")
cat("
1. Formatted output (format_ai_response):
   ✓ Beautiful in terminal with colors and structure
   ✗ Hard-wrapped lines make copying problematic
   
2. Raw output (cat(response)):
   ✗ Looks plain in terminal
   ✓ Perfect for copying to other applications
   
3. The Solution:
   response <- goose_ask('Question')  # Shows formatted
   cat(response)                      # When you need to copy

4. Or disable formatting when needed:
   response <- goose_ask('Question', format = FALSE)
   
5. Or use the raw function:
   response <- goose_ask_raw('Question')
")

cat("\n=== Demo Complete ===\n\n")
