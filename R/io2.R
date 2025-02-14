#' Read Parquet, CSV, and other files using DuckDB
#'
#' @description
#' These functions ingest data from a file.
#' In many cases, these functions return immediately because they only read the metadata.
#' The actual data is only read when it is actually processed.
#'
#' @name read_file_duckdb
NULL

#' @description
#' `read_parquet_duckdb()` reads a CSV file using DuckDB's `read_parquet()` table function.
#'
#' @rdname read_file_duckdb
#' @export
read_parquet_duckdb <- function(path, ..., prudence = c("thrifty", "lavish", "stingy"), options = list()) {
  check_dots_empty()

  read_file_duckdb(path, "read_parquet", prudence = prudence, options = options)
}

#' @description
#' `read_csv_duckdb()` reads a CSV file using DuckDB's `read_csv_auto()` table function.
#'
#' @rdname read_file_duckdb
#' @export
#' @examples
#' # Create simple CSV file
#' path <- tempfile("duckplyr_test_", fileext = ".csv")
#' write.csv(data.frame(a = 1:3, b = letters[4:6]), path, row.names = FALSE)
#'
#' # Reading is immediate
#' df <- read_csv_duckdb(path)
#'
#' # Names are always available
#' names(df)
#'
#' # Materialization upon access is turned off by default
#' try(print(df$a))
#'
#' # Materialize explicitly
#' collect(df)$a
#'
#' # Automatic materialization with prudence = "lavish"
#' df <- read_csv_duckdb(path, prudence = "lavish")
#' df$a
#'
#' # Specify column types
#' read_csv_duckdb(
#'   path,
#'   options = list(delim = ",", types = list(c("DOUBLE", "VARCHAR")))
#' )
read_csv_duckdb <- function(path, ..., prudence = c("thrifty", "lavish", "stingy"), options = list()) {
  check_dots_empty()

  read_file_duckdb(path, "read_csv_auto", prudence = prudence, options = options)
}

#' @description
#' `read_json_duckdb()` reads a JSON file using DuckDB's `read_json()` table function.
#'
#' @rdname read_file_duckdb
#' @export
#' @examples
#'
#' # Create and read a simple JSON file
#' path <- tempfile("duckplyr_test_", fileext = ".json")
#' writeLines('[{"a": 1, "b": "x"}, {"a": 2, "b": "y"}]', path)
#'
#' # Reading needs the json extension
#' db_exec("INSTALL json")
#' db_exec("LOAD json")
#' read_json_duckdb(path)
read_json_duckdb <- function(path, ..., prudence = c("thrifty", "lavish", "stingy"), options = list()) {
  check_dots_empty()

  read_file_duckdb(path, "read_json", prudence = prudence, options = options)
}

#' @description
#' `read_file_duckdb()` uses arbitrary readers to read data.
#' See <https://duckdb.org/docs/data/overview> for a documentation
#' of the available functions and their options.
#' To read multiple files with the same schema,
#' pass a wildcard or a character vector to the `path` argument,
#'
#' @inheritParams rlang::args_dots_empty
#'
#' @param path Path to files, glob patterns `*` and `?` are supported.
#' @param table_function The name of a table-valued
#'   DuckDB function such as `"read_parquet"`,
#'   `"read_csv"`, `"read_csv_auto"` or `"read_json"`.
#' @param prudence Memory protection, controls if DuckDB may convert
#'   intermediate results in DuckDB-managed memory to data frames in R memory.
#'
#'   - `"thrifty"`: up to a maximum size of 1 million cells,
#'   - `"lavish"`: regardless of size,
#'   - `"stingy"`: never.
#'
#' The default is `"thrifty"` for the ingestion functions,
#' and may be different for other functions.
#' See `vignette("prudence")` for more information.
#'
#' @param options Arguments to the DuckDB function
#'   indicated by `table_function`.
#'
#' @inheritSection duckdb_tibble Fine-tuning prudence
#'
#' @return A duckplyr frame, see [as_duckdb_tibble()] for details.
#'
#' @rdname read_file_duckdb
#' @export
read_file_duckdb <- function(
  path,
  table_function,
  ...,
  prudence = c("thrifty", "lavish", "stingy"),
  options = list()
) {
  check_dots_empty()

  if (!rlang::is_character(path)) {
    cli::cli_abort("{.arg path} must be a character vector.")
  }

  if (length(path) != 1) {
    path <- list(path)
  }

  duckfun(table_function, c(list(path), options), prudence = prudence)
}

duckfun <- function(table_function, args, ..., prudence) {
  if (!is.list(args)) {
    cli::cli_abort("{.arg args} must be a list.")
  }
  if (length(args) == 0) {
    cli::cli_abort("{.arg args} must not be empty.")
  }

  # FIXME: For some reason, it's important to create an alias here
  con <- get_default_duckdb_connection()

  # FIXME: Provide better duckdb API
  path <- args[[1]]
  options <- args[-1]

  rel <- duckdb$rel_from_table_function(
    con,
    table_function,
    list(path),
    options
  )

  meta_rel_register_file(rel, table_function, path, options)

  rel_to_df(rel, prudence = prudence)
}
