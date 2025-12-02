#' GooseR Universal Branding System
#' 
#' Functions for creating and applying consistent branding across R outputs
#' @name gooseR-branding
#' @import yaml
#' @import ggplot2
NULL

#' Get brand configuration directory
#' 
#' @return Path to brand configuration directory
#' @keywords internal
get_brand_dir <- function() {
  # Check for package installation directory first
  pkg_dir <- system.file("brands", package = "gooseR")
  if (pkg_dir != "") {
    return(pkg_dir)
  }
  
  # Fall back to user config directory
  user_dir <- file.path(Sys.getenv("HOME"), ".config", "goose", "brands")
  if (!dir.exists(user_dir)) {
    dir.create(user_dir, recursive = TRUE, showWarnings = FALSE)
  }
  return(user_dir)
}

#' Load brand configuration
#' 
#' @param brand Name of the brand to load
#' @return List containing brand configuration
#' @export
#' @examples
#' \dontrun{
#' config <- load_brand("block")
#' }
load_brand <- function(brand = "block") {
  brand_dir <- get_brand_dir()
  
  # Try multiple locations
  possible_paths <- c(
    file.path(brand_dir, brand, paste0(brand, "_brand.yaml")),
    file.path(brand_dir, paste0(brand, "_brand.yaml")),
    file.path(brand_dir, brand, "brand.yaml"),
    file.path(brand_dir, paste0(brand, ".yaml"))
  )
  
  for (path in possible_paths) {
    if (file.exists(path)) {
      config <- yaml::read_yaml(path)
      message(sprintf("Loaded brand configuration from: %s", path))
      return(config)
    }
  }
  
  stop(sprintf("Brand configuration not found for: %s", brand))
}

#' Validate brand configuration
#' 
#' @param config Brand configuration list
#' @return Logical indicating if configuration is valid
#' @export
validate_brand <- function(config) {
  errors <- character()
  
  # Check required top-level fields
  required_fields <- c("brand", "colors", "typography")
  for (field in required_fields) {
    if (!field %in% names(config)) {
      errors <- c(errors, sprintf("Missing required field: %s", field))
    }
  }
  
  # Validate brand metadata
  if ("brand" %in% names(config)) {
    if (!all(c("name", "version") %in% names(config$brand))) {
      errors <- c(errors, "Brand must have 'name' and 'version' fields")
    }
  }
  
  # Validate colors
  if ("colors" %in% names(config)) {
    if (!any(c("primary", "core") %in% names(config$colors))) {
      errors <- c(errors, "Colors must have 'primary' or 'core' section")
    }
    
    # Check color format (should be hex)
    validate_colors <- function(color_list, prefix = "") {
      for (name in names(color_list)) {
        if (is.list(color_list[[name]])) {
          validate_colors(color_list[[name]], paste0(prefix, name, "."))
        } else if (is.character(color_list[[name]])) {
          if (!grepl("^#[0-9A-Fa-f]{6}$", color_list[[name]])) {
            errors <<- c(errors, sprintf("Invalid color format: %s%s = %s", 
                                        prefix, name, color_list[[name]]))
          }
        }
      }
    }
    validate_colors(config$colors)
  }
  
  # Validate typography
  if ("typography" %in% names(config)) {
    if (!"fonts" %in% names(config$typography)) {
      errors <- c(errors, "Typography must have 'fonts' section")
    }
    if (!"sizes" %in% names(config$typography)) {
      errors <- c(errors, "Typography must have 'sizes' section")
    }
  }
  
  if (length(errors) > 0) {
    warning("Brand validation errors:\n", paste(errors, collapse = "\n"))
    return(FALSE)
  }
  
  message("Brand configuration is valid")
  return(TRUE)
}

