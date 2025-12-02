# GooseR CLI Integration Module
# Phase 3: Direct Goose AI Integration
# Author: Brandon Theriault
# Date: December 2025

#' Configure Goose CLI Settings
#'
#' Set up Goose CLI configuration including provider, model, and API key.
#' Stores settings in environment variables and optionally in .Renviron.
#'
#' @param provider Character string specifying the AI provider (e.g., "openai", "anthropic")
#' @param model Character string specifying the model (e.g., "gpt-4", "claude-3")
#' @param api_key Character string with the API key (stored securely)
#' @param save_to_renviron Logical, whether to save to .Renviron file
#'
#' @return Invisible TRUE if successful
#' @export
#'
#' @examples
#' \dontrun{
#' goose_configure(provider = "openai", model = "gpt-4", api_key = "your-key")
#' }
goose_configure <- function(provider = NULL, model = NULL, api_key = NULL, 
                           save_to_renviron = FALSE) {
  
  # Check if Goose CLI is installed
  if (!goose_check_installation()) {
    stop("Goose CLI not found. Please install from: https://github.com/block/goose")
  }
  
  # Set environment variables
  if (!is.null(provider)) {
    Sys.setenv(GOOSE_PROVIDER = provider)
  }
  
  if (!is.null(model)) {
    Sys.setenv(GOOSE_MODEL = model)
  }
  
  if (!is.null(api_key)) {
    Sys.setenv(GOOSE_API_KEY = api_key)
  }
  
  # Save to .Renviron if requested
  if (save_to_renviron) {
    renviron_path <- file.path(Sys.getenv("HOME"), ".Renviron")
    
    # Read existing .Renviron
    if (file.exists(renviron_path)) {
      lines <- readLines(renviron_path)
    } else {
      lines <- character()
    }
    
    # Update or add variables
    vars_to_save <- list(
      GOOSE_PROVIDER = provider,
      GOOSE_MODEL = model,
      GOOSE_API_KEY = api_key
    )
    
    for (var_name in names(vars_to_save)) {
      if (!is.null(vars_to_save[[var_name]])) {
        # Remove existing line if present
        lines <- lines[!grepl(paste0("^", var_name, "="), lines)]
        # Add new line
        lines <- c(lines, paste0(var_name, "=", vars_to_save[[var_name]]))
      }
    }
    
    # Write back to .Renviron
    writeLines(lines, renviron_path)
    message("Configuration saved to .Renviron. Restart R session to apply.")
  }
  
  # Verify configuration
  config <- goose_get_config()
  message("Goose configured successfully:")
  message("  Provider: ", config$provider)
  message("  Model: ", config$model)
  message("  API Key: ", if(!is.null(config$api_key)) "***configured***" else "not set")
  
  invisible(TRUE)
}

#' Get Current Goose Configuration
#'
#' @return List with provider, model, and api_key status
#' @export
goose_get_config <- function() {
  list(
    provider = Sys.getenv("GOOSE_PROVIDER", unset = NA),
    model = Sys.getenv("GOOSE_MODEL", unset = NA),
    api_key = Sys.getenv("GOOSE_API_KEY", unset = NA),
    cli_version = goose_version()
  )
}

#' Check Goose CLI Installation
#'
#' @return Logical, TRUE if Goose CLI is installed
#' @export
goose_check_installation <- function() {
  result <- suppressWarnings(
    system2("which", "goose", stdout = TRUE, stderr = FALSE)
  )
  length(result) > 0 && nchar(result[1]) > 0
}

#' Get Goose CLI Version
#'
#' @return Character string with version or NULL if not installed
#' @export
goose_version <- function() {
  if (!goose_check_installation()) {
    return(NULL)
  }
  
  result <- system2("goose", "--version", stdout = TRUE, stderr = FALSE)
  if (length(result) > 0) {
    # Extract version number
    trimws(result[1])
  } else {
    NULL
  }
}

#' Ask Goose a Question
#'
#' Send a query to Goose AI and get a response.
#'
#' @param prompt Character string with the question or prompt
#' @param output_format Character, either "text" or "json" 
#' @param quiet Logical, suppress status messages
#' @param timeout Numeric, timeout in seconds (default 30)
#' @param session_id Optional session ID for context preservation
#'
#' @return Character string with response (text format) or list (json format)
#' @export
#'
#' @examples
#' \dontrun{
#' # Simple query
#' response <- goose_ask("What's the best color for a heatmap?")
#' 
#' # JSON response
#' data <- goose_ask("List 5 colors for data viz", output_format = "json")
#' }
goose_ask <- function(prompt, 
                     output_format = c("text", "json"),
                     quiet = TRUE,
                     timeout = 30,
                     session_id = NULL) {
  
  output_format <- match.arg(output_format)
  
  # Check configuration
  if (!goose_check_installation()) {
    stop("Goose CLI not found. Run goose_configure() first.")
  }
  
  # Build command arguments
  args <- c("run", "--text", shQuote(prompt))
  
  # Add output format
  args <- c(args, "--output-format", output_format)
  
  # Add quiet flag
  if (quiet) {
    args <- c(args, "--quiet")
  }
  
  # Add session if provided
  if (!is.null(session_id)) {
    args <- c(args, "--session-id", session_id)
  } else {
    args <- c(args, "--no-session")
  }
  
  # Execute command with timeout
  result <- tryCatch({
    system2("goose", 
            args = args,
            stdout = TRUE,
            stderr = TRUE,
            timeout = timeout)
  }, error = function(e) {
    if (grepl("timeout", e$message, ignore.case = TRUE)) {
      stop("Goose query timed out after ", timeout, " seconds")
    } else {
      stop("Goose CLI error: ", e$message)
    }
  })
  
  # Parse response based on format
  if (output_format == "json") {
    # Try to parse JSON
    tryCatch({
      jsonlite::fromJSON(paste(result, collapse = "\n"))
    }, error = function(e) {
      warning("Failed to parse JSON response: ", e$message)
      result
    })
  } else {
    # Return text response
    paste(result, collapse = "\n")
  }
}

