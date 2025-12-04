# gooseR Essential Functions
# Advanced utilities for seamless R-Goose integration
# Version: 0.1.1
# Date: 2025-12-03

#' Share R Object Structure with Goose
#'
#' @description
#' Captures the structure and sample values of an R object and saves it
#' in a format that Goose can understand and reference when providing code.
#' This enables Goose to write accurate code that references actual column names
#' and understands data types.
#'
#' @param object An R object (data.frame, matrix, tibble, list, etc.)
#' @param name Optional custom name for the object. Defaults to the object's name.
#' @param rows Number of sample rows to include (default: 5)
#' @param save_to_memory Whether to save to Goose memory (default: TRUE)
#'
#' @return Invisible NULL. Prints object summary and saves to memory.
#'
#' @examples
#' \dontrun{
#' # Share a data frame with Goose
#' goose_give_sample(mtcars)
#' 
#' # Share with custom name
#' goose_give_sample(iris, "flower_data")
#' 
#' # Share just structure without saving
#' goose_give_sample(my_model, save_to_memory = FALSE)
#' }
#'
#' @export
goose_give_sample <- function(object, 
                             name = NULL, 
                             rows = 5,
                             save_to_memory = TRUE) {
  
  # Get object name if not provided
  if (is.null(name)) {
    name <- deparse(substitute(object))
  }
  
  # Create comprehensive object summary
  summary_list <- list(
    name = name,
    class = class(object),
    dimensions = dim(object),
    size = format(object.size(object), units = "auto"),
    timestamp = Sys.time()
  )
  
  # Handle different object types
  if (is.data.frame(object) || is.matrix(object)) {
    summary_list$columns <- colnames(object)
    summary_list$column_types <- sapply(object, class)
    summary_list$sample_data <- utils::head(object, rows)
    summary_list$summary_stats <- summary(object)
    summary_list$missing_values <- colSums(is.na(object))
  } else if (is.list(object)) {
    summary_list$structure <- utils::str(object, max.level = 2)
    summary_list$names <- names(object)
    summary_list$element_types <- sapply(object, class)
  } else if (inherits(object, "lm") || inherits(object, "glm")) {
    summary_list$model_summary <- summary(object)
    summary_list$coefficients <- coef(object)
    summary_list$formula <- formula(object)
  } else {
    summary_list$structure <- utils::str(object)
  }
  
  # Format output for display
  cat("\n", cli::style_bold(cli::col_blue("📊 Object Shared with Goose")), "\n")
  cat(rep("─", 50), "\n", sep = "")
  cat("Name:", cli::col_green(name), "\n")
  cat("Class:", paste(summary_list$class, collapse = ", "), "\n")
  
  if (!is.null(summary_list$dimensions)) {
    cat("Dimensions:", paste(summary_list$dimensions, collapse = " x "), "\n")
  }
  cat("Size:", summary_list$size, "\n")
  
  if (!is.null(summary_list$columns)) {
    cat("\n", cli::style_bold("Columns:"), "\n")
    col_info <- data.frame(
      Column = summary_list$columns,
      Type = as.character(summary_list$column_types),
      Missing = summary_list$missing_values
    )
    print(col_info, row.names = FALSE)
    
    cat("\n", cli::style_bold("Sample Data:"), "\n")
    print(summary_list$sample_data)
  }
  
  # Save to memory if requested
  if (save_to_memory) {
    memory_data <- paste0(
      "R_OBJECT_STRUCTURE: ", name, "\n",
      "CLASS: ", paste(summary_list$class, collapse = ", "), "\n",
      "SIZE: ", summary_list$size, "\n",
      if (!is.null(summary_list$columns)) {
        paste0("COLUMNS: ", paste(summary_list$columns, collapse = ", "), "\n",
               "TYPES: ", paste(summary_list$column_types, collapse = ", "))
      } else {
        paste0("STRUCTURE: ", capture.output(str(object, max.level = 1)))
      }
    )
    
    tryCatch({
      goose_save(object, name, 
                category = "shared_objects",
                tags = c("structure", "reference"),
                description = paste("Object structure shared for code generation"))
      cli::cli_alert_success("Object structure saved to Goose memory")
    }, error = function(e) {
      cli::cli_alert_warning("Could not save to memory: {e$message}")
    })
  }
  
  invisible(summary_list)
}

