library(checkmate)
library(here)
library(patchwork)

source(here("R", "_setup.R"))
source(here("R", "tidy_logoclim_data.R"))

plot_comparison <- function(
  tif_file,
  shape,
  output,
  viridis = FALSE
) {
  assert_string(tif_file)
  assert_file_exists(tif_file, extension = ".tif")
  assert_tibble(output)
  assert_class(shape, "SpatVector")
  assert_flag(viridis)

  data_logoclim <- tidy_logoclim_data(output)

  # longitude_range <- range(data_logoclim$longitude, na.rm = TRUE) |> diff()
  # latitude_range <- range(data_logoclim$latitude, na.rm = TRUE) |> diff()

  plot_worldclim <- plot_worldclim(tif_file, shape, output, viridis)
  plot_logoclim <- plot_logoclim(output, viridis)

  wrap_plots(
    plot_worldclim,
    plot_logoclim,
    guides = "collect"
  )
}

library(brandr)
library(checkmate)
library(here)
library(ggplot2)
library(terra)
library(tidyterra)

source(here("R", "tidy_logoclim_data.R"))

plot_worldclim <- function(
  tif_file,
  shape,
  output,
  viridis = FALSE
) {
  assert_string(tif_file)
  assert_file_exists(tif_file, extension = ".tif")
  assert_class(shape, "SpatVector")
  assert_tibble(output)
  assert_flag(viridis)

  data_worldclim <-
    tif_file |>
    rast() |>
    crop(
      shape,
      snap = "near",
      mask = TRUE,
      touches = TRUE,
      extend = TRUE
    )

  data_logoclim <- tidy_logoclim_data(output)

  plot <-
    ggplot() +
    geom_spatraster(data = data_worldclim) +
    scale_x_continuous(n.breaks = 5, labels = \(x) x) +
    scale_y_continuous(n.breaks = 5, labels = \(x) x) +
    labs(
      x = NULL, # "Longitude",
      y = NULL, # "Latitude",
      subtitle = "WordlClim (GeoTIFF Values)",
      fill = NULL
    )

  if (isTRUE(viridis)) {
    plot +
      scale_fill_viridis_c(
        na.value = get_brand_color("gray"),
        limits = range(data_logoclim$value, na.rm = TRUE)
      )
  } else {
    plot +
      scale_fill_brand_c(
        color_type = "div",
        na.value = get_brand_color("gray"),
        limits = range(data_logoclim$value, na.rm = TRUE)
      )
  }
}

library(brandr)
library(checkmate)
library(here)
library(ggplot2)

source(here("R", "_setup.R"))
source(here("R", "tidy_logoclim_data.R"))

plot_logoclim <- function(output, viridis = FALSE) {
  assert_tibble(output)
  assert_flag(viridis)

  data_logoclim <- tidy_logoclim_data(output)

  plot <-
    data_logoclim |>
    ggplot(aes(x = longitude, y = latitude, fill = value)) +
    geom_raster() +
    coord_fixed() +
    scale_x_continuous(n.breaks = 5, labels = \(x) x) +
    scale_y_continuous(n.breaks = 5, labels = \(x) x) +
    labs(
      x = NULL, # "Longitude",
      y = NULL, # "Latitude",
      subtitle = "LogoClim (Patch Values)",
      fill = NULL
    )

  if (isTRUE(viridis)) {
    plot +
      scale_fill_viridis_c(
        na.value = get_brand_color("gray"),
        limits = range(data_logoclim$value, na.rm = TRUE)
      )
  } else {
    plot +
      scale_fill_brand_c(
        color_type = "div",
        na.value = get_brand_color("gray"),
        limits = range(data_logoclim$value, na.rm = TRUE)
      )
  }
}
