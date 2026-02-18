library(checkmate)
library(dplyr)
library(here)
library(magrittr)
library(purrr)
library(terra)
library(tidyr)

here("R", "worldclim_raster.R") |> source()

#' Process LogoClim patch values for comparison with WorldClim GeoTIFF data
#'
#' @description
#'
#' `logoclim_raster()` processes
#' [LogoClim](https://github.com/sustentarea/logoclim) patch values for
#' comparison with [WorldClim](https://www.worldclim.org)
#' [GeoTIFF](https://en.wikipedia.org/wiki/GeoTIFF) data. It handles
#' the rasterization of patch values, aligning them with the WorldClim data's
#' spatial extent.
#'
#' @inheritParams compare_plots
#'
#' @return A [`SpatRaster`] object containing the processed
#'   [LogoClim](https://github.com/sustentarea/logoclim) data.
#'
#' @family logoclim functions
#' @noRd
logoclim_raster <- function(
  tif_file,
  country_shape,
  results,
  layer_pattern = NULL,
  dx = -45,
  remove_extreme_outliers = TRUE
) {
  results_vars <- c(
    "cell_size",
    "first_longitude_of_patches",
    "first_latitude_of_patches",
    "value_of_patches"
  )

  assert_string(tif_file)
  assert_file_exists(tif_file, extension = ".tif")
  assert_class(country_shape, "SpatVector")
  assert_list(results, min.len = 3)
  assert_subset(c("table", "lists"), names(results))
  assert_tibble(results$table)
  assert_tibble(results$lists)
  assert_subset(results_vars, names(results$table))
  assert_list(setup, min.len = 1)
  assert_number(dx, finite = TRUE)
  assert_string(layer_pattern, null.ok = TRUE)
  assert_flag(remove_extreme_outliers)

  worldclim_data <-
    tif_file |>
    worldclim_raster(
      country_shape = country_shape,
      dx = dx,
      layer_pattern = layer_pattern,
      remove_extreme_outliers = remove_extreme_outliers
    )

  worldclim_crs <- worldclim_data |> crs()
  worldclim_ext <- worldclim_data |> ext()

  cell_size <-
    results |>
    pluck("table") |>
    pull(cell_size)

  all.equal(
    worldclim_data |> res() |> mean(),
    cell_size
  )

  results |>
    pluck("lists") |>
    mutate(
      value_of_patches = value_of_patches |>
        map_chr(\(x) na_if(x, "false")) |>
        as.numeric(),
      first_longitude_of_patches = first_longitude_of_patches |>
        divide_by(cell_size) |>
        round(digits = 10) |>
        multiply_by(cell_size),
      first_latitude_of_patches = first_latitude_of_patches |>
        divide_by(cell_size) |>
        round(digits = 10) |>
        multiply_by(cell_size)
    ) |>
    select(
      first_longitude_of_patches,
      first_latitude_of_patches,
      value_of_patches
    ) |>
    rast(type = "xyz", crs = worldclim_crs) |>
    resample(worldclim_data, method = "near")
}
