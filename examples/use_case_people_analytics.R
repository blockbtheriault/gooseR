# People Analytics Demo - gooseR
# Generate sample employee data
set.seed(123)
employees <- data.frame(
  employee_id = sprintf("%06d", 1:500),
  tenure_years = runif(500, 0, 10),
  satisfaction = pmax(pmin(rnorm(500, 3.5, 1), 5), 1),
  performance = sample(1:5, 500, replace = TRUE),
  department = sample(c("Engineering", "Sales", "HR", "Finance"), 500, replace = TRUE)
)

# Example workflow (pseudo-exec where AI calls require config)
# 1) Exploratory analysis with goose_ask()
# insights <- goose_ask("Provide EDA and key insights for the 'employees' data. Suggest 3 visualizations.")

# 2) Visualization with theme_brand("block")
# library(ggplot2)
# p <- ggplot(employees, aes(x = department, y = satisfaction, fill = department)) +
#   geom_boxplot(alpha = 0.8) +
#   theme_brand("block") +
#   labs(title = "Employee Satisfaction by Department", x = NULL, y = "Satisfaction (1-5)")
# print(p)

# 3) Report generation
# goose_create_report(data = employees, title = "People Analytics Demo", output = "people_analytics_report.html")

# 4) Interactive chat about findings
# goose_chat("Based on the visuals and EDA, what actions should HR take?")

message("People Analytics demo data generated: 'employees' (500 rows)")