#' Create a new brand configuration interactively
#' 
#' @param brand_name Name for the new brand
#' @param template Template to use (default: "default")
#' @param interactive Use interactive prompts (default: TRUE)
#' @return Path to created brand configuration
#' @export
#' @examples
#' \dontrun{
#' goose_create_brand("my_company")
#' }
goose_create_brand <- function(brand_name = NULL, 
                              template = "default",
                              interactive = TRUE) {
  
  if (is.null(brand_name) && interactive) {
    brand_name <- readline("Enter brand name: ")
  }
  
  if (is.null(brand_name) || brand_name == "") {
    stop("Brand name is required")
  }
  
  # Sanitize brand name for file system
  brand_slug <- tolower(gsub("[^a-zA-Z0-9_-]", "_", brand_name))
  
  # Create brand directory
  brand_dir <- file.path(get_brand_dir(), brand_slug)
  if (!dir.exists(brand_dir)) {
    dir.create(brand_dir, recursive = TRUE, showWarnings = FALSE)
  }
  
  # Initialize configuration
  config <- list(
    brand = list(
      name = brand_name,
      version = "1.0.0",
      description = paste("Brand configuration for", brand_name)
    )
  )
  
  if (interactive) {
    message("\n=== Brand Configuration Setup ===\n")
    
    # Colors
    message("Define your brand colors:")
    config$colors <- list(
      primary = list(
        main = readline("Primary color (hex, e.g., #0055FF): "),
        contrast = readline("Primary contrast color (hex, e.g., #FFFFFF): ")
      )
    )
    
    add_secondary <- tolower(readline("Add secondary colors? (y/n): "))
    if (add_secondary == "y") {
      config$colors$secondary <- list(
        main = readline("Secondary color (hex): "),
        light = readline("Secondary light color (hex): "),
        dark = readline("Secondary dark color (hex): ")
      )
    }
    
    # Typography
    message("\nDefine your typography:")
    config$typography <- list(
      fonts = list(
        primary = readline("Primary font family: "),
        body = readline("Body font family: "),
        monospace = readline("Monospace font family (default: 'Courier New'): ")
      ),
      sizes = list(
        base = as.numeric(readline("Base font size (default: 12): ")),
        h1 = as.numeric(readline("H1 size (default: 28): ")),
        h2 = as.numeric(readline("H2 size (default: 24): "))
      )
    )
    
    # Set defaults for empty values
    if (config$typography$fonts$monospace == "") {
      config$typography$fonts$monospace <- "Courier New"
    }
    if (is.na(config$typography$sizes$base)) {
      config$typography$sizes$base <- 12
    }
    if (is.na(config$typography$sizes$h1)) {
      config$typography$sizes$h1 <- 28
    }
    if (is.na(config$typography$sizes$h2)) {
      config$typography$sizes$h2 <- 24
    }
    
  } else {
    # Load template
    template_path <- system.file("brands", "templates", "brand_template.yaml", 
                                package = "gooseR")
    if (file.exists(template_path)) {
      config <- yaml::read_yaml(template_path)
      config$brand$name <- brand_name
      config$brand$description <- paste("Brand configuration for", brand_name)
    }
  }
  
  # Save configuration
  config_path <- file.path(brand_dir, paste0(brand_slug, "_brand.yaml"))
  yaml::write_yaml(config, config_path)
  
  message(sprintf("\nBrand configuration created: %s", config_path))
  message(sprintf("To use: theme_brand('%s')", brand_slug))
  
  return(invisible(config_path))
}

