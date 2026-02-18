library(checkmate)
library(cli)
library(dplyr)
library(testthat)

#' Test near-equality of WorldClim GeoTIFF and LogoClim patch values
#'
#' @description
#'
#' `test_near_equality()` performs near-equality tests between statistics of
#' [WorldClim](https://www.worldclim.org)
#' [GeoTIFF](https://en.wikipedia.org/wiki/GeoTIFF) values and
#' [LogoClim](https://github.com/sustentarea/logoclim) patches using the
#' [`testthat`](https://testthat.r-lib.org/) R package to compare the
#' statistics with a specified relative tolerance.
#'
#' See LogoClim's [`near-equality-tests.qmd`](
#' https://github.com/sustentarea/logoclim/tree/main/qmd) Quarto notebook for
#' examples of how to use this function.
#'
#' @param statistics A [tibble][tibble::tibble()] containing the statistics to
#'   compare, as returned by the [`compare_statistics()`][compare_statistics()].
#' @param check (optional) A [`character`][base::character()] vector specifying
#'   which statistics to check for near-equality
#'   (default: `c("n", "min", "mean", "max")`).
#' @param tolerance (optional) A [`numeric`][base::numeric()] value specifying
#'   the relative tolerance to use when comparing statistics with
#'   [`expect_equal()`][testthat::expect_equal()].
#'
#' @return An [invisible][base::invisible()] `NULL`. This function is called for
#'   its side effects.
#'
#' @family test functions
#' @noRd
test_near_equality <- function(
  statistics,
  check = c("n", "min", "mean", "max"),
  tolerance = 1e-3
) {
  assert_tibble(statistics)
  assert_subset(c("statistic", "worldclim", "logoclim"), names(statistics))
  assert_subset(check, statistics$statistic)
  assert_numeric(tolerance, finite = TRUE, lower = 0)

  for (i in check) {
    cli_progress_step(i)

    statistics |>
      filter(statistic == i) |>
      pull(worldclim) |>
      expect_equal(
        statistics |>
          filter(statistic == i) |>
          pull(logoclim),
        tolerance = tolerance
      )
  }

  cli_progress_done()

  invisible()
}
