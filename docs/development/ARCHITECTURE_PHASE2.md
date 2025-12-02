# GooseR Phase 2: Universal Branding System Architecture

## Overview
A universal branding system that allows users to define, store, and apply consistent branding across multiple R output formats (ggplot2, RMarkdown, HTML, CSS).

## Core Design Principles
1. **Brand-Agnostic**: Works with ANY brand, not just Block
2. **Format-Flexible**: Outputs to multiple formats from single source
3. **CLI-Integrated**: Interactive brand creation via Goose CLI
4. **Version-Controlled**: Brands stored as YAML for easy versioning
5. **Extensible**: Easy to add new output formats

## Architecture Components

### 1. Brand Configuration Format (YAML)
```yaml
# Example: block_brand.yaml
brand:
  name: "Block"
  version: "1.0.0"
  
colors:
  primary:
    black: "#000000"
    white: "#FFFFFF"
  secondary:
    gray: "#666666"
    light_gray: "#F7F7F7"
  accent:
    blue: "#0055FF"
    orange: "#FF5500"
    teal: "#00B5B7"
  semantic:
    success: "#00B5B7"
    warning: "#FF5500"
    error: "#D53857"
    info: "#0055FF"
    
typography:
  fonts:
    primary: "Montserrat"
    secondary: "Roboto"
    monospace: "Fira Code"
  sizes:
    base: 12
    h1: 24
    h2: 20
    h3: 16
    h4: 14
    body: 12
    small: 10
  weights:
    light: 300
    regular: 400
    medium: 500
    bold: 700
    
spacing:
  unit: 8  # Base spacing unit in pixels
  scale: [0, 0.25, 0.5, 1, 1.5, 2, 3, 4, 6, 8]
  
logos:
  primary: "path/to/logo.svg"
  alternate: "path/to/logo-alt.svg"
  favicon: "path/to/favicon.ico"
  
metadata:
  author: "Block Inc."
  copyright: "© 2025 Block Inc."
  website: "https://block.xyz"
```

### 2. Storage Structure
```
~/.config/goose/brands/
├── block/
│   ├── block_brand.yaml
│   ├── assets/
│   │   ├── logos/
│   │   └── fonts/
│   └── generated/
│       ├── theme_block.R
│       ├── block.css
│       └── block_rmd_template.Rmd
├── custom/
│   └── my_brand.yaml
└── templates/
    └── brand_template.yaml
```

### 3. Core Functions

#### 3.1 Brand Creation
```r
goose_create_brand <- function(
  brand_name = NULL,
  interactive = TRUE,
  template = "default",
  output_dir = NULL
) {
  # Interactive CLI if no brand_name provided
  # Uses Goose CLI for interactive prompts
  # Generates YAML config
  # Validates brand configuration
  # Stores in ~/.config/goose/brands/
}
```

#### 3.2 Theme Generation
```r
theme_brand <- function(
  brand = "block",
  base_theme = theme_minimal(),
  cache = TRUE
) {
  # Load brand YAML
  # Generate ggplot2 theme dynamically
  # Cache for performance
  # Return theme object
}
```

#### 3.3 RMarkdown Template
```r
brand_rmd_template <- function(
  brand = "block",
  output_format = "html_document",
  css = TRUE,
  toc = TRUE
) {
  # Generate RMarkdown YAML header
  # Include brand CSS if requested
  # Set up document structure
  # Return template path or content
}
```

#### 3.4 CSS Generation
```r
brand_css <- function(
  brand = "block",
  output_file = NULL,
  minify = FALSE,
  include_fonts = TRUE
) {
  # Convert brand YAML to CSS variables
  # Generate complete CSS framework
  # Optional minification
  # Save or return CSS content
}
```

### 4. CLI Integration Approach

#### Option A: Direct System Calls (Recommended)
```r
goose_cli <- function(prompt, ...) {
  # Use system2() to call goose CLI
  # Parse JSON response
  # Handle errors gracefully
  system2("goose", 
    args = c("--json", shQuote(prompt)),
    stdout = TRUE,
    stderr = TRUE
  )
}
```

#### Option B: REST API Integration
```r
goose_api <- function(endpoint, payload) {
  # Use httr to call Goose API
  # Requires API key configuration
  # More complex but more flexible
}
```

### 5. Brand Validation Schema
```r
validate_brand <- function(brand_config) {
  # Required fields check
  # Color format validation (#RRGGBB)
  # Font availability check
  # Asset path validation
  # Return validation report
}
```

## Implementation Phases

### Phase 2.1: Core Infrastructure
1. Set up brand storage structure
2. Create YAML parsing/validation
3. Implement goose_create_brand() with basic CLI

### Phase 2.2: ggplot2 Integration
1. Implement theme_brand()
2. Create dynamic theme generation
3. Add caching mechanism

### Phase 2.3: RMarkdown Integration
1. Implement brand_rmd_template()
2. Create CSS generation
3. Add template management

### Phase 2.4: Block Brand Demo
1. Create complete Block brand config
2. Generate all output formats
3. Create showcase examples

### Phase 2.5: Advanced Features
1. Brand inheritance (extend existing brands)
2. Brand versioning
3. Export/import functionality
4. Visual brand preview

## Example Usage

```r
library(gooseR)

# Create a new brand interactively
goose_create_brand("my_company")
# Interactive prompts for colors, fonts, etc.

# Use brand in ggplot2
library(ggplot2)
ggplot(mtcars, aes(mpg, wt)) +
  geom_point() +
  theme_brand("my_company")

# Use brand in RMarkdown
# In YAML header:
# ---
# title: "My Report"
# output: 
#   html_document:
#     theme: !expr gooseR::brand_rmd_template("my_company")
# ---

# Generate CSS for web projects
brand_css("my_company", "assets/my_company.css")
```

## Benefits
1. **Consistency**: Single source of truth for brand
2. **Efficiency**: Apply branding with one line of code
3. **Flexibility**: Works across multiple output formats
4. **Shareability**: YAML configs can be shared/versioned
5. **Maintainability**: Update brand in one place

## Technical Considerations
1. **Font Loading**: Handle web fonts vs system fonts
2. **Color Accessibility**: Include contrast checking
3. **Performance**: Cache generated themes
4. **Compatibility**: Ensure works with various R versions
5. **Dependencies**: Minimize external dependencies
