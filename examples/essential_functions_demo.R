# gooseR Essential Functions Demo
# Showcasing the 5 new essential functions for seamless R-Goose integration
# Date: 2025-12-03

library(gooseR)
library(cli)

cli::cli_h1("🦆 GooseR Essential Functions Demo")
cli::cli_alert_info("This demo showcases 5 essential functions that enhance your R-Goose workflow")

# -----------------------------------------------------------------------------
# 1. goose_give_sample() - Share data with Goose
# -----------------------------------------------------------------------------
cli::cli_h2("1. Sharing Data with Goose")
cli::cli_text("goose_give_sample() lets Goose understand your data structure")

# Create sample data
sales_data <- data.frame(
  month = month.name[1:12],
  revenue = round(runif(12, 10000, 50000), 2),
  customers = sample(100:500, 12),
  region = rep(c("North", "South", "East", "West"), 3)
)

# Share with Goose
goose_give_sample(sales_data, "monthly_sales")

cli::cli_alert_success("Goose now knows about your sales_data structure!")
cli::cli_text("Goose can write accurate code using actual column names: {.field {names(sales_data)}}")

readline(prompt = "\nPress [Enter] to continue...")

# -----------------------------------------------------------------------------
# 2. goose_make_a_plan() - Get analysis recommendations
# -----------------------------------------------------------------------------
cli::cli_h2("2. Generate Analysis Plan")
cli::cli_text("goose_make_a_plan() creates a phased approach for your analysis")

# Generate comprehensive plan
cat("\n")
goose_make_a_plan(focus = "exploratory")

readline(prompt = "\nPress [Enter] to continue...")

# -----------------------------------------------------------------------------
# 3. goose_loop_me() - Convert code to loops
# -----------------------------------------------------------------------------
cli::cli_h2("3. Convert Code to Loops")
cli::cli_text("goose_loop_me() transforms simple code into efficient loops")

# Example code that needs looping
analysis_code <- "
# Load data
data <- read.csv(filename)

# Clean and process
data$revenue <- as.numeric(data$revenue)
data$profit_margin <- data$profit / data$revenue

# Generate summary
summary_stats <- summary(data)
write.csv(summary_stats, paste0('summary_', filename))
"

cli::cli_alert_info("Original code:")
cat(cli::col_grey(analysis_code))

cli::cli_alert_success("\nConverted to file loop:")
goose_loop_me(analysis_code, loop_over = "files")

readline(prompt = "\nPress [Enter] to see parallel version...")

cli::cli_alert_success("\nParallel processing version:")
goose_loop_me(analysis_code, loop_over = "files", parallel = TRUE)

readline(prompt = "\nPress [Enter] to continue...")

# -----------------------------------------------------------------------------
# 4. goose_honk() - Get code review and suggestions
# -----------------------------------------------------------------------------
cli::cli_h2("4. Code Review with goose_honk()")
cli::cli_text("Get constructive feedback and advanced technique suggestions")

# Gentle review
cli::cli_alert_info("Starting with encouragement:")
goose_honk(severity = "gentle", focus = "visualization")

readline(prompt = "\nPress [Enter] for tougher love...")

# Harsh review for growth
cli::cli_alert_warning("Time for tough love:")
goose_honk(severity = "harsh", focus = "methodology")

readline(prompt = "\nPress [Enter] to continue...")

# -----------------------------------------------------------------------------
# 5. goose_continuation_prompt() - Save session state
# -----------------------------------------------------------------------------
cli::cli_h2("5. Generate Continuation Prompt")
cli::cli_text("goose_continuation_prompt() creates a comprehensive handoff document")

# Generate continuation prompt
prompt_file <- goose_continuation_prompt(
  include_files = TRUE,
  include_todos = TRUE
)

cli::cli_alert_success("Session state saved!")
cli::cli_text("Your continuation prompt includes:")
cli::cli_ul(c(
  "Complete file mapping",
  "TODO scanning results",
  "Goose memory status",
  "Progress tracking",
  "Next steps recommendations"
))

# -----------------------------------------------------------------------------
# Workflow Example: Putting It All Together
# -----------------------------------------------------------------------------
cli::cli_h1("🎯 Complete Workflow Example")

cli::cli_text("Here's how these functions work together:")
cli::cli_ol(c(
  "Share your data with {.fn goose_give_sample}",
  "Get analysis plan with {.fn goose_make_a_plan}",
  "Convert repetitive code with {.fn goose_loop_me}",
  "Review your work with {.fn goose_honk}",
  "Save session state with {.fn goose_continuation_prompt}"
))

# Example integrated workflow
cli::cli_code('
# Start of session
goose_give_sample(my_data, "project_data")
plan <- goose_make_a_plan(focus = "predictive")

# During work
code <- "model <- lm(y ~ x, data = df)"
goose_loop_me(code, loop_over = "datasets")

# Review progress
goose_honk(severity = "moderate")

# End of session
goose_continuation_prompt()
')

# -----------------------------------------------------------------------------
# Summary
# -----------------------------------------------------------------------------
cli::cli_h1("📊 Summary")

cli::cli_alert_success("You've learned 5 essential gooseR functions:")

summary_table <- data.frame(
  Function = c(
    "goose_give_sample()",
    "goose_make_a_plan()",
    "goose_loop_me()",
    "goose_honk()",
    "goose_continuation_prompt()"
  ),
  Purpose = c(
    "Share data structure with Goose",
    "Generate phased analysis plans",
    "Convert code to efficient loops",
    "Get code review and suggestions",
    "Save comprehensive session state"
  ),
  `Key Benefit` = c(
    "Goose writes accurate code with your actual column names",
    "Structured approach to complex analyses",
    "Automate repetitive tasks easily",
    "Improve code quality with AI feedback",
    "Seamless handoff between sessions"
  ),
  check.names = FALSE
)

print(summary_table, row.names = FALSE)

cli::cli_h2("🚀 Next Steps")
cli::cli_ul(c(
  "Try these functions with your own data",
  "Customize the parameters for your workflow",
  "Combine with other gooseR functions for maximum productivity"
))

cli::cli_alert_info("Documentation: {.code ?goose_give_sample} (and other functions)")
cli::cli_alert_info("More examples: {.path inst/examples/}")

cli::cli_rule(left = "End of Demo", right = "Happy Coding! 🦆")
