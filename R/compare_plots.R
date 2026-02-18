library(checkmate)
library(here)
library(ggplot2)
library(patchwork)

here("R", ".setup.R") |> source()
here("R", "worldclim_raster.R") |> source()
here("R", "logoclim_raster.R") |> source()

#' Plot and compare WorldClim GeoTIFF and LogoClim patch values
#'
#' @description
#'
#' `compare_plots()` generates comparative plots for
#' [WorldClim](https://www.worldclim.org)
#' [GeoTIFF](https://en.wikipedia.org/wiki/GeoTIFF) values and
#' [LogoClim](https://github.com/sustentarea/logoclim) patch values. It
#' visualizes the spatial distribution of climate data from WorldClim and the
#' corresponding patch values from LogoClim, allowing for a visual comparison
#' between the two datasets.
#'
#' See LogoClim's [`near-equality-tests.qmd`](
#' https://github.com/sustentarea/logoclim/tree/main/qmd) Quarto notebook for
#' examples of how to use this function.
#'
#' @param tif_file A [`character`][base::character()] string specifying the path
#'   to the [WorldClim](https://www.worldclim.org)
#'   [GeoTIFF](https://en.wikipedia.org/wiki/GeoTIFF) file.
#' @param country_shape A [`SpatVector`][terra::SpatVector()] object
#'   representing a country's spatial extent for cropping the
#'   [WorldClim](https://www.worldclim.org) data, as returned by the
#'   [`gadm()`][geodata::gadm()] function from the
#'   [`geodata`](https://rspatial.github.io/geodata) package.
#' @param results A [`list`][base::list()] containing the results from the
#'   [LogoClim](https://github.com/sustentarea/logoclim) model, as output by
#'   the
#'   [`logolink`](https://danielvartan.github.io/logolink) R package, containing
#'   the [NetLogo](https://www.netlogo.org)
#'   [BehaviorSpace](https://docs.netlogo.org/behaviorspace) output formats
#'   [`table`](https://docs.netlogo.org/behaviorspace#table-output)
#'   and
#'   [`lists`](https://docs.netlogo.org/behaviorspace#lists-output).
#' @param setup A [`list`][base::list()] containing the setup information of
#'   the comparison, as provided by the
#'   [`worldclim_random()`][orbis::worldclim_random()].
#' @param layer_pattern (optional) A [`character`][base::character()] string
#'   specifying the layer pattern to use when subsetting from a multi-layer
#'   [WorldClim](https://www.worldclim.org)
#'   [GeoTIFF](https://en.wikipedia.org/wiki/GeoTIFF) file. When `NULL`, the
#'   first layer is used (default: `NULL`).
#' @param dx (optional) A [`numeric`][base::numeric()] value specifying the
#'   degree of longitude shift to apply when handling spatial data that crosses
#'   the date line (default: `-45`). See the
#'   [`shift_and_rotate()`][orbis::shift_and_rotate()] function from the
#'   [`orbis`](https://danielvartan.github.io/orbis) R package for more details
#'   on this process.
#' @param remove_extreme_outliers (optional) A [`logical`][base::logical()] flag
#'   indicating whether to transform to `NA` values 10 times the interquartile
#'   range ([IQR](https://en.wikipedia.org/wiki/Interquartile_range)) below the
#'   first quartile or above the third quartile of the data values without
#'   duplications. This is useful to remove abnormal values in the raster data
#'   (default: `FALSE`).
#' @param viridis (optional) A [`logical`][base::logical()] flag indicating
#'   whether to use the [Viridis](https://sjmgarnier.github.io/viridis) color
#'   palette for the plots (default: `FALSE`).
#'
#' @return A [`ggplot`][ggplot2::ggplot()] object containing the comparative
#'   plots for [WorldClim](https://www.worldclim.org)
#'   [GeoTIFF](https://en.wikipedia.org/wiki/GeoTIFF) values and
#'   [LogoClim](https://github.com/sustentarea/logoclim) patch values.
#'
#' @family test functions
#' @noRd
compare_plots <- function(
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

  worldclim_plot <-
    worldclim_data |>
    plot_worldclim(
      logoclim_data = logoclim_data,
      viridis = viridis
    )

  logoclim_plot <-
    logoclim_data |>
    plot_logoclim(
      worldclim_data = worldclim_data,
      viridis = viridis
    )

  wrap_plots(
    worldclim_plot,
    logoclim_plot,
    guides = "collect"
  ) +
    plot_annotation(
      title = "WorldClim (GeoTIFF Values) vs LogoClim (Patch Values)",
      subtitle = subtitle
    )
}

library(brandr)
library(checkmate)
library(dplyr)
library(here)
library(ggplot2)
library(orbis) # github.com/danielvartan/orbis
library(purrr)
library(terra)
library(tidyterra)

here("R", ".setup.R") |> source()

plot_worldclim <- function(
  worldclim_data,
  logoclim_data,
  viridis = FALSE
) {
  assert_class(worldclim_data, "SpatRaster")
  assert_class(logoclim_data, "SpatRaster")
  assert_flag(viridis)

  limits <-
    c(
      logoclim_data |> values(mat = FALSE),
      worldclim_data |> values(mat = FALSE)
    ) |>
    na.omit() |>
    boxplot.stats() |>
    pluck("stats") |>
    range()

  plot <-
    ggplot() +
    geom_spatraster(data = worldclim_data) +
    scale_x_continuous(n.breaks = 5, labels = \(x) x) +
    scale_y_continuous(n.breaks = 5, labels = \(y) y) +
    labs(
      x = NULL,
      y = NULL,
      fill = NULL
    ) +
    theme(text = element_text(size = 10))

  if (isTRUE(viridis)) {
    plot +
      scale_fill_viridis_c(
        na.value = get_brand_color("gray"),
        limits = limits
      )
  } else {
    plot +
      scale_fill_brand_c(
        color_type = "div",
        na.value = get_brand_color("gray"),
        limits = limits
      )
  }
}

library(brandr)
library(checkmate)
library(dplyr)
library(here)
library(ggplot2)
library(magrittr)
library(purrr)
library(terra)
library(tidyterra)
library(tidyr)

here("R", ".setup.R") |> source()

plot_logoclim <- function(
  logoclim_data,
  worldclim_data,
  viridis = FALSE
) {
  assert_class(worldclim_data, "SpatRaster")
  assert_class(logoclim_data, "SpatRaster")
  assert_flag(viridis)

  limits <-
    c(
      logoclim_data |> values(mat = FALSE),
      worldclim_data |> values(mat = FALSE)
    ) |>
    na.omit() |>
    boxplot.stats() |>
    pluck("stats") |>
    range()

  plot <-
    ggplot() +
    geom_spatraster(data = logoclim_data) +
    scale_x_continuous(n.breaks = 5, labels = \(x) x) +
    scale_y_continuous(n.breaks = 5, labels = \(y) y) +
    labs(
      x = NULL,
      y = NULL,
      fill = NULL
    ) +
    theme(text = element_text(size = 10))

  if (isTRUE(viridis)) {
    plot +
      scale_fill_viridis_c(
        na.value = get_brand_color("gray"),
        limits = limits
      )
  } else {
    plot +
      scale_fill_brand_c(
        color_type = "div",
        na.value = get_brand_color("gray"),
        limits = limits
      )
  }
}
