library(checkmate)
library(here)
library(magrittr)
library(stats)
library(terra)

compare_statistics <- function(
  tif_file,
  shape,
  results,
  tolerance = 1e-8
) {
  assert_string(tif_file)
  assert_file_exists(tif_file, extension = ".tif")
  assert_class(shape, "SpatVector")
  assert_list(results)
  assert_number(tolerance, lower = 0)

  worldclim_cell_values <-
    tif_file |>
    rast() |>
    crop(
      shape,
      snap = "out",
      mask = TRUE,
      touches = TRUE,
      extend = TRUE
    ) |>
    values(mat = FALSE)

  logoclim_patch_values <-
    results |>
    extract2("lists") |>
    mutate(
      value_of_patches = value_of_patches |>
        map_chr(\(x) na_if(x, "false")) |>
        as.numeric()
    ) |>
    pull(value_of_patches)

  worldclim_cell_values |>
    stats_summary(na_rm = TRUE) |>
    rename(worldclim = value) |>
    left_join(
      logoclim_patch_values |>
        stats_summary(na_rm = TRUE) |>
        rename(logoclim = value),
      by = "name"
    ) |>
    rename(statistic = name) |>
    mutate(
      abs_diff = abs(logoclim - worldclim),
      all.equal = map2_lgl(
        .x = logoclim,
        .y = worldclim,
        .f = \(x, y) all.equal(x, y, tolerance = tolerance) |> isTRUE()
      ),
      tol_used = tolerance,
      min_tol = abs(logoclim - worldclim) / max(abs(logoclim), abs(worldclim))
    )
}

library(checkmate)
library(moments)
library(stats)
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
    n = length(x),
    n_rm_na = length(x[!is.na(x)]),
    n_na = length(x[is.na(x)]),
    mean = mean(x, na.rm = na_rm),
    var = var(x, na.rm = na_rm),
    sd = sd(x, na.rm = na_rm),
    min = quantile(x, 0, na.rm = na_rm) |> unname(),
    q_1 = quantile(x, 0.25, na.rm = na_rm) |> unname(),
    median = quantile(x, 0.5, na.rm = na_rm) |> unname(),
    q_3 = quantile(x, 0.75, na.rm = na_rm) |> unname(),
    max = quantile(x, 1, na.rm = na_rm) |> unname(),
    iqr = IQR(x, na.rm = na_rm),
    range = max(x, na.rm = na_rm) - min(x, na.rm = na_rm),
    skewness = skewness(x, na.rm = na_rm),
    kurtosis = kurtosis(x, na.rm = na_rm)
  )

  if (isTRUE(as_list)) {
    out
  } else {
    out |>
      as_tibble() |>
      pivot_longer(cols = everything())
  }
}
