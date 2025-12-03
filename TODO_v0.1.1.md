# gooseR v0.1.1 Development TODO

**Created**: 2025-12-03 15:31  
**Completed**: 2025-12-03 15:50 ✅  
**Target Release**: After CRAN acceptance of v0.1.0  
**Priority**: HIGH - Memory management improvements  
**Status**: CORE FEATURES COMPLETE  

---

## 🔄 GITHUB SYNCHRONIZATION PROTOCOL (CRITICAL!)

### Daily Workflow
```bash
# START OF EVERY SESSION
cd /Users/btheriault/Documents/R/gooseR
git pull origin main_branch
git status

# DURING WORK
git add .
git commit -m "feat: descriptive message"
git push origin main_branch

# END OF EVERY SESSION
git status  # Should show "nothing to commit, working tree clean"
git push origin main_branch  # Ensure everything is uploaded
```

### GitHub Best Practices
- **Commit frequently**: After each completed function or feature
- **Push immediately**: Don't let local changes accumulate
- **Write clear commit messages**: Use conventional commits (feat:, fix:, docs:, test:)
- **Create GitHub issues**: Track bugs and TODOs as issues
- **Tag versions**: After CRAN acceptance

### Warning Signs You're Out of Sync
- `git status` shows many uncommitted changes
- Last commit was >1 day ago
- GitHub shows different code than local
- Installation from GitHub fails

---

## 🔴 TOP PRIORITY #1: Memory Management Improvements

### 1. Bulk Deletion Functionality
**Problem**: No easy way to delete multiple items at once or clear all data created in a session  
**Solution**: Implement new functions for bulk operations

#### New Functions Needed:
```r
# Delete all items from a category
goose_clear_category(category, confirm = TRUE)

# Delete all items with specific tags
goose_clear_tags(tags, confirm = TRUE)

# Delete all memory (with confirmation)
goose_clear_all(confirm = TRUE)

# Session-based tracking and cleanup
goose_session_start()  # Begin tracking items saved in this session
goose_session_list()   # List items saved in current session
goose_session_clear()  # Delete all items from current session
goose_session_end()    # End session tracking
```

### 2. Session Tracking System
**Problem**: No way to track what data was created within an R script for cleanup  
**Solution**: Implement session-based memory tracking

```r
# Automatic session tagging
goose_save(..., session_tag = getOption("goose.session_id"))

# Script-level cleanup
with_goose_session({
  # All goose_save() calls here are tracked
  goose_save(data1, ...)
  goose_save(data2, ...)
}, cleanup = TRUE)  # Automatically cleans up on exit
```

### 3. Better Attachment Handling
**Problem**: Goose doesn't handle attached data well in conversations  
**Solution**: Create attachment-aware memory functions

```r
# Track and manage attachments
goose_attachment_save(file_path, category = "attachments")
goose_attachment_list()
goose_attachment_clear()
```

---

## 🔴 TOP PRIORITY #2: AI Response Formatting

### Problem
AI responses from `goose_ask()` and similar functions display poorly in R console with escaped newlines, making them nearly unreadable:
```r
# Current ugly output:
"I'll write a review...\\n\\n## GooseR Package Review\\n\\nThe gooseR package..."
```

### Solution: Comprehensive Formatting System

#### New Functions Implemented:
```r
# Core formatting function
format_ai_response(text, width = 80, color = TRUE)

# Enhanced versions of existing functions
goose_ask_formatted(question, format = TRUE, print = TRUE)
goose_review_code_formatted(code, context, format = TRUE)

# Global formatting options
goose_format_options(auto_format = TRUE, width = 80, color = TRUE)

# Enable formatted output for all AI functions
enable_formatted_output(TRUE)
```

#### Features:
- ✅ Clean markdown rendering in console
- ✅ Proper headers, bullets, numbered lists
- ✅ Code block preservation with syntax highlighting
- ✅ Bold/italic text support
- ✅ Line wrapping for readability
- ✅ Optional color output with cli
- ✅ Global settings for all AI responses

#### Example Usage:
```r
# Enable formatting globally
goose_format_options(auto_format = TRUE, width = 100)

# Or use formatted versions
response <- goose_ask_formatted("What is gooseR?")
# Displays beautifully formatted text with headers, bullets, etc.
```

---

## 📦 Dependency Reduction (v0.1.0: 25 → v0.1.1: 11 packages)

### Move to Suggests with Runtime Guards:
- [ ] shiny, miniUI (UI functions)
- [ ] DT (data tables)
- [ ] rstudioapi (IDE integration)
- [ ] future, future.apply, promises, later (async operations)
- [ ] processx (CLI streaming)
- [ ] DBI, RSQLite (cache layer)
- [ ] knitr, markdown, htmltools (documentation only)

### Implementation Pattern:
```r
goose_cache_ui <- function() {
  if (!requireNamespace("shiny", quietly = TRUE)) {
    stop("Package 'shiny' needed for UI functions. Please install it.",
         call. = FALSE)
  }
  # Function code here
}
```

---

## 🎯 Feature Improvements

