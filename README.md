# gooseR

[![Version](https://img.shields.io/badge/version-0.1.0-blue.svg)](#)
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

gooseR brings goose AI into R. It’s a user-first toolkit for analysis, visualization, and developer workflows — powered by the goose CLI.

- Memory integration for any R object
- Brand-ready visualization system (Block-first with smart fallbacks)
- AI assistant utilities for code, docs, and debugging
- Advanced runtime features: streaming, caching, async, templates
- IDE addins (RStudio/Positron) for one-click actions

About goose
goose is your friendly AI pardner who can understand what you want to do and help you do it! The best part is that goose can learn from your preferences and remember them for next time!

- Open Source: Built with transparency and collaboration in mind, goose empowers developers to contribute, customize, and innovate freely.
- Runs Locally: Goose runs locally to execute tasks efficiently, keeping control in your hands.
- Extensible: Customize goose with your preferred LLM and enhance its capabilities by connecting it to any external MCP server or API.
- Autonomous: Goose independently handles complex tasks, from debugging to deployment, freeing you to focus on what matters most.

There are both Desktop and CLI versions of goose. If you have goose CLI is already installed and working, gooseR requires no additional R configuration (this applies to anyone with the goose CLI, not just Block employees). If you need to configure your provider/model/key, use goose_configure().

[more on goose here](https://block.github.io/goose/docs/quickstart)

## gooseR Installation

```r
# Install from GitHub (private repo)
# install.packages("remotes")
remotes::install_github("blockbtheriault/gooseR")
```

Configuration
- If Goose CLI is already working on your machine, you do not need any extra R-side setup. This applies to anyone with the Goose CLI configured — not just Block employees.
- To validate, run:

```r
library(gooseR)
if (goose_test_cli()) message("Goose CLI is ready!")
```

- If you don’t have Goose CLI working yet, configure credentials:

```r
# Example for external users
# goose_configure(provider = "openai", model = "gpt-4o", api_key = "your-key")
```

## Quick Start

```r
library(gooseR)

# Ask Goose a question
resp <- goose_ask("Summarize mtcars and suggest 2 visualizations")
cat(substr(resp, 1, 240), "...\n")

# Memory: save and load any R object
gears <- as.list(split(mtcars, mtcars$gear))
goose_save(gears, category = "demo", tags = c("example", "mtcars"))
objs <- goose_list(category = "demo")
restored <- goose_load(objs$name[1])

# Branded visualization (Block)
library(ggplot2)

p <- ggplot(mtcars, aes(wt, mpg)) +
  geom_point(color = "#000000", alpha = 0.8) +
  theme_brand("block") +
  labs(title = "Fuel Efficiency vs Weight", x = "Weight", y = "MPG")
print(p)
```

## Visual Examples

<p align="center">
  <img src="docs/assets/block_line_chart.png" width="45%" />
  <img src="docs/assets/block_bar_chart.png" width="45%" />
</p>

More in docs/assets and inst/examples.

## What gooseR Provides

- Memory
  - goose_save(), goose_load(), goose_list(), goose_delete()
- Branding
  - theme_brand(), brand_palette(), brand_css(), brand_rmd_template()
- AI Assistant
  - goose_ask(): general queries
  - goose_review_code(): AI code review
  - goose_document(): AI-generated roxygen docs
  - goose_generate_tests(): testthat scaffolding
  - goose_explain_error(): error explanation and fixes
- Advanced Runtime
  - goose_stream(), goose_stream_session(): streaming with handlers
  - goose_cache_init/set/get/stats/clear/export/import
  - goose_batch(), goose_mapreduce(), goose_reduce()
  - goose_template(), goose_template_apply/save/load/list/builtin/validate
  - WorkerPool (R6) for parallel async use cases
- IDE & Docs
  - Addins: goose_addin_chat, goose_addin_review, goose_addin_template, goose_addin_quick, goose_addin_snippet
  - Quarto/RMarkdown: register_goose_engine(), goose_quarto_chunk(), goose_create_quarto(), goose_create_report(), goose_insert_chunk()

## Top / Unique Functions (Quick Overview)
- goose_ask(): Ask Goose directly from R (text or JSON)
- goose_review_code(): AI-powered review of selected R code (works great via addin)
- goose_generate_tests(): Generate testthat tests from function code
- goose_document(): Produce roxygen2 documentation from a function
- goose_explain_error(): Explain and fix R errors with suggested code
- theme_brand("block"): Block-branded ggplot2 theme
- brand_palette(): Access brand color palettes (categorical, sequential, diverging)
- brand_css(), brand_rmd_template(): Export CSS and R Markdown templates in brand style
- goose_stream(), StreamHandler: Streaming responses with callbacks
- goose_cache_*(): Durable caching layer (SQLite) with export/import and stats
- goose_batch(), goose_mapreduce(): Simple parallel/async AI workflows
- goose_template_*(): Robust templating (create/apply/save/load/validate)
- goose_addin_*(): One-click IDE addins for chat, code review, templates, snippets


## Documentation & Examples
- Vignettes: run `browseVignettes("gooseR")` to open the overview and use-case demos.
- Examples: examples/ (use_case_*.R) and inst/examples/ contain runnable scripts.
- Technical docs and assets: docs/ and docs/assets/

## Contributing
We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) and our [Code of Conduct](CODE_OF_CONDUCT.md).

## License
MIT License. See [LICENSE](LICENSE).