#' Generate ggplot2 theme from brand configuration
#' 
#' @param brand Name of the brand to use
#' @param base_theme Base ggplot2 theme to build upon (default: theme_minimal())
#' @param base_size Base font size (overrides brand config if specified)
#' @return A ggplot2 theme object
#' @export
#' @examples
#' \dontrun{
#' library(ggplot2)
#' ggplot(mtcars, aes(mpg, wt)) +
#'   geom_point() +
#'   theme_brand("block")
#' }
theme_brand <- function(brand = "block", 
                       base_theme = ggplot2::theme_minimal(),
                       base_size = NULL) {
  
  # Load brand configuration
  config <- load_brand(brand)
  
  # Extract key values with defaults
  colors <- config$colors
  typography <- config$typography
  spacing <- config$spacing
  
  # Get base size from config or parameter
  if (is.null(base_size)) {
    base_size <- ifelse(!is.null(typography$sizes$base), 
                       typography$sizes$base, 
                       12)
  }
  
  # Get colors with fallbacks
  text_color <- colors$primary$black %||% colors$primary$main %||% "#000000"
  background_color <- colors$primary$white %||% colors$primary$contrast %||% "#FFFFFF"
  grid_color <- colors$gray$`30` %||% colors$gray$`300` %||% "#E5E5E5"
  
  # Get fonts with fallbacks
  font_family <- typography$fonts$body %||% typography$fonts$primary %||% ""
  
  # Build theme
  theme <- base_theme +
    ggplot2::theme(
      # Text elements
      text = ggplot2::element_text(
        family = font_family,
        size = base_size,
        color = text_color
      ),
      
      # Title elements
      plot.title = ggplot2::element_text(
        size = base_size * 1.5,
        face = "bold",
        hjust = 0,
        margin = ggplot2::margin(b = base_size)
      ),
      plot.subtitle = ggplot2::element_text(
        size = base_size * 1.1,
        hjust = 0,
        margin = ggplot2::margin(b = base_size * 0.5)
      ),
      plot.caption = ggplot2::element_text(
        size = base_size * 0.8,
        hjust = 1,
        margin = ggplot2::margin(t = base_size)
      ),
      
      # Axis elements
      axis.title = ggplot2::element_text(
        size = base_size,
        face = "bold"
      ),
      axis.text = ggplot2::element_text(
        size = base_size * 0.9,
        color = text_color
      ),
      axis.line = ggplot2::element_line(
        color = text_color,
        linewidth = 0.5
      ),
      axis.ticks = ggplot2::element_line(
        color = text_color,
        linewidth = 0.5
      ),
      
      # Panel elements
      panel.background = ggplot2::element_rect(
        fill = background_color,
        color = NA
      ),
      panel.grid.major = ggplot2::element_line(
        color = grid_color,
        linewidth = 0.5
      ),
      panel.grid.minor = ggplot2::element_blank(),
      panel.border = ggplot2::element_blank(),
      
      # Legend elements
      legend.background = ggplot2::element_rect(
        fill = background_color,
        color = NA
      ),
      legend.key = ggplot2::element_rect(
        fill = background_color,
        color = NA
      ),
      legend.text = ggplot2::element_text(
        size = base_size * 0.9
      ),
      legend.title = ggplot2::element_text(
        size = base_size,
        face = "bold"
      ),
      
      # Strip elements (for facets)
      strip.background = ggplot2::element_rect(
        fill = grid_color,
        color = text_color
      ),
      strip.text = ggplot2::element_text(
        size = base_size,
        face = "bold",
        margin = ggplot2::margin(base_size * 0.5)
      ),
      
      # Overall plot
      plot.background = ggplot2::element_rect(
        fill = background_color,
        color = NA
      ),
      plot.margin = ggplot2::margin(
        t = base_size,
        r = base_size,
        b = base_size,
        l = base_size
      )
    )
  
  return(theme)
}

#' Get brand color palette
#' 
#' @param brand Name of the brand
#' @param palette Type of palette ("categorical", "sequential", "diverging")
#' @param n Number of colors to return (NULL for all)
#' @return Character vector of hex colors
#' @export
#' @examples
#' \dontrun{
#' colors <- brand_palette("block", "categorical")
#' }
brand_palette <- function(brand = "block", 
                         palette = "categorical",
                         n = NULL) {
  
  config <- load_brand(brand)
  
  # Get palette from plots section
  if (!is.null(config$plots$palettes[[palette]])) {
    colors <- unlist(config$plots$palettes[[palette]])
  } else {
    # Fall back to extracting from color definitions
    if (palette == "categorical") {
      # Extract main colors
      colors <- c(
        config$colors$core$blue,
        config$colors$orange$`30`,
        config$colors$teal$`40`,
        config$colors$accent$gold_30,
        config$colors$accent$red_40
      )
    } else {
      colors <- c("#000000", "#666666", "#CCCCCC", "#FFFFFF")
    }
  }
  
  # Filter out NULL values
  colors <- colors[!sapply(colors, is.null)]
  
  # Return requested number of colors
  if (!is.null(n)) {
    if (n <= length(colors)) {
      return(colors[1:n])
    } else {
      # Recycle colors if more requested than available
      return(rep_len(colors, n))
    }
  }
  
  return(colors)
}

