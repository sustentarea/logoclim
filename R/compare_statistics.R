library(checkmate)
library(dplyr)
library(here)
library(geodata)
library(magrittr)
library(purrr)
library(terra)
library(tibble)

here("R", "worldclim_raster.R") |> source()

#' Compare statistics of WorldClim GeoTIFF and LogoClim patch values
#'
#' @description
#'
#' `compare_statistics()` compares statistics between
#' [WorldClim](https://www.worldclim.org)
#' [GeoTIFF](https://en.wikipedia.org/wiki/GeoTIFF) values and
#' [LogoClim](https://github.com/sustentarea/logoclim) patches,
#' including absolute differences and relative differences, and tests whether
#' the statistics are equal within a specified relative tolerance.
#'
#' See LogoClim's [`near-equality-tests.qmd`](
#' https://github.com/sustentarea/logoclim/tree/main/qmd) Quarto notebook for
#' examples of how to use this function.
#'
#' @inheritParams compare_plots
#' @param tolerance (optional) A [`numeric`][base::numeric()] value specifying
#'   the relative tolerance to use when comparing statistics with
#'   [`all.equal()`][base::all.equal()] (default: `1e-3`).
#'
#' @return A [tibble][tibble::tibble()] with statistics from both datasets and
#'   indicating whether they are equal within the specified relative tolerance.
#'
#' @family test functions
#' @noRd
compare_statistics <- function(
  tif_file,
  country_shape,
  results,
  layer_pattern = NULL,
  dx = -45,
  remove_extreme_outliers = TRUE,
  tolerance = 1e-3
) {
  results_vars <- c("value_of_patches")

  assert_string(tif_file)
  assert_file_exists(tif_file, extension = ".tif")
  assert_class(country_shape, "SpatVector")
  assert_list(results, min.len = 3)
  assert_subset(c("table", "lists"), names(results))
  assert_tibble(results$table)
  assert_tibble(results$lists)
  assert_subset(results_vars, names(results$table))
  assert_subset(c("table", "lists"), names(results))
  assert_string(layer_pattern, null.ok = TRUE)
  assert_number(tolerance, lower = 0)

  worldclim_data <-
    tif_file |>
    worldclim_raster(
      country_shape = country_shape,
      dx = dx,
      layer_pattern = layer_pattern,
      remove_extreme_outliers = remove_extreme_outliers
    )

  worldclim_values <- worldclim_data |> values(mat = FALSE)

  logoclim_values <-
    results |>
    pluck("lists") |>
    mutate(
      value_of_patches = value_of_patches |>
        map_chr(\(x) na_if(x, "false")) |>
        as.numeric()
    ) |>
    pull(value_of_patches)

  worldclim_values |>
    stats_summary(na_rm = TRUE) |>
    rename(worldclim = value) |>
    left_join(
      logoclim_values |>
        stats_summary(na_rm = TRUE) |>
        rename(logoclim = value),
      by = "name"
    ) |>
    rename(statistic = name) |>
    mutate(
      abs_diff = worldclim |>
        subtract(logoclim) |>
        abs(),
      all.equal = map2_lgl(
        .x = worldclim,
        .y = logoclim,
        .f = \(x, y) all.equal(x, y, tolerance = tolerance) |> isTRUE()
      ),
      tolerance = tolerance,
      threshold = worldclim |>
        subtract(logoclim) |>
        abs() |>
        divide_by(
          pmax(
            abs(worldclim),
            abs(logoclim),
            na.rm = TRUE
          )
        ) %>%
        ifelse(is.nan(.), NA, .)
    )
}

library(checkmate)
library(dplyr)
library(magrittr)
library(moments)
library(tidyr)

stats_summary <- function(
  x,
  na_rm = FALSE,
  iqr_mult = 1.5,
  as_list = FALSE
) {
  assert_numeric(x)
  assert_flag(na_rm)
  assert_number(iqr_mult, lower = 1)
  assert_flag(as_list)

  out <- list(
    n = x |> length(),
    n_rm_na = x %>%
      magrittr::extract(!is.na(.)) |>
      length(),
    n_na = x %>%
      magrittr::extract(is.na(.)) |>
      length()
  )

  if (isTRUE(na_rm)) {
    x <- x |> na.omit()
  }

  out <- list(
    mean = x |> mean(),
    var = x |> var(),
    sd = x |> sd(),
    min = x |> quantile(0) |> unname(),
    q_1 = x |> quantile(0.25) |> unname(),
    median = x |> quantile(0.5) |> unname(),
    q_3 = x |> quantile(0.75) |> unname(),
    max = x |> quantile(1) |> unname(),
    iqr = x |> IQR(),
    range = max(x) - min(x),
    skewness = x |> skewness(),
    kurtosis = x |> kurtosis()
  ) |>
    append(out, values = _)

  if (isTRUE(as_list)) {
    out
  } else {
    out |>
      as_tibble() |>
      pivot_longer(cols = everything())
  }
}
