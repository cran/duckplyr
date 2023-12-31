# Generated by 02-duckplyr_df-methods.R
#' @export
union.duckplyr_df <- function(x, y, ...) {
  # Our implementation
  check_dots_empty()

  # This is difficult to do manually due to order preservation
  return(distinct(union_all(x, y)))

  # dplyr forward
  union <- dplyr$union.data.frame
  out <- union(x, y, ...)
  return(out)

  # dplyr implementation
  check_dots_empty()
  check_compatible(x, y)

  out <- vec_set_union(x, y, error_call = current_env())

  dplyr_reconstruct(out, x)
}

duckplyr_union <- function(x, y, ...) {
  try_fetch(
    {
      x <- as_duckplyr_df(x)
      y <- as_duckplyr_df(y)
    },
    error = function(e) {
      testthat::skip(conditionMessage(e))
    }
  )
  out <- union(x, y, ...)
  class(out) <- setdiff(class(out), "duckplyr_df")
  out
}
