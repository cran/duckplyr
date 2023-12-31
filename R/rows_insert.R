# Generated by 02-duckplyr_df-methods.R
#' @export
rows_insert.duckplyr_df <- function(x, y, by = NULL, ..., conflict = c("error", "ignore"), copy = FALSE, in_place = FALSE) {
  # Our implementation
  rel_try(
    "No relational implementation for rows_insert()" = TRUE,
    {
      return(out)
    }
  )

  # dplyr forward
  rows_insert <- dplyr$rows_insert.data.frame
  out <- rows_insert(x, y, by, ..., conflict = conflict, copy = copy, in_place = in_place)
  return(out)

  # dplyr implementation
  check_dots_empty()
  rows_df_in_place(in_place)

  y <- auto_copy(x, y, copy = copy)

  by <- rows_check_by(by, y)

  rows_check_x_contains_y(x, y)
  rows_check_contains_by(x, by, "x")
  rows_check_contains_by(y, by, "y")

  y <- rows_cast_y(y, x)

  x_key <- dplyr_col_select(x, by)
  y_key <- dplyr_col_select(y, by)

  keep <- rows_check_y_conflict(x_key, y_key, conflict)

  if (!is.null(keep)) {
    y <- dplyr_row_slice(y, keep)
  }

  rows_bind(x, y)
}

duckplyr_rows_insert <- function(x, y, ...) {
  try_fetch(
    {
      x <- as_duckplyr_df(x)
      y <- as_duckplyr_df(y)
    },
    error = function(e) {
      testthat::skip(conditionMessage(e))
    }
  )
  out <- rows_insert(x, y, ...)
  class(out) <- setdiff(class(out), "duckplyr_df")
  out
}
