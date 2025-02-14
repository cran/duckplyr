# Generated by 02-duckplyr_df-methods.R
#' @rdname right_join.duckplyr_df
#' @export
right_join.duckplyr_df <- function(x, y, by = NULL, copy = FALSE, suffix = c(".x", ".y"), ..., keep = NULL, na_matches = c("na", "never"), multiple = "all", unmatched = "drop", relationship = NULL) {
  check_dots_empty0(...)
  error_call <- caller_env()
  y <- auto_copy(x, y, copy = copy)

  # Our implementation
  duckplyr_error <- rel_try(list(name = "right_join", x = x, y = y, args = try_list(by = if (!is.null(by) && !is_cross_by(by)) as_join_by(by), copy = copy, keep = keep, na_matches = na_matches, multiple = multiple, unmatched = unmatched, relationship = relationship)),
    #' @section Fallbacks:
    #' There is no DuckDB translation in `right_join.duckplyr_df()`
    #' - for an implicit cross join,
    #' - for a value of the `multiple` argument that isn't the default `"all"`.
    #' - for a value of the `unmatched` argument that isn't the default `"drop"`.
    #'
    #' These features fall back to [dplyr::right_join()], see `vignette("fallback")` for details.
    "No implicit cross joins for {.code right_join()}" = is_cross_by(by),
    "{.arg multiple} not supported" = !identical(multiple, "all"),
    "{.arg unmatched} not supported" = !identical(unmatched, "drop"),
    {
      out <- rel_join_impl(x, y, by, "right", na_matches, suffix, keep, error_call)
      return(out)
    }
  )

  # dplyr forward
  check_prudence(x, duckplyr_error)

  right_join <- dplyr$right_join.data.frame
  out <- right_join(x, y, by, copy = FALSE, suffix, ..., keep = keep, na_matches = na_matches, multiple = multiple, unmatched = unmatched, relationship = relationship)
  return(out)

  # dplyr implementation
  check_dots_empty0(...)
  y <- auto_copy(x, y, copy = copy)
  join_mutate(
    x = x,
    y = y,
    by = by,
    type = "right",
    suffix = suffix,
    na_matches = na_matches,
    keep = keep,
    multiple = multiple,
    unmatched = unmatched,
    relationship = relationship,
    user_env = caller_env()
  )
}

duckplyr_right_join <- function(x, y, ...) {
  try_fetch(
    {
      x <- as_duckplyr_df_impl(x)
      y <- as_duckplyr_df_impl(y)
    },
    error = function(e) {
      testthat::skip(conditionMessage(e))
    }
  )
  out <- right_join(x, y, ...)
  class(out) <- setdiff(class(out), "duckplyr_df")
  out
}