#' Generate Analysis Plan from Shared Objects
#'
#' @description
#' Reviews all objects shared in the current session and generates
#' a comprehensive, phased analysis plan with specific recommendations.
#'
#' @param focus Optional focus area: "exploratory", "predictive", "descriptive", "diagnostic"
#' @param output_format Format for the plan: "console", "markdown", "html"
#'
#' @return Analysis plan as text or formatted output
#'
#' @examples
#' \dontrun{
#' # Generate comprehensive plan
#' goose_make_a_plan()
#' 
#' # Focus on predictive modeling
#' goose_make_a_plan(focus = "predictive")
#' 
#' # Save plan as markdown
#' goose_make_a_plan(output_format = "markdown")
#' }
#'
#' @export
goose_make_a_plan <- function(focus = NULL, 
                              output_format = "console") {
  
  cli::cli_h1("🦆 Goose Analysis Planner")
  
  # Get all shared objects from memory
  shared_objects <- tryCatch({
    goose_list(category = "shared_objects", global = FALSE)
  }, error = function(e) {
    cli::cli_alert_warning("No shared objects found. Use goose_give_sample() first.")
    return(NULL)
  })
  
  if (is.null(shared_objects) || length(shared_objects) == 0) {
    cat("No objects have been shared yet.\n")
    cat("Use goose_give_sample() to share data with Goose.\n")
    return(invisible(NULL))
  }
  
  # Build analysis plan
  plan <- list(
    timestamp = Sys.time(),
    objects = shared_objects,
    focus = focus %||% "comprehensive"
  )
  
  # Generate plan sections
  plan_text <- c(
    "# 📊 Data Analysis Plan",
    paste0("Generated: ", format(plan$timestamp, "%Y-%m-%d %H:%M:%S")),
    "",
    "## 📁 Available Objects",
    paste0("- ", names(shared_objects)),
    "",
    "## 🎯 Phase 1: Data Understanding",
    "- [ ] Explore data structure and types",
    "- [ ] Check for missing values and outliers",
    "- [ ] Generate summary statistics",
    "- [ ] Create initial visualizations",
    "",
    "## 🔍 Phase 2: Data Quality",
    "- [ ] Identify data quality issues",
    "- [ ] Handle missing values",
    "- [ ] Detect and handle outliers",
    "- [ ] Validate data consistency",
    "",
    "## 📈 Phase 3: Exploratory Analysis",
    "- [ ] Univariate analysis",
    "- [ ] Bivariate relationships",
    "- [ ] Correlation analysis",
    "- [ ] Feature importance"
  )
  
  # Add focus-specific sections
  if (!is.null(focus)) {
    if (focus == "predictive") {
      plan_text <- c(plan_text,
        "",
        "## 🤖 Phase 4: Predictive Modeling",
        "- [ ] Feature engineering",
        "- [ ] Train/test split",
        "- [ ] Model selection",
        "- [ ] Model evaluation",
        "- [ ] Hyperparameter tuning"
      )
    } else if (focus == "diagnostic") {
      plan_text <- c(plan_text,
        "",
        "## 🔬 Phase 4: Diagnostic Analysis",
        "- [ ] Root cause analysis",
        "- [ ] Hypothesis testing",
        "- [ ] Causal inference",
        "- [ ] Sensitivity analysis"
      )
    }
  }
  
  plan_text <- c(plan_text,
    "",
    "## 📋 Phase 5: Reporting",
    "- [ ] Create executive summary",
    "- [ ] Generate visualizations",
    "- [ ] Document methodology",
    "- [ ] Prepare recommendations",
    "",
    "## 💡 Suggested Next Steps",
    "1. Run `goose_give_sample()` on additional datasets",
    "2. Use `goose_ask()` for specific analysis questions",
    "3. Use `goose_honk()` to review and improve your approach"
  )
  
  # Output based on format
  if (output_format == "console") {
    cat(paste(plan_text, collapse = "\n"))
  } else if (output_format == "markdown") {
    filename <- paste0("analysis_plan_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".md")
    writeLines(plan_text, filename)
    cli::cli_alert_success("Plan saved to {.file {filename}}")
    return(filename)
  } else if (output_format == "html") {
    if (requireNamespace("markdown", quietly = TRUE)) {
      md_text <- paste(plan_text, collapse = "\n")
      html <- markdown::markdownToHTML(text = md_text)
      filename <- paste0("analysis_plan_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".html")
      writeLines(html, filename)
      cli::cli_alert_success("Plan saved to {.file {filename}}")
      return(filename)
    } else {
      cli::cli_alert_warning("Package 'markdown' needed for HTML output")
    }
  }
  
  invisible(plan_text)
}

#' Convert Code to Loop Structure
#'
#' @description
#' Takes a script or code block and converts it to an efficient loop structure
#' based on the specified iteration requirements.
#'
#' @param code Character string or file path containing the code to loop
#' @param loop_over What to loop over (e.g., "files", "columns", "rows", "list elements")
#' @param iterator_name Name for the loop variable (default: "i")
#' @param parallel Whether to use parallel processing (default: FALSE)
#'
#' @return Modified code with loop structure
#'
#' @examples
#' \dontrun{
#' # Convert file processing to loop
#' code <- "data <- read.csv('file.csv')\nsummary(data)"
#' goose_loop_me(code, loop_over = "files")
#' 
#' # Create parallel loop
#' goose_loop_me("process_data(df)", loop_over = "datasets", parallel = TRUE)
#' }
#'
#' @export
goose_loop_me <- function(code, 
                         loop_over, 
                         iterator_name = "i",
                         parallel = FALSE) {
  
  cli::cli_h2("🔄 Loop Generator")
  
  # Check if code is a file path
  if (length(code) == 1 && file.exists(code)) {
    code_lines <- readLines(code)
    code <- paste(code_lines, collapse = "\n")
    cli::cli_alert_info("Reading code from file: {.file {code}}")
  }
  
  # Determine loop type
  loop_templates <- list(
    files = list(
      setup = "files <- list.files(pattern = '*.csv', full.names = TRUE)",
      loop = "for (file in files) {",
      iterator = "file",
      parallel_setup = "library(parallel)\nfiles <- list.files(pattern = '*.csv', full.names = TRUE)\nresults <- mclapply(files, function(file) {"
    ),
    columns = list(
      setup = "columns <- names(data)",
      loop = "for (col in columns) {",
      iterator = "col",
      parallel_setup = "library(parallel)\ncolumns <- names(data)\nresults <- mclapply(columns, function(col) {"
    ),
    rows = list(
      setup = "n_rows <- nrow(data)",
      loop = "for (i in 1:n_rows) {",
      iterator = "i",
      parallel_setup = "library(parallel)\nn_rows <- nrow(data)\nresults <- mclapply(1:n_rows, function(i) {"
    ),
    datasets = list(
      setup = "datasets <- list(df1, df2, df3)  # Add your datasets",
      loop = "for (dataset in datasets) {",
      iterator = "dataset",
      parallel_setup = "library(parallel)\ndatasets <- list(df1, df2, df3)\nresults <- mclapply(datasets, function(dataset) {"
    )
  )
  
  # Match loop type
  loop_type <- tolower(loop_over)
  template <- NULL
  
  for (type in names(loop_templates)) {
    if (grepl(type, loop_type)) {
      template <- loop_templates[[type]]
      break
    }
  }
  
  if (is.null(template)) {
    # Generic loop
    template <- list(
      setup = paste0(iterator_name, "_list <- c()  # Define your items"),
      loop = paste0("for (", iterator_name, " in ", iterator_name, "_list) {"),
      iterator = iterator_name
    )
  }
  
  # Build looped code
  if (parallel) {
    looped_code <- c(
      "# Parallel Loop Structure",
      template$parallel_setup %||% template$setup,
      "  # Your code here:",
      paste0("  ", strsplit(code, "\n")[[1]]),
      "}, mc.cores = detectCores() - 1)"
    )
  } else {
    looped_code <- c(
      "# Loop Structure",
      template$setup,
      "",
      template$loop,
      "  # Your code here:",
      paste0("  ", strsplit(code, "\n")[[1]]),
      "}"
    )
  }
  
  # Add progress bar option
  if (!parallel) {
    looped_code <- c(
      looped_code[1:2],
      "# Optional: Add progress bar",
      "# library(progress)",
      "# pb <- progress_bar$new(total = length(items))",
      looped_code[3:length(looped_code)],
      "  # pb$tick()  # Update progress"
    )
  }
  
  # Display result
  cat(cli::col_green("Generated Loop Structure:\n"))
  cat(rep("─", 50), "\n", sep = "")
  cat(paste(looped_code, collapse = "\n"))
  cat("\n", rep("─", 50), "\n", sep = "")
  
  # Save to clipboard if possible
  if (requireNamespace("clipr", quietly = TRUE) && clipr::clipr_available()) {
    clipr::write_clip(paste(looped_code, collapse = "\n"))
    cli::cli_alert_success("Code copied to clipboard!")
  }
  
  invisible(paste(looped_code, collapse = "\n"))
}

#' Review and Challenge Current Work
#'
#' @description
#' Reviews current work in scripts, RMarkdown files, or directories and provides
#' constructive challenges to assumptions and suggestions for more advanced analyses.
#' This is Goose's way of pushing you to think deeper!
#'
#' @param path Path to script, RMarkdown file, or directory (default: current working directory)
#' @param focus Area to focus review on: "statistics", "visualization", "performance", "methodology"
#' @param severity Level of critique: "gentle", "moderate", "harsh" (default: "moderate")
#'
#' @return List containing review comments and suggestions
#'
#' @examples
#' \dontrun{
#' # Review current directory
#' goose_honk()
#' 
#' # Review specific script with focus
#' goose_honk("analysis.R", focus = "statistics")
#' 
#' # Get harsh critique for improvement
#' goose_honk(severity = "harsh")
#' }
#'
#' @export
goose_honk <- function(path = ".", 
                      focus = NULL,
                      severity = "moderate") {
  
  cli::cli_h1("🦆 HONK! Code Review")
  
  # Determine what to review
  if (path == ".") {
    path <- getwd()
    cli::cli_alert_info("Reviewing current directory: {.path {path}}")
  }
  
  review_items <- list()
  
  # Collect files to review
  if (dir.exists(path)) {
    r_files <- list.files(path, pattern = "\\.R$", full.names = TRUE, recursive = TRUE)
    rmd_files <- list.files(path, pattern = "\\.Rmd$", full.names = TRUE, recursive = TRUE)
    review_items$r_files <- r_files
    review_items$rmd_files <- rmd_files
  } else if (file.exists(path)) {
    if (grepl("\\.R$", path)) {
      review_items$r_files <- path
    } else if (grepl("\\.Rmd$", path)) {
      review_items$rmd_files <- path
    }
  }
  
  # Initialize review comments
  review <- list(
    timestamp = Sys.time(),
    path = path,
    severity = severity,
    challenges = list(),
    suggestions = list(),
    advanced_techniques = list()
  )
  
  # Common issues to check
  checks <- list(
    statistics = c(
      "Are you checking assumptions before running tests?",
      "Have you considered multiple testing corrections?",
      "Is your sample size adequate for the analysis?",
      "Are you reporting effect sizes, not just p-values?",
      "Have you checked for confounding variables?"
    ),
    visualization = c(
      "Are your visualizations accessible (colorblind-friendly)?",
      "Do your plots have proper labels and titles?",
      "Have you considered interactive visualizations?",
      "Are you showing uncertainty (confidence intervals)?",
      "Is the chart type appropriate for the data?"
    ),
    performance = c(
      "Are you using vectorized operations instead of loops?",
      "Have you profiled your code for bottlenecks?",
      "Are you loading only necessary data/packages?",
      "Could this benefit from parallel processing?",
      "Are you caching expensive computations?"
    ),
    methodology = c(
      "Is your analysis reproducible?",
      "Have you documented your assumptions?",
      "Are you handling missing data appropriately?",
      "Have you considered alternative approaches?",
      "Is your code modular and reusable?"
    )
  )
  
  # Severity-based messages
  severity_intros <- list(
    gentle = "🌟 Great work! Here are some friendly suggestions:",
    moderate = "🔍 Good foundation! Let's level up with these considerations:",
    harsh = "⚠️ Time for tough love! Critical improvements needed:"
  )
  
  cat("\n", severity_intros[[severity]], "\n\n")
  
  # Generate focused or comprehensive review
  if (!is.null(focus) && focus %in% names(checks)) {
    review$challenges <- checks[[focus]]
  } else {
    review$challenges <- unlist(checks)
  }
  
  # Display challenges
  cli::cli_h2("Challenges to Consider")
  for (i in seq_along(review$challenges)) {
    cat(paste0(i, ". ", review$challenges[i], "\n"))
  }
  
  # Advanced technique suggestions
  review$suggestions <- c(
    "\n📚 Advanced Techniques to Explore:\n",
    "• Bayesian methods for uncertainty quantification",
    "• Cross-validation for model evaluation",
    "• Ensemble methods for predictions",
    "• Causal inference techniques",
    "• Dimension reduction (PCA, t-SNE, UMAP)",
    "• Time series decomposition",
    "• Network analysis for relationships",
    "• Sensitivity analysis for robustness"
  )
  
  cat(paste(review$suggestions, collapse = "\n"))
  
  # Code-specific suggestions if files were found
  if (length(review_items$r_files) > 0 || length(review_items$rmd_files) > 0) {
    cat("\n\n")
    cli::cli_h2("File-Specific Observations")
    
    total_files <- length(review_items$r_files) + length(review_items$rmd_files)
    cat(paste0("Found ", total_files, " files to review\n"))
    
    # Quick checks
    cat("\nQuick Checks:\n")
    cat("✓ Check for set.seed() for reproducibility\n")
    cat("✓ Look for hardcoded values that should be parameters\n")
    cat("✓ Verify error handling with tryCatch()\n")
    cat("✓ Ensure consistent coding style\n")
    cat("✓ Add unit tests for critical functions\n")
  }
  
  # Motivational close based on severity
  severity_closes <- list(
    gentle = "\n🌈 Keep up the excellent work! Every iteration makes it better.",
    moderate = "\n💪 You're on the right track! These improvements will make your analysis shine.",
    harsh = "\n🔥 No excuses! Implement these changes and become a data science legend!"
  )
  
  cat(severity_closes[[severity]], "\n")
  
  invisible(review)
}

#' Generate Continuation Prompt for Next Session
#'
#' @description
#' Reviews current work and generates a comprehensive continuation prompt
#' with progress tracking, file mapping, and next steps for seamless handoff
#' to the next working session.
#'
#' @param path Path to review (default: current working directory)
#' @param include_files Whether to include file listing (default: TRUE)
#' @param include_todos Whether to scan for TODO comments (default: TRUE)
#' @param save_to Path to save the continuation prompt (auto-generated if NULL)
#'
#' @return Path to the saved continuation prompt
#'
#' @examples
#' \dontrun{
#' # Generate continuation prompt for current project
#' goose_continuation_prompt()
#' 
#' # Generate without file listing
#' goose_continuation_prompt(include_files = FALSE)
#' 
#' # Save to specific location
#' goose_continuation_prompt(save_to = "project_docs/continuation.md")
#' }
#'
#' @export
goose_continuation_prompt <- function(path = ".",
                                    include_files = TRUE,
                                    include_todos = TRUE,
                                    save_to = NULL) {
  
  cli::cli_h1("📝 Generating Continuation Prompt")
  
  # Set up paths
  if (path == ".") {
    path <- getwd()
  }
  
  timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
  
  if (is.null(save_to)) {
    save_to <- file.path(path, paste0("CONTINUATION_PROMPT_", timestamp, ".md"))
  }
  
  # Initialize prompt sections
  prompt <- list()
  
  # Header
  prompt$header <- c(
    "# 🦆 GooseR Continuation Prompt",
    paste0("Generated: ", format(Sys.time(), "%Y-%m-%d %H:%M:%S")),
    paste0("Project: ", basename(path)),
    paste0("Path: ", path),
    "",
    "---",
    ""
  )
  
  # Session Summary
  prompt$summary <- c(
    "## 📊 Session Summary",
    "",
    "### Working Directory",
    paste0("```\n", path, "\n```"),
    "",
    "### R Session Info",
    "```r",
    capture.output(sessionInfo()),
    "```",
    ""
  )
  
  # File Mapping
  if (include_files) {
    cli::cli_alert_info("Mapping project files...")
    
    r_files <- list.files(path, pattern = "\\.R$", full.names = FALSE, recursive = TRUE)
    rmd_files <- list.files(path, pattern = "\\.Rmd$", full.names = FALSE, recursive = TRUE)
    data_files <- list.files(path, pattern = "\\.(csv|xlsx|rds|RData)$", 
                            full.names = FALSE, recursive = TRUE)
    
    prompt$files <- c(
      "## 📁 Project Structure",
      "",
      "### R Scripts",
      if (length(r_files) > 0) paste0("- ", r_files) else "- No R scripts found",
      "",
      "### R Markdown Files",
      if (length(rmd_files) > 0) paste0("- ", rmd_files) else "- No Rmd files found",
      "",
      "### Data Files",
      if (length(data_files) > 0) paste0("- ", data_files) else "- No data files found",
      ""
    )
  }
  
  # TODO scanning
  if (include_todos) {
    cli::cli_alert_info("Scanning for TODOs...")
    
    todos <- list()
    all_files <- c(
      list.files(path, pattern = "\\.R$", full.names = TRUE, recursive = TRUE),
      list.files(path, pattern = "\\.Rmd$", full.names = TRUE, recursive = TRUE)
    )
    
    for (file in all_files) {
      lines <- readLines(file, warn = FALSE)
      todo_lines <- grep("TODO|FIXME|NOTE", lines, ignore.case = TRUE)
      if (length(todo_lines) > 0) {
        todos[[basename(file)]] <- lines[todo_lines]
      }
    }
    
    prompt$todos <- c(
      "## ✅ TODOs and Notes",
      ""
    )
    
    if (length(todos) > 0) {
      for (file in names(todos)) {
        prompt$todos <- c(prompt$todos,
          paste0("### ", file),
          paste0("- ", todos[[file]]),
          ""
        )
      }
    } else {
      prompt$todos <- c(prompt$todos, "No TODOs found in project files.", "")
    }
  }
  
  # Recent Memory
  cli::cli_alert_info("Checking Goose memory...")
  recent_memory <- tryCatch({
    memories <- goose_list(category = "*", global = FALSE)
    if (length(memories) > 0) {
      c(
        "## 🧠 Recent Goose Memory",
        "",
        "### Saved Objects",
        paste0("- ", names(memories)[1:min(10, length(memories))]),
        if (length(memories) > 10) paste0("... and ", length(memories) - 10, " more"),
        ""
      )
    } else {
      NULL
    }
  }, error = function(e) NULL)
  
  if (!is.null(recent_memory)) {
    prompt$memory <- recent_memory
  }
  
  # Progress Status
  prompt$progress <- c(
    "## 📈 Progress Status",
    "",
    "### Completed in This Session",
    "- [ ] Add completed tasks here",
    "",
    "### In Progress",
    "- [ ] Add ongoing work here",
    "",
    "### Blocked/Waiting",
    "- [ ] Add blockers here",
    ""
  )
  
  # Next Steps
  prompt$next_steps <- c(
    "## 🚀 Next Steps",
    "",
    "### Immediate Priorities",
    "1. ",
    "2. ",
    "3. ",
    "",
    "### Future Enhancements",
    "- ",
    "- ",
    "",
    "### Questions to Address",
    "- ",
    "- ",
    ""
  )
  
  # Key Commands
  prompt$commands <- c(
    "## 💡 Quick Start Commands",
    "",
    "```r",
    "# Load gooseR",
    "library(gooseR)",
    "",
    "# Restore session",
    "# source('restore_session.R')",
    "",
    "# Load saved objects",
    "# goose_load('object_name')",
    "",
    "# Continue analysis",
    "# goose_ask('What should we work on next?')",
    "```",
    ""
  )
  
  # Notes section
  prompt$notes <- c(
    "## 📝 Session Notes",
    "",
    "_Add any important context, decisions, or observations from this session:_",
    "",
    "- ",
    "- ",
    "- ",
    "",
    "---",
    "",
    paste0("*This continuation prompt was generated by gooseR v", 
           utils::packageVersion("gooseR"), "*"),
    paste0("*Use this to resume work seamlessly in your next session*")
  )
  
  # Combine all sections
  full_prompt <- unlist(prompt)
  
  # Write to file
  writeLines(full_prompt, save_to)
  
  # Display summary
  cli::cli_alert_success("Continuation prompt saved to:")
  cat(cli::col_blue(save_to), "\n\n")
  
  cat("Summary:\n")
  cat("• Project:", basename(path), "\n")
  if (include_files) {
    total_files <- length(r_files) + length(rmd_files) + length(data_files)
    cat("• Files tracked:", total_files, "\n")
  }
  if (include_todos && length(todos) > 0) {
    cat("• TODOs found:", sum(lengths(todos)), "\n")
  }
  cat("• Timestamp:", timestamp, "\n")
  
  cli::cli_alert_info("Copy this prompt to start your next session exactly where you left off!")
  
  invisible(save_to)
}

# Helper function for null-coalescing
`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}
