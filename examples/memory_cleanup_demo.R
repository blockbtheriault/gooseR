#!/usr/bin/env Rscript
# ============================================================================
# gooseR Memory Cleanup: How to Delete Saved Items
# ============================================================================

library(gooseR)

# ============================================================================
# SETUP: First, let's save some example items
# ============================================================================

# Save some test data
goose_save(mtcars, "mtcars_data", category = "demo", tags = c("cars", "test"))
goose_save(iris, "iris_data", category = "demo", tags = c("flowers", "test"))
goose_save(lm(mpg ~ wt, data = mtcars), "test_model", category = "models")
goose_save(list(a = 1, b = 2), "test_list", category = "misc")

cat("✅ Saved 4 test items\n\n")

# ============================================================================
# METHOD 1: Delete a specific item by name and category
# ============================================================================

cat("📍 Method 1: Delete specific item\n")
cat("Before deletion:\n")
print(goose_list())

# Delete one specific item
goose_delete(name = "iris_data", category = "demo")
cat("\n✅ Deleted 'iris_data' from category 'demo'\n")

cat("\nAfter deletion:\n")
print(goose_list())
cat("\n")

# ============================================================================
# METHOD 2: Delete multiple items programmatically
# ============================================================================

cat("📍 Method 2: Delete multiple items\n")

# Get all items with "test" tag
test_items <- goose_list(tags = "test")
cat("Items with 'test' tag:\n")
print(test_items)

# Delete each one
if (nrow(test_items) > 0) {
  for (i in 1:nrow(test_items)) {
    goose_delete(
      name = test_items$name[i], 
      category = test_items$category[i]
    )
    cat(sprintf("Deleted: %s from %s\n", 
                test_items$name[i], 
                test_items$category[i]))
  }
}
cat("\n")

# ============================================================================
# METHOD 3: Delete all items in a category
# ============================================================================

cat("📍 Method 3: Delete entire category\n")

# First, save some items to a category
goose_save(1:10, "data1", category = "temp_work")
goose_save(letters, "data2", category = "temp_work")
goose_save(mtcars, "data3", category = "temp_work")

cat("Items in 'temp_work' category:\n")
print(goose_list(category = "temp_work"))

# Delete all items in the category
temp_items <- goose_list(category = "temp_work")
if (nrow(temp_items) > 0) {
  for (i in 1:nrow(temp_items)) {
    goose_delete(name = temp_items$name[i], category = "temp_work")
  }
  cat("\n✅ Deleted all items from 'temp_work' category\n")
}
cat("\n")

# ============================================================================
# METHOD 4: Clear everything (nuclear option)
# ============================================================================

cat("📍 Method 4: Clear ALL gooseR memory (commented out for safety)\n")

# UNCOMMENT THESE LINES TO DELETE EVERYTHING:
# all_items <- goose_list()
# if (nrow(all_items) > 0) {
#   for (i in 1:nrow(all_items)) {
#     goose_delete(name = all_items$name[i], 
#                  category = all_items$category[i])
#   }
#   cat("✅ Deleted all items from gooseR memory\n")
# }

cat("To delete everything, uncomment the code above\n\n")

# ============================================================================
# METHOD 5: Create helper functions for common cleanup tasks
# ============================================================================

cat("📍 Method 5: Helper functions for cleanup\n")

# Function to delete items by tag
delete_by_tag <- function(tag) {
  items <- goose_list(tags = tag)
  if (nrow(items) == 0) {
    cat(sprintf("No items found with tag '%s'\n", tag))
    return(invisible(0))
  }
  
  count <- 0
  for (i in 1:nrow(items)) {
    goose_delete(name = items$name[i], category = items$category[i])
    count <- count + 1
  }
  cat(sprintf("Deleted %d items with tag '%s'\n", count, tag))
  invisible(count)
}

# Function to delete items older than a certain date
delete_old_items <- function(days_old = 30) {
  all_items <- goose_list()
  if (nrow(all_items) == 0) return(invisible(0))
  
  # Parse the saved dates (assuming they're in the metadata)
  cutoff_date <- Sys.Date() - days_old
  count <- 0
  
  for (i in 1:nrow(all_items)) {
    # Check if item is old (this is pseudo-code, actual implementation 
    # depends on how dates are stored in metadata)
    item_date <- as.Date(all_items$saved[i])
    if (!is.na(item_date) && item_date < cutoff_date) {
      goose_delete(name = all_items$name[i], 
                   category = all_items$category[i])
      count <- count + 1
    }
  }
  cat(sprintf("Deleted %d items older than %d days\n", count, days_old))
  invisible(count)
}

