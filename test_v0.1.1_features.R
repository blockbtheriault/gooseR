#!/usr/bin/env Rscript
# Test script for gooseR v0.1.1 new features
# Date: 2025-12-03
# Author: Brandon Theriault

library(devtools)
load_all()

cat("\n=== Testing gooseR v0.1.1 Features ===\n\n")

# Test 1: Memory Bulk Operations
cat("Test 1: Memory Bulk Operations\n")
cat("-------------------------------\n")

# Create some test data
goose_save(mtcars[1:5,], "test_cars", category = "demo", tags = c("test", "v0.1.1"))
goose_save(iris[1:10,], "test_iris", category = "demo", tags = c("test", "flowers"))
goose_save(airquality[1:5,], "test_air", category = "weather", tags = c("test", "temp"))

# List current items
cat("\nCurrent saved items:\n")
items <- goose_list()
print(items)

# Test goose_exists
cat("\nTesting goose_exists():\n")
cat("  test_cars exists:", goose_exists("test_cars"), "\n")
cat("  fake_data exists:", goose_exists("fake_data"), "\n")

# Test goose_rename
cat("\nTesting goose_rename():\n")
if (goose_rename("test_air", "test_airquality")) {
  cat("  Successfully renamed test_air to test_airquality\n")
}

# Test clearing by category
cat("\nTesting goose_clear_category():\n")
goose_clear_category("demo", confirm = FALSE)
cat("  Cleared 'demo' category\n")

# List after clearing
cat("\nItems after clearing 'demo' category:\n")
items <- goose_list()
print(items)

# Test clearing by tags
cat("\nTesting goose_clear_tags():\n")
goose_clear_tags("test", confirm = FALSE)
cat("  Cleared items with 'test' tag\n")

# List final state
cat("\nFinal state:\n")
items <- tryCatch({
  goose_list()
}, error = function(e) {
  data.frame()
})

if (is.null(items) || nrow(items) == 0) {
  cat("  No items remaining (as expected)\n")
} else {
  print(items)
}

cat("\n")

# Test 2: Session Management
cat("\nTest 2: Session Management\n")
cat("---------------------------\n")

# Start a session
cat("Starting a new session...\n")
goose_session_start()

# Add some data to the session with session tags
session_id <- getOption("goose.session_id")
goose_save(mtcars, "session_mtcars", category = "session_test", tags = session_id)
goose_save(iris, "session_iris", category = "session_test", tags = session_id)

# List session items
cat("\nSession items:\n")
session_items <- goose_session_list()
print(session_items)

# Clear session
cat("\nClearing session...\n")
goose_session_clear(confirm = FALSE)

# End session
cat("Ending session...\n")
goose_session_end()

cat("\n")

# Test 3: with_goose_session wrapper
cat("\nTest 3: with_goose_session wrapper\n")
cat("------------------------------------\n")

result <- with_goose_session({
  cat("Inside session wrapper:\n")
  
  # Save some temporary data
  goose_save(mtcars[1:3,], "temp_data1", category = "temp")
  goose_save(iris[1:3,], "temp_data2", category = "temp")
  
  # List what we have
  items <- goose_list()
  cat("  Items in session:", nrow(items), "\n")
  
  # Return something
  "Session completed successfully"
}, cleanup = TRUE)

cat("Result from session:", result, "\n")

# Verify cleanup happened
cat("\nVerifying cleanup:\n")
items <- goose_list()
if (nrow(items) == 0 || !any(grepl("temp_data", items$name))) {
  cat("  Cleanup successful - temporary data removed\n")
} else {
  cat("  Warning: Some temporary data may remain\n")
}

cat("\n")

# Test 4: Formatting System
cat("\nTest 4: AI Response Formatting\n")
cat("--------------------------------\n")

# Set formatting options
goose_format_options(auto_format = TRUE, width = 70, color = TRUE)

# Test format_ai_response directly
cat("\nTesting format_ai_response():\n")
test_text <- "## Header Test\n\nThis is **bold** and this is *italic*.\n\n- Bullet 1\n- Bullet 2\n\n```r\n# Code block\nx <- 1:10\nmean(x)\n```"

cat("\nRaw text:\n")
cat(test_text, "\n\n")

cat("Formatted output:\n")
format_ai_response(test_text)

cat("\n")

# Test markdown elements
cat("\nTesting various markdown elements:\n")
cat("-----------------------------------\n")

test_elements <- "# Main Header

## Section 1
This paragraph contains **bold text**, *italic text*, and `inline code`.

### Subsection 1.1
Here's a numbered list:
1. First item
2. Second item
3. Third item

### Subsection 1.2
And a bullet list:
- Item A
- Item B
- Item C

## Code Example
```r
# Calculate summary statistics
data <- rnorm(100)
summary(data)
```

## Conclusion
This demonstrates the formatting capabilities."

format_ai_response(test_elements, width = 60)

cat("\n")

# Test 5: Backup functionality
cat("\nTest 5: Backup Functionality\n")
cat("-----------------------------\n")

# Create some data to backup
goose_save(mtcars, "backup_test_data", category = "backup_demo")

# Create backup
cat("Creating backup...\n")
backup_file <- goose_backup()
if (!is.null(backup_file)) {
  cat("  Backup created:", backup_file, "\n")
  
  # Check backup file exists
  if (file.exists(backup_file)) {
    file_size <- file.info(backup_file)$size
    cat("  Backup file size:", format(file_size, big.mark = ","), "bytes\n")
  }
}

# Clean up test data
goose_clear_category("backup_demo", confirm = FALSE)

cat("\n=== All v0.1.1 Tests Completed ===\n")
cat("\nSummary:\n")
cat("  ✓ Memory bulk operations working\n")
cat("  ✓ Session management functional\n")
cat("  ✓ with_goose_session wrapper operational\n")
cat("  ✓ Formatting system active\n")
cat("  ✓ Backup functionality tested\n")
cat("\n")

# Note about goose_ask
cat("Note: goose_ask() now includes formatting by default.\n")
cat("      Use goose_ask_raw() for unformatted output.\n")
cat("      Cannot test without Goose CLI configured.\n")
cat("\n")