#' Generate CSS from brand configuration
#' 
#' @param brand Name of the brand
#' @param output_file Path to save CSS file (NULL to return as string)
#' @param minify Minify the CSS output (default: FALSE)
#' @return CSS content as string (invisibly if saved to file)
#' @export
#' @examples
#' \dontrun{
#' # Save to file
#' brand_css("block", "assets/block.css")
#' 
#' # Get as string
#' css <- brand_css("block")
#' }
brand_css <- function(brand = "block", 
                     output_file = NULL,
                     minify = FALSE) {
  
  config <- load_brand(brand)
  
  # Start building CSS
  css_lines <- c(
    sprintf("/* %s Brand Styles */", config$brand$name),
    sprintf("/* Generated by gooseR v%s */", 
            utils::packageVersion("gooseR")),
    "",
    ":root {"
  )
  
  # Add color variables
  if (!is.null(config$colors)) {
    css_lines <- c(css_lines, "  /* Colors */")
    add_color_vars <- function(colors, prefix = "") {
      vars <- character()
      for (name in names(colors)) {
        if (is.list(colors[[name]])) {
          vars <- c(vars, add_color_vars(colors[[name]], 
                                        paste0(prefix, name, "-")))
        } else {
          var_name <- gsub("_", "-", paste0(prefix, name))
          vars <- c(vars, sprintf("  --%s: %s;", var_name, colors[[name]]))
        }
      }
      return(vars)
    }
    css_lines <- c(css_lines, add_color_vars(config$colors, "color-"))
  }
  
  # Add typography variables
  if (!is.null(config$typography)) {
    css_lines <- c(css_lines, "", "  /* Typography */")
    
    if (!is.null(config$typography$fonts)) {
      for (name in names(config$typography$fonts)) {
        css_lines <- c(css_lines, 
                      sprintf("  --font-%s: %s;", name, 
                             config$typography$fonts[[name]]))
      }
    }
    
    if (!is.null(config$typography$sizes)) {
      for (name in names(config$typography$sizes)) {
        css_lines <- c(css_lines, 
                      sprintf("  --size-%s: %spx;", name, 
                             config$typography$sizes[[name]]))
      }
    }
  }
  
  # Add spacing variables
  if (!is.null(config$spacing)) {
    css_lines <- c(css_lines, "", "  /* Spacing */")
    if (!is.null(config$spacing$unit)) {
      css_lines <- c(css_lines, 
                    sprintf("  --spacing-unit: %spx;", config$spacing$unit))
    }
    if (!is.null(config$spacing$scale)) {
      for (name in names(config$spacing$scale)) {
        value <- config$spacing$scale[[name]] * (config$spacing$unit %||% 8)
        css_lines <- c(css_lines, 
                      sprintf("  --spacing-%s: %spx;", name, value))
      }
    }
  }
  
  css_lines <- c(css_lines, "}", "")
  
  # Add base styles
  css_lines <- c(css_lines,
    "/* Base Styles */",
    "body {",
    "  font-family: var(--font-body, var(--font-primary));",
    "  font-size: var(--size-base);",
    "  color: var(--color-primary-black, var(--color-primary-main));",
    "  background-color: var(--color-primary-white, var(--color-primary-contrast));",
    "  line-height: 1.5;",
    "}",
    "",
    "h1 { font-size: var(--size-h1); font-weight: bold; }",
    "h2 { font-size: var(--size-h2); font-weight: bold; }",
    "h3 { font-size: var(--size-h3); font-weight: bold; }",
    "h4 { font-size: var(--size-h4); font-weight: bold; }",
    "h5 { font-size: var(--size-h5); font-weight: bold; }",
    "h6 { font-size: var(--size-h6); font-weight: bold; }",
    "",
    "a {",
    "  color: var(--color-core-blue, var(--color-primary-main));",
    "  text-decoration: none;",
    "}",
    "",
    "a:hover {",
    "  text-decoration: underline;",
    "}"
  )
  
  # Combine all CSS
  css_content <- paste(css_lines, collapse = "\n")
  
  # Minify if requested
  if (minify) {
    css_content <- gsub("\\s+", " ", css_content)
    css_content <- gsub("\\s*([{}:;,])\\s*", "\\1", css_content)
    css_content <- gsub("/\\*[^*]*\\*/", "", css_content)
  }
  
  # Save or return
  if (!is.null(output_file)) {
    writeLines(css_content, output_file)
    message(sprintf("CSS saved to: %s", output_file))
    return(invisible(css_content))
  }
  
  return(css_content)
}