### Memory System Enhancements
- [x] Add `goose_exists()` to check if item exists ✅
- [x] Add `goose_rename()` to rename saved items ✅
- [ ] Add `goose_copy()` to duplicate items
- [ ] Add `goose_export()` to export memory to file
- [ ] Add `goose_import()` to import memory from file
- [ ] Add memory size tracking and limits
- [ ] Add automatic cleanup of old items (configurable)

### User Experience
- [x] Better error messages with actionable suggestions ✅
- [x] Progress bars for bulk operations ✅
- [ ] Verbose mode for debugging
- [ ] Memory usage statistics dashboard
- [ ] Interactive cleanup wizard

### Documentation
- [ ] Add vignette: "Memory Management Best Practices"
- [ ] Add vignette: "Session-based Workflows"
- [ ] More examples in function documentation
- [ ] Troubleshooting guide

---

## 🐛 Bug Fixes & Polish

### From CRAN Feedback (if any):
- [ ] Address any NOTEs from CRAN review
- [ ] Fix any documentation issues raised
- [ ] Improve examples if requested

### Known Issues:
- [ ] Memory path handling could be more robust
- [ ] Better handling of large objects
- [ ] Improve error recovery in save/load operations
- [ ] Fix any Windows-specific path issues

---

## 🧪 Testing Improvements

### New Tests Needed:
- [ ] Bulk deletion operations
- [ ] Session tracking
- [ ] Memory limits and cleanup
- [ ] Cross-platform path handling
- [ ] Large object handling
- [ ] Concurrent access scenarios

### Test Coverage Goals:
- [ ] Increase coverage to >90%
- [ ] Add integration tests for workflows
- [ ] Add performance benchmarks

---

## 📚 Documentation Updates

### README.md:
- [ ] Add memory management section
- [ ] Add troubleshooting section
- [ ] Update examples with new functions
- [ ] Add performance tips

### NEWS.md for v0.1.1:
```markdown
# gooseR 0.1.1

## Major Improvements
* Added comprehensive memory management functions (#X)
  - `goose_clear_category()` for bulk deletion by category
  - `goose_clear_tags()` for bulk deletion by tags
  - `goose_clear_all()` for complete cleanup
  - Session tracking system for script-level cleanup
* Reduced dependencies from 25 to 11 packages (#X)
* Improved attachment handling (#X)

## New Features
* `goose_session_start/end()` for tracking items within scripts
* `goose_exists()` to check if items exist
* `goose_rename()` to rename saved items
* Memory usage statistics

## Bug Fixes
* Fixed memory path handling issues
* Improved error messages
* Better handling of large objects

## Documentation
* New vignette: "Memory Management Best Practices"
* New vignette: "Session-based Workflows"
* Expanded examples in all functions
```

---

## 🚀 Implementation Plan

### Phase 0: GitHub Synchronization (DAILY)
1. **Start each session**: `git pull origin main_branch`
2. **Regular commits**: Commit working code at least daily
3. **Push frequently**: `git push origin main_branch` after each feature
4. **Check status**: `git status` before ending work
5. **Create issues**: Track TODOs as GitHub issues

### Phase 1: Core Memory Management (Week 1)
1. Implement bulk deletion functions ✅
2. Add session tracking system ✅
3. Write tests for new functions
4. Update documentation
5. **Push to GitHub after completion**

### Phase 2: AI Response Formatting (Week 1)
1. Implement formatting system ✅
2. Integrate with existing functions
3. Add tests and documentation
4. **Push to GitHub after completion**

### Phase 3: Dependency Reduction (Week 1-2)
1. Move packages to Suggests
2. Add runtime guards
3. Test all optional features
4. Update installation instructions
5. **Push to GitHub after completion**

### Phase 4: Polish & Testing (Week 2)
1. Comprehensive testing
2. Documentation updates
3. Performance optimization
4. Cross-platform validation
5. **Final GitHub sync before release**

### Phase 5: Release Preparation
1. **Ensure GitHub is fully up-to-date**
2. Update NEWS.md
3. Run full CRAN checks
4. Test on win-builder and R-hub
5. Submit to CRAN

---

## 📋 Pre-Release Checklist

- [ ] All tests passing locally
- [ ] R CMD check --as-cran: 0 errors, 0 warnings, ≤1 note
- [ ] Win-builder checks pass
- [ ] R-hub checks pass
- [ ] Documentation complete and spell-checked
- [ ] NEWS.md updated
- [ ] Version bumped to 0.1.1
- [ ] GitHub issues closed/referenced
- [ ] README examples work
- [ ] **GitHub repository fully synchronized**

---

## 🎯 Success Metrics

- Memory management functions used in >50% of sessions
- Dependency reduction improves install time by 30%
- User feedback positive on memory cleanup
- No critical bugs reported
- CRAN acceptance on first submission

---

## 📝 Notes

- Keep backward compatibility with v0.1.0
- Consider deprecation warnings for any API changes
- Coordinate with Goose team on attachment handling
- Consider creating a gooseR cheatsheet for memory management
- Plan v0.2.0 features (recipe integration, Positron support)

---

## 🔗 References

- CRAN policies: https://cran.r-project.org/web/packages/policies.html
- Previous TODO: /Users/btheriault/Documents/R/gooseR/v0.1.1_dependency_slimming_plan.md
- Submission notes: /Users/btheriault/Documents/R/gooseR_local/
- GitHub repo: https://github.com/blockbtheriault/gooseR
