% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/setdiff-rd.R, R/setdiff.R
\name{setdiff.duckplyr_df}
\alias{setdiff.duckplyr_df}
\title{Set difference}
\usage{
\method{setdiff}{duckplyr_df}(x, y, ...)
}
\arguments{
\item{x, y}{Pair of compatible data frames. A pair of data frames is
compatible if they have the same column names (possibly in different
orders) and compatible types.}

\item{...}{These dots are for future extensions and must be empty.}
}
\description{
This is a method for the \code{\link[dplyr:setops]{dplyr::setdiff()}} generic.
See "Fallbacks" section for differences in implementation.
\code{setdiff(x, y)} finds all rows in \code{x} that aren't in \code{y}.
}
\section{Fallbacks}{

There is no DuckDB translation in \code{setdiff.duckplyr_df()}
\itemize{
\item if column names are duplicated in one of the tables,
\item if column names are different in both tables.
}

These features fall back to \code{\link[dplyr:setops]{dplyr::setdiff()}}, see \code{vignette("fallback")} for details.
}

\examples{
df1 <- duckdb_tibble(x = 1:3)
df2 <- duckdb_tibble(x = 3:5)
setdiff(df1, df2)
setdiff(df2, df1)
}
\seealso{
\code{\link[dplyr:setops]{dplyr::setdiff()}}
}
