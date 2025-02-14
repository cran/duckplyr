% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/union-rd.R, R/union.R
\name{union.duckplyr_df}
\alias{union.duckplyr_df}
\title{Union}
\usage{
\method{union}{duckplyr_df}(x, y, ...)
}
\arguments{
\item{x, y}{Pair of compatible data frames. A pair of data frames is
compatible if they have the same column names (possibly in different
orders) and compatible types.}

\item{...}{These dots are for future extensions and must be empty.}
}
\description{
This is a method for the \code{\link[dplyr:setops]{dplyr::union()}} generic.
\code{union(x, y)} finds all rows in either x or y, excluding duplicates.
The implementation forwards to \code{distinct(union_all(x, y))}.
}
\examples{
df1 <- duckdb_tibble(x = 1:3)
df2 <- duckdb_tibble(x = 3:5)
union(df1, df2)
}
\seealso{
\code{\link[dplyr:setops]{dplyr::union()}}
}