#' Generate RMarkdown template with brand styling
#' 
#' @param brand Name of the brand
#' @param title Document title
#' @param output_format RMarkdown output format (default: "html_document")
#' @param output_file Path to save template (NULL to return as string)
#' @return RMarkdown template content
#' @export
#' @examples
#' \dontrun{
#' # Create branded RMarkdown template
#' brand_rmd_template("block", "My Report", output_file = "report.Rmd")
#' }
brand_rmd_template <- function(brand = "block",
                              title = "Report",
                              output_format = "html_document",
                              output_file = NULL) {
  
  config <- load_brand(brand)
  
  # Generate CSS for the brand
  css_content <- brand_css(brand, minify = TRUE)
  
  # Build RMarkdown template
  template <- c(
    "---",
    sprintf('title: "%s"', title),
    sprintf('author: "%s"', config$metadata$author %||% ""),
    sprintf('date: "`r Sys.Date()`"'),
    sprintf('output:'),
    sprintf('  %s:', output_format)
  )
  
  if (output_format == "html_document") {
    template <- c(template,
      '    toc: true',
      '    toc_float: true',
      '    toc_depth: 3',
      '    number_sections: true',
      '    theme: null',
      '    highlight: tango',
      '    css: !expr gooseR::brand_css_inline()'
    )
  }
  
  template <- c(template,
    "---",
    "",
    "```{r setup, include=FALSE}",
    "knitr::opts_chunk$set(",
    "  echo = FALSE,",
    "  message = FALSE,",
    "  warning = FALSE,",
    "  fig.width = 7,",
    "  fig.height = 5,",
    "  fig.align = 'center'",
    ")",
    "",
    "# Load libraries",
    "library(ggplot2)",
    "library(gooseR)",
    "",
    sprintf("# Set brand theme as default"),
    sprintf('theme_set(theme_brand("%s"))', brand),
    "",
    sprintf("# Load brand colors"),
    sprintf('brand_colors <- brand_palette("%s", "categorical")', brand),
    "```",
    "",
    "# Executive Summary",
    "",
    "Key findings and recommendations go here.",
    "",
    "# Introduction",
    "",
    "Background and context for the analysis.",
    "",
    "# Methods",
    "",
    "Description of data sources and analytical approach.",
    "",
    "# Results",
    "",
    "## Data Overview",
    "",
    "```{r example-plot}",
    "# Example plot with brand theme",
    "ggplot(mtcars, aes(x = mpg, y = wt, color = factor(cyl))) +",
    "  geom_point(size = 3) +",
    sprintf('  scale_color_manual(values = brand_palette("%s", "categorical", 3)) +', brand),
    '  labs(',
    '    title = "Fuel Efficiency vs Weight",',
    '    subtitle = "By number of cylinders",',
    '    x = "Miles per Gallon",',
    '    y = "Weight (1000 lbs)",',
    '    color = "Cylinders"',
    '  )',
    "```",
    "",
    "# Discussion",
    "",
    "Interpretation of results and implications.",
    "",
    "# Conclusions",
    "",
    "Summary of key findings and next steps.",
    "",
    "# Appendix",
    "",
    "Additional tables, figures, and technical details."
  )
  
  # Combine template
  template_content <- paste(template, collapse = "\n")
  
  # Save or return
  if (!is.null(output_file)) {
    writeLines(template_content, output_file)
    message(sprintf("RMarkdown template saved to: %s", output_file))
    return(invisible(template_content))
  }
  
  return(template_content)
}

#' Get inline CSS for RMarkdown
#' 
#' Helper function to embed CSS directly in RMarkdown
#' @param brand Brand name
#' @return HTML style tag with CSS
#' @export
#' @keywords internal
brand_css_inline <- function(brand = "block") {
  css <- brand_css(brand, minify = TRUE)
  return(htmltools::HTML(paste0("<style>", css, "</style>")))
}
