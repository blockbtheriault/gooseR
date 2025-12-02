# Sales Analysis Demo - gooseR
set.seed(456)
sales <- data.frame(
  date = seq(as.Date("2024-01-01"), as.Date("2024-12-31"), by = "day"),
  revenue = pmax(rnorm(366, 10000, 2000), 0),
  transactions = rpois(366, 50),
  region = sample(c("North", "South", "East", "West"), 366, replace = TRUE)
)

# Async batch analysis (pseudo)
# results <- goose_batch(list(
#   list(name = "trend", fn = function() goose_ask("Summarize revenue trends")),
#   list(name = "seasonality", fn = function() goose_ask("Detect seasonality in transactions"))
# ))

# Cache optimization
# goose_cache_set("sales_demo", sales)
# cached <- goose_cache_get("sales_demo")

# Template-based reporting
# goose_template("sales_summary")

# Quarto / RMarkdown generation
# goose_create_report(data = sales, title = "Sales Analysis Demo", output = "sales_analysis_report.html")

message("Sales demo data generated: 'sales' (", nrow(sales), " rows)")
