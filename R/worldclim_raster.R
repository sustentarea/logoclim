library(checkmate)
library(cli)
library(dplyr)
library(here)
library(orbis) # github.com/danielvartan/orbis
library(stringr)
library(terra)

#' Process WorldClim GeoTIFF data for comparison with LogoClim patch values
#'
#' @description
#'
#' `worldclim_raster()` processes [WorldClim](https://www.worldclim.org)
#' [GeoTIFF](https://en.wikipedia.org/wiki/GeoTIFF) data for comparison with
#' [LogoClim](https://github.com/sustentarea/logoclim) patch values. It
#' handles cropping to the specified country shape, applying a date line fix if
#' necessary, and optionally removing extreme outliers from the data.
#'
#' @inheritParams compare_plots
#'
#' @return A [`SpatRaster`] object containing the processed
#'   [WorldClim](https://www.worldclim.org) data.
#'
#' @family worldclim functions
#' @noRd
worldclim_raster <- function(
  tif_file,
  country_shape,
  dx = -45,
  layer_pattern = NULL,
  remove_extreme_outliers = TRUE
) {
  assert_string(tif_file)
  assert_file_exists(tif_file, extension = ".tif")
  assert_class(country_shape, "SpatVector")
  assert_number(dx, finite = TRUE)
  assert_string(layer_pattern, null.ok = TRUE)
  assert_flag(remove_extreme_outliers)

  data <- tif_file |> rast()

  if (nlyr(data) > 1) {
    if (is.null(layer_pattern)) {
      cli_abort(
        c(
          "x" = paste0(
            "The GeoTIFF file contains multiple layers. ",
            "Please specify a layer pattern to select the desired layer."
          ),
          "i" = "Available layers: {str_c(names(data), collapse = ', ')}"
        )
      )
    }

    layer <-
      data |>
      names() |>
      str_subset(layer_pattern) |>
      first()

    data <- data |> subset(layer)
  }

  if (test_date_line(country_shape)) {
    cli_progress_step("Applying date line fix")

    country_shape <- country_shape |> shift_and_rotate(dx = dx)
    data <- data |> shift_and_rotate(dx = dx)

    cli_process_done()
  }

  data <-
    data |>
    crop(
      country_shape,
      snap = "out",
      mask = TRUE,
      touches = TRUE,
      extend = TRUE
    )

  if (isTRUE(remove_extreme_outliers)) {
    values <- data |> values(mat = FALSE)

    if (!length(na.omit(values)) < 4) {
      # Remove values more than 10 × IQR from Q1/Q3 to eliminate extreme
      # data errors.
      outliers <- unique_outliers(values, 10)
      values[values %in% outliers] <- NA

      values(data) <- values
    }
  }

  data
}
