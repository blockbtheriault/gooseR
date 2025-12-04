# Build all vignettes to HTML for GitHub browsing
library(rmarkdown)

# Create output directory
dir.create('docs/articles', showWarnings = FALSE, recursive = TRUE)

# List of vignettes
vignettes <- c(
  'getting-started.Rmd',
  'survey-data-analysis.Rmd', 
  'code-review-testing.Rmd',
  'memory-workflow.Rmd',
  'gooseR-overview.Rmd',
  'use-case-demo.Rmd'
)

# Build each vignette
for (vignette in vignettes) {
  vignette_path <- file.path('vignettes', vignette)
  if (file.exists(vignette_path)) {
    output_name <- sub('.Rmd$', '.html', vignette)
    output_path <- file.path('docs/articles', output_name)
    
    cat('Building:', vignette, '\n')
    
    tryCatch({
      rmarkdown::render(
        vignette_path,
        output_file = basename(output_path),
        output_dir = dirname(output_path),
        output_format = rmarkdown::html_vignette(),
        quiet = TRUE
      )
      cat('  ✓ Created:', output_path, '\n')
    }, error = function(e) {
      cat('  ✗ Error building', vignette, ':', e$message, '\n')
    })
  }
}

cat('\nAll vignettes built!\n')
cat('HTML files created:\n')
list.files('docs/articles', pattern = '.html$', full.names = TRUE)
