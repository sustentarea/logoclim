library(checkmate)
library(here)
library(ggplot2)
library(magrittr)
library(terra)

here("R", ".setup.R") |> source()
here("R", "worldclim_raster.R") |> source()
here("R", "logoclim_raster.R") |> source()

#' Plot the difference between WorldClim GeoTIFF and LogoClim patch values
#'
#' @description
#'
#' `plot_difference()` plots the difference between
#' [WorldClim](https://www.worldclim.org)
#' [GeoTIFF](https://en.wikipedia.org/wiki/GeoTIFF) values and
#' [LogoClim](https://github.com/sustentarea/logoclim) patch values.
#' This is useful for visually assessing the spatial distribution of differences
#' between the two datasets.
#'
#' See LogoClim's [`near-equality-tests.qmd`](
#' https://github.com/sustentarea/logoclim/tree/main/qmd) Quarto notebook for
#' examples of how to use this function.
#'
#' @inheritParams compare_plots
#'
#' @return A [`ggplot`][ggplot2::ggplot()] object containing the plot of the
#' difference between the two datasets.
#'
#' @family test functions
#' @noRd
plot_difference <- function(
  tif_file,
  country_shape,
  results,
  setup,
  layer_pattern = NULL,
  dx = -45,
  remove_extreme_outliers = TRUE,
  viridis = FALSE
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
  assert_string(layer_pattern, null.ok = TRUE)
  assert_number(dx, finite = TRUE)
  assert_flag(remove_extreme_outliers)
  assert_flag(viridis)

  logoclim_data <-
    logoclim_raster(
      tif_file = tif_file,
      country_shape = country_shape,
      results = results,
      layer_pattern = layer_pattern,
      dx = dx,
      remove_extreme_outliers = remove_extreme_outliers
    )

  worldclim_data <-
    tif_file |>
    worldclim_raster(
      country_shape = country_shape,
      dx = dx,
      layer_pattern = layer_pattern,
      remove_extreme_outliers = remove_extreme_outliers
    )

  subtitle <- paste0(
    names(setup$variable),
    " (",
    month.name[setup$month],
    " ",
    case_when(
      setup$series == "hcd" ~ "1970-2000",
      setup$series == "hmwd" ~ as.character(setup$year),
      setup$series == "fcd" ~ names(setup$year),
      TRUE ~ ""
    ),
    ")"
  )

  raster_diff <-
    worldclim_data |>
    subtract(
      logoclim_data |>
        resample(worldclim_data, method = "near")
    )

  plot <-
    ggplot() +
    geom_spatraster(data = raster_diff) +
    scale_x_continuous(n.breaks = 5, labels = \(x) x) +
    scale_y_continuous(n.breaks = 5, labels = \(y) y) +
    labs(
      title = "Difference between WorldClim GeoTIFF and LogoClim Patch Values",
      subtitle = subtitle,
      x = NULL,
      y = NULL,
      fill = NULL
    ) +
    theme(
      text = element_text(size = 10)
    )

  if (isTRUE(viridis)) {
    plot +
      scale_fill_viridis_c(
        na.value = get_brand_color("gray")
      )
  } else {
    plot +
      scale_fill_brand_c(
        color_type = "div",
        na.value = get_brand_color("gray")
      )
  }
}