#' Execute Goose Recipe
#'
#' Run a Goose recipe with parameters.
#'
#' @param recipe Character, recipe name or path to recipe file
#' @param params Named list of parameters to pass to recipe
#' @param explain Logical, show recipe explanation instead of running
#' @param render Logical, render recipe instead of running
#'
#' @return Recipe output or explanation
#' @export
goose_recipe <- function(recipe, params = list(), explain = FALSE, render = FALSE) {
  
  if (!goose_check_installation()) {
    stop("Goose CLI not found")
  }
  
  # Build command
  args <- c("run", "--recipe", recipe)
  
  # Add parameters
  if (length(params) > 0) {
    for (name in names(params)) {
      args <- c(args, "--params", paste0(name, "=", params[[name]]))
    }
  }
  
  # Add flags
  if (explain) {
    args <- c(args, "--explain")
  }
  
  if (render) {
    args <- c(args, "--render-recipe")
  }
  
  # Execute
  result <- system2("goose", args = args, stdout = TRUE, stderr = FALSE)
  paste(result, collapse = "\n")
}

#' Create or Resume Goose Session
#'
#' Manage Goose sessions for maintaining context across queries.
#'
#' @param action Character, one of "create", "resume", "list", "remove"
#' @param name Optional session name
#' @param session_id Optional session ID
#'
#' @return Session information or query result
#' @export
goose_session <- function(action = c("create", "resume", "list", "remove"),
                         name = NULL,
                         session_id = NULL) {
  
  action <- match.arg(action)
  
  if (!goose_check_installation()) {
    stop("Goose CLI not found")
  }
  
  if (action == "create") {
    # Create new session
    args <- c("session")
    if (!is.null(name)) {
      args <- c(args, "--name", name)
    }
    args <- c(args, "--no-interactive")  # Non-interactive mode
    
    result <- system2("goose", args = args, stdout = TRUE, stderr = FALSE)
    
    # Extract session ID from output
    session_info <- list(
      session_id = extract_session_id(result),
      name = name,
      created = Sys.time()
    )
    
    class(session_info) <- c("goose_session", "list")
    return(session_info)
    
  } else if (action == "list") {
    # List sessions
    result <- system2("goose", c("session", "list"), stdout = TRUE, stderr = FALSE)
    parse_session_list(result)
    
  } else if (action == "resume") {
    # Resume session
    if (is.null(session_id) && is.null(name)) {
      stop("Either session_id or name must be provided to resume")
    }
    
    args <- c("session", "--resume")
    if (!is.null(session_id)) {
      args <- c(args, "--session-id", session_id)
    } else if (!is.null(name)) {
      args <- c(args, "--name", name)
    }
    
    result <- system2("goose", args = args, stdout = TRUE, stderr = FALSE)
    message("Session resumed: ", session_id %||% name)
    invisible(TRUE)
    
  } else if (action == "remove") {
    # Remove session
    if (is.null(session_id) && is.null(name)) {
      stop("Either session_id or name must be provided to remove")
    }
    
    args <- c("session", "remove")
    if (!is.null(session_id)) {
      args <- c(args, session_id)
    }
    
    result <- system2("goose", args = args, stdout = TRUE, stderr = FALSE)
    message("Session removed")
    invisible(TRUE)
  }
}

#' Query Goose with Session Context
#'
#' Send a query to Goose while maintaining session context.
#'
#' @param prompt Character string with the query
#' @param session Goose session object or session ID
#' @param ... Additional arguments passed to goose_ask
#'
#' @return Query response
#' @export
goose_query <- function(prompt, session = NULL, ...) {
  
  # Extract session ID
  if (inherits(session, "goose_session")) {
    session_id <- session$session_id
  } else {
    session_id <- session
  }
  
  # Query with session
  goose_ask(prompt, session_id = session_id, ...)
}

# Helper functions ----

#' Extract session ID from Goose output
#' @keywords internal
extract_session_id <- function(output) {
  # Look for session ID pattern in output
  pattern <- "session[[:space:]]+([0-9]{8}_[0-9]{6})"
  matches <- regmatches(output, regexec(pattern, output, ignore.case = TRUE))
  
  for (match in matches) {
    if (length(match) > 1) {
      return(match[2])
    }
  }
  
  # Fallback: generate timestamp-based ID
  format(Sys.time(), "%Y%m%d_%H%M%S")
}

#' Parse session list output
#' @keywords internal
parse_session_list <- function(output) {
  # Parse the session list output into a data frame
  # This will depend on the actual format of goose session list
  
  sessions <- data.frame(
    session_id = character(),
    name = character(),
    created = character(),
    last_used = character(),
    stringsAsFactors = FALSE
  )
  
  # TODO: Implement actual parsing based on goose output format
  
  sessions
}

#' Null coalescing operator
#' @keywords internal
`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}

#' Print method for goose_session
#' @export
print.goose_session <- function(x, ...) {
  cat("Goose Session\n")
  cat("  ID:", x$session_id, "\n")
  if (!is.null(x$name)) {
    cat("  Name:", x$name, "\n")
  }
  cat("  Created:", format(x$created), "\n")
  invisible(x)
}
