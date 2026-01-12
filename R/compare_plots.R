library(checkmate)
library(dplyr)
library(here)
library(magrittr)
library(patchwork)
library(terra)

source(here("R", ".setup.R"))

compare_plots <- function(
  tif_file,
  shape,
  results,
  setup,
  dx = -45,
  layer = NULL,
  viridis = FALSE
) {
  assert_string(tif_file)
  assert_file_exists(tif_file, extension = ".tif")
  assert_class(shape, "SpatVector")
  assert_list(results, len = 3)
  assert_list(setup, min.len = 1)
  assert_number(dx, finite = TRUE)
  assert_string(layer, null.ok = TRUE)
  assert_flag(viridis)

  cell_size <-
    results |>
    extract2("table") |>
    pull(cell_size)

  lists_data <-
    results |>
    extract2("lists") |>
    mutate(
      value_of_patches = value_of_patches |>
        map_chr(\(x) na_if(x, "false")) |>
        as.numeric()
    )

  patch_values <-
    lists_data |>
    pull(value_of_patches)

  crs <-
    tif_file |>
    rast() |>
    crs()

  subtitle <-
    setup |>
    extract2("variable") |>
    names()

  if (country_shape$GID_0 %in% c("CAN", "USA", "RUS")) {
    round_digits = 0
  } else {
    round_digits = 2
  }

  worldclim_plot <-
    tif_file |>
    plot_worldclim(
      shape = shape,
      patch_values = patch_values,
      subtitle = subtitle,
      dx = dx,
      layer = layer,
      viridis = viridis
    )

  logoclim_plot <-
    lists_data |>
    plot_logoclim(
      cell_size = cell_size,
      subtitle = subtitle,
      crs = crs,
      round_digits = round_digits,
      viridis = viridis
    )

  wrap_plots(
    worldclim_plot,
    logoclim_plot,
    guides = "collect"
  )
}

library(brandr)
library(checkmate)
library(here)
library(ggplot2)
library(orbis) # github.com/danielvartan/orbis
library(terra)
library(tidyterra)

source(here("R", ".setup.R"))

plot_worldclim <- function(
  tif_file,
  shape,
  patch_values,
  subtitle,
  dx = -45,
  layer = NULL,
  viridis = FALSE
) {
  assert_string(tif_file)
  assert_file_exists(tif_file, extension = ".tif")
  assert_class(shape, "SpatVector")
  assert_numeric(patch_values)
  assert_string(subtitle)
  assert_number(dx, finite = TRUE)
  assert_string(layer, null.ok = TRUE)
  assert_flag(viridis)

  worldclim_data <-
    tif_file |>
    rast()

  if (terra::nlyr(worldclim_data) > 1) {
    worldclim_data <- worldclim_data |> subset(layer)
  }

  if (orbis:::test_date_line(shape)) {
    cli::cli_progress_step("Applying date line fix")

    shape <- shape |> shift_and_rotate(dx = dx)
    worldclim_data <- worldclim_data |> shift_and_rotate(dx = dx)

    cli::cli_process_done()
  }

  worldclim_data <-
    worldclim_data |>
    crop(
      shape,
      snap = "out",
      mask = TRUE,
      touches = TRUE,
      extend = TRUE
    )

  plot <-
    ggplot() +
    geom_spatraster(data = worldclim_data) +
    scale_x_continuous(n.breaks = 5, labels = \(x) x) +
    scale_y_continuous(n.breaks = 5, labels = \(y) y) +
    labs(
      x = NULL,
      y = NULL,
      title = "WorldClim (GeoTIFF Values)",
      subtitle = subtitle,
      fill = NULL
    ) +
    theme(
      text = element_text(size = 10)
    )

  if (isTRUE(viridis)) {
    plot +
      scale_fill_viridis_c(
        na.value = get_brand_color("gray"),
        limits = patch_values |> range(na.rm = TRUE)
      )
  } else {
    plot +
      scale_fill_brand_c(
        color_type = "div",
        na.value = get_brand_color("gray"),
        limits = patch_values |> range(na.rm = TRUE)
      )
  }
}

library(brandr)
library(checkmate)
library(dplyr)
library(here)
library(ggplot2)
library(magrittr)
library(terra)
library(tidyterra)

source(here("R", ".setup.R"))

plot_logoclim <- function(
  lists_data,
  cell_size,
  subtitle,
  round_digits = 2,
  crs = "EPSG:4326",
  viridis = FALSE
) {
  assert_tibble(lists_data)
  assert_number(cell_size, lower = 0)
  assert_string(subtitle)
  assert_string(crs)
  assert_int(round_digits, lower = 0)
  assert_flag(viridis)

  patch_values <-
    lists_data |>
    pull(value_of_patches)

  points <-
    lists_data |>
    select(
      first_longitude_of_patches,
      first_latitude_of_patches,
      value_of_patches
    ) |>
    vect(
      geom = c(
        "first_longitude_of_patches",
        "first_latitude_of_patches"
      ),
      crs = crs
    )

  resolution <-
    cell_size |>
    multiply_by(10^round_digits) |>
    divide_by(10^round_digits)

  raster <-
    rasterize(
      points,
      rast(
        ext(points),
        crs = crs,
        resolution = resolution
      ),
      field = "value_of_patches"
    )

  plot <-
    ggplot() +
    geom_spatraster(data = raster) +
    scale_x_continuous(n.breaks = 5, labels = \(x) x) +
    scale_y_continuous(n.breaks = 5, labels = \(y) y) +
    labs(
      x = NULL,
      y = NULL,
      title = "LogoClim (Patch Values)",
      subtitle = subtitle,
      fill = NULL
    ) +
    theme(
      text = element_text(size = 10)
    )

  if (isTRUE(viridis)) {
    plot +
      scale_fill_viridis_c(
        na.value = get_brand_color("gray"),
        limits = patch_values |> range(na.rm = TRUE)
      )
  } else {
    plot +
      scale_fill_brand_c(
        color_type = "div",
        na.value = get_brand_color("gray"),
        limits = patch_values |> range(na.rm = TRUE)
      )
  }
}
