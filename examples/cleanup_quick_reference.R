#!/usr/bin/env Rscript
# ============================================================================
# gooseR Memory Cleanup - Quick Reference
# ============================================================================

library(gooseR)

# ============================================================================
# BASIC DELETION COMMANDS
# ============================================================================

# 1. Delete a specific item
goose_delete(name = "my_data", category = "analysis")

# 2. See what's saved before deleting
goose_list()  # Shows everything
goose_list(category = "models")  # Shows only models category
goose_list(tags = "test")  # Shows items with "test" tag

# 3. Delete all items in a category
items <- goose_list(category = "temp")
for (i in seq_len(nrow(items))) {
  goose_delete(name = items$name[i], category = "temp")
}

# 4. Delete items with specific tag
items <- goose_list(tags = "old_analysis")
for (i in seq_len(nrow(items))) {
  goose_delete(name = items$name[i], category = items$category[i])
}

# ============================================================================
# USEFUL CLEANUP FUNCTIONS
# ============================================================================

# Quick function to clear a category
clear_category <- function(cat_name) {
  items <- goose_list(category = cat_name)
  if (nrow(items) > 0) {
    for (i in 1:nrow(items)) {
      goose_delete(name = items$name[i], category = cat_name)
    }
    message(sprintf("Deleted %d items from '%s'", nrow(items), cat_name))
  } else {
    message(sprintf("No items found in category '%s'", cat_name))
  }
}

# Quick function to delete by tag
clear_tag <- function(tag_name) {
  items <- goose_list(tags = tag_name)
  if (nrow(items) > 0) {
    for (i in 1:nrow(items)) {
      goose_delete(name = items$name[i], category = items$category[i])
    }
    message(sprintf("Deleted %d items with tag '%s'", nrow(items), tag_name))
  } else {
    message(sprintf("No items found with tag '%s'", tag_name))
  }
}

# Delete everything (use with caution!)
clear_all_goose_memory <- function() {
  items <- goose_list()
  if (nrow(items) > 0) {
    response <- readline("Delete ALL gooseR memory? Type 'YES' to confirm: ")
    if (response == "YES") {
      for (i in 1:nrow(items)) {
        goose_delete(name = items$name[i], category = items$category[i])
      }
      message(sprintf("Deleted all %d items", nrow(items)))
    } else {
      message("Cancelled - no items deleted")
    }
  } else {
    message("No items in memory")
  }
}

# ============================================================================
# COMMON CLEANUP PATTERNS
# ============================================================================

# Pattern 1: Clean up after analysis session
cleanup_session <- function(session_tag) {
  # Delete all items tagged with this session
  clear_tag(session_tag)
}

# Pattern 2: Keep only final results
keep_only_final <- function() {
  # Delete everything without "final" tag
  all_items <- goose_list()
  final_items <- goose_list(tags = "final")
  
  to_delete <- all_items[!all_items$name %in% final_items$name, ]
  
  for (i in seq_len(nrow(to_delete))) {
    goose_delete(name = to_delete$name[i], 
                 category = to_delete$category[i])
  }
  message(sprintf("Kept %d final items, deleted %d others", 
                  nrow(final_items), nrow(to_delete)))
}

# Pattern 3: Clean up old test data
cleanup_tests <- function() {
  clear_tag("test")
  clear_category("test")
  clear_category("temp")
  clear_category("tmp")
  message("Cleaned up test/temp data")
}

# ============================================================================
# EXAMPLES OF USE
# ============================================================================

# Example 1: After experimenting with models
clear_category("experimental_models")

# Example 2: Remove all test data
clear_tag("test")

# Example 3: Start fresh (commented out for safety)
# clear_all_goose_memory()

# Example 4: See what would be deleted
items_to_delete <- goose_list(tags = "draft")
cat("Would delete:", nrow(items_to_delete), "items\n")
print(items_to_delete[, c("name", "category")])

# ============================================================================
# BEST PRACTICES
# ============================================================================

cat("\n📋 CLEANUP BEST PRACTICES:\n")
cat("────────────────────────────\n")
cat("1. Always check with goose_list() before bulk deletion\n")
cat("2. Use meaningful categories and tags for easy cleanup\n")
cat("3. Tag temporary work with 'temp' or 'test'\n")
cat("4. Tag final results with 'final' or 'production'\n")
cat("5. Create session tags for easy cleanup (e.g., 'session_20231203')\n")
cat("6. Regular cleanup prevents memory bloat\n")
cat("\n")

# ============================================================================
# SAFETY TIP: Backup before major cleanup
# ============================================================================

backup_before_cleanup <- function(backup_dir = "goose_backup") {
  if (!dir.exists(backup_dir)) dir.create(backup_dir)
  
  items <- goose_list()
  timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
  
  for (i in seq_len(nrow(items))) {
    obj <- goose_load(name = items$name[i], 
                      category = items$category[i])
    filename <- file.path(backup_dir, 
                          sprintf("%s_%s_%s.rds", 
                                  timestamp,
                                  items$category[i],
                                  items$name[i]))
    saveRDS(obj, filename)
  }
  message(sprintf("Backed up %d items to %s/", nrow(items), backup_dir))
}

# Use before major cleanup:
# backup_before_cleanup()
# clear_all_goose_memory()

cat("✅ Quick reference loaded! Key functions:\n")
cat("  • goose_delete(name, category) - Delete one item\n")
cat("  • clear_category(cat_name) - Clear entire category\n")
cat("  • clear_tag(tag_name) - Delete items with tag\n")
cat("  • clear_all_goose_memory() - Delete everything (careful!)\n")
cat("  • backup_before_cleanup() - Save backup before cleanup\n")