# Function to clear a specific category
clear_category <- function(category_name) {
  items <- goose_list(category = category_name)
  if (nrow(items) == 0) {
    cat(sprintf("No items found in category '%s'\n", category_name))
    return(invisible(0))
  }
  
  count <- nrow(items)
  for (i in 1:count) {
    goose_delete(name = items$name[i], category = category_name)
  }
  cat(sprintf("Deleted %d items from category '%s'\n", count, category_name))
  invisible(count)
}

# Function to keep only recent items
keep_only_recent <- function(n = 10) {
  all_items <- goose_list()
  if (nrow(all_items) <= n) {
    cat(sprintf("Only %d items in memory, keeping all\n", nrow(all_items)))
    return(invisible(0))
  }
  
  # Sort by saved date (newest first)
  all_items <- all_items[order(all_items$saved, decreasing = TRUE), ]
  
  # Delete older items
  to_delete <- all_items[(n+1):nrow(all_items), ]
  count <- 0
  for (i in 1:nrow(to_delete)) {
    goose_delete(name = to_delete$name[i], 
                 category = to_delete$category[i])
    count <- count + 1
  }
  cat(sprintf("Deleted %d older items, kept %d most recent\n", count, n))
  invisible(count)
}

# Test the helper functions
cat("\nTesting helper functions:\n")

# Save some test items with tags
goose_save(1:5, "test1", category = "demo", tags = c("cleanup_test"))
goose_save(6:10, "test2", category = "demo", tags = c("cleanup_test"))

# Delete by tag
delete_by_tag("cleanup_test")

cat("\n")

# ============================================================================
# METHOD 6: Interactive cleanup with confirmation
# ============================================================================

cat("📍 Method 6: Interactive cleanup function\n")

interactive_cleanup <- function() {
  items <- goose_list()
  if (nrow(items) == 0) {
    cat("No items to delete\n")
    return(invisible(0))
  }
  
  cat("Current items in memory:\n")
  print(items)
  
  cat("\nOptions:\n")
  cat("1. Delete specific item by number\n")
  cat("2. Delete by category\n")
  cat("3. Delete by tag\n")
  cat("4. Delete all\n")
  cat("5. Cancel\n")
  
  choice <- readline("Enter choice (1-5): ")
  
  if (choice == "1") {
    num <- as.integer(readline("Enter item number to delete: "))
    if (num > 0 && num <= nrow(items)) {
      goose_delete(name = items$name[num], 
                   category = items$category[num])
      cat(sprintf("Deleted: %s\n", items$name[num]))
    }
  } else if (choice == "2") {
    cat_name <- readline("Enter category name: ")
    clear_category(cat_name)
  } else if (choice == "3") {
    tag_name <- readline("Enter tag name: ")
    delete_by_tag(tag_name)
  } else if (choice == "4") {
    confirm <- readline("Delete ALL items? (yes/no): ")
    if (tolower(confirm) == "yes") {
      for (i in 1:nrow(items)) {
        goose_delete(name = items$name[i], 
                     category = items$category[i])
      }
      cat("All items deleted\n")
    }
  } else {
    cat("Cancelled\n")
  }
}

# To run interactively (commented out for demo):
# interactive_cleanup()

cat("To run interactive cleanup, call: interactive_cleanup()\n\n")

# ============================================================================
# FINAL STATUS
# ============================================================================

cat("📊 Final memory status:\n")
remaining <- goose_list()
if (nrow(remaining) > 0) {
  print(remaining)
} else {
  cat("No items in gooseR memory\n")
}

cat("\n✨ Cleanup demo complete!\n")
cat("\n📝 Summary of deletion methods:\n")
cat("  • goose_delete(name, category) - Delete specific item\n")
cat("  • Loop through goose_list() results - Delete multiple items\n")
cat("  • delete_by_tag() - Custom function to delete by tag\n")
cat("  • clear_category() - Custom function to clear category\n")
cat("  • interactive_cleanup() - Interactive deletion with menu\n")
