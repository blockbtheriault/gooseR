# gooseR News

## 0.1.2 (2024-12-23)
- **Critical Fix**: Increased default timeout from 30s to 300s (5 minutes)
  - `goose_ask()` and `goose_ask_raw()` now use 300s default timeout
  - All AI-powered functions updated to use configurable timeout
  - Complex queries (code generation, analysis) no longer timeout prematurely
- **Improved Authentication**: `goose_test_cli()` timeout increased to 60s
  - Added informative message about authentication during test
  - Allows sufficient time for password entry during first-time auth
- **New Global Option**: `options(goose.timeout = 300)` 
  - Set custom default timeout for all goose functions
  - Use `timeout = Inf` for no timeout on individual calls
- **Documentation**: Updated all timeout-related documentation

## 0.1.1 (2024-12-17)
- **Major Enhancement**: Comprehensive memory management system
  - `goose_clear_category()`, `goose_clear_tags()`, `goose_clear_all()` for bulk cleanup
  - `goose_exists()`, `goose_rename()`, `goose_backup()` for smart memory operations
  - Session tracking with `goose_session_start()`, `with_goose_session()` wrapper
- **AI Response Formatting**: Beautiful markdown output by default
  - `format_ai_response()` with headers, bullets, code blocks, colors
  - `goose_format_options()` for global configuration
  - Enhanced `goose_ask()` with automatic formatting
- **18 New Functions**: Doubling package functionality
- **100% Backward Compatibility**: All existing code continues to work
- **Improved Error Handling**: Progress bars, confirmations, comprehensive validation

## 0.1.0 (2024-12-17) - CRAN Release
- Initial professional release ✅ **NOW LIVE ON CRAN**
- Organized repository structure (docs/, inst/examples, tests/manual, vignettes/)
- Added user-first README and demos
- Introduced roadmap and contributing guidelines
- Core memory system with goose_save(), goose_load(), goose_list()
- Brand theming system with theme_brand()
- CLI integration and AI assistant functions
