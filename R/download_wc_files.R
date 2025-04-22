# library(checkmate)
# library(cli)
# library(curl)
# library(dplyr)
# library(magrittr)
# library(stringr)

download_wc_files <- function(
    metadata, #nolint
    dir,
    model = NULL,
    source = "osf"
  ) {
  checkmate::assert_data_frame(metadata)
  checkmate::assert_subset(c("url", "size_cum_sum"), colnames(metadata))
  checkmate::assert_directory_exists(dir, access = "w")
  checkmate::assert_numeric(rows, lower = 1, null.ok = TRUE)

  models <-
    metadata |>
    magrittr::extract2("file") |>
    stringr::str_extract("(?<=(bioc_|tmin_|tmax_|prec_)).*(?=_ssp)") |>
    unique()

  checkmate::assert_choice(model, models, null.ok = TRUE)

  if (!is.null(model)) {
    metadata <- metadata |> dplyr::filter(stringr::str_detect(file, model))
  }

  if (nrow(metadata) == 0) cli::cli_abort("No files to download.")

  cli::cli_alert_info(
    paste0(
      "Downloading ",
      "{.strong {cli::col_red(nrow(metadata))}} ",
      "{cli::qty(nrow(metadata))} ",
      "file{?s} to {.strong {dir}}"
    )
  )

  if (nrow(metadata) > 1) cli::cat_line()

  cli::cli_progress_bar(
    name = "Downloading data",
    total = nrow(metadata),
    clear = FALSE
  )

  broken_links <- character()

  for (i in metadata$url) {
    test <- try(
      i |>
        curl::curl_download(
          destfile = file.path(dir, basename(i)),
          quiet = TRUE
        ),
      silent = TRUE
    )

    if (class(test) == "try-error") {
      cli::cli_alert_info(
        paste0(
          "The file {.strong {basename(i)}} could not be downloaded."
        )
      )

      broken_links <- broken_links |> append(i)
    }

    cli::cli_progress_update()
  }

  cli::cli_progress_done()

  invisible(broken_links)
}

# library(checkmate)

get_osf_wc_2_1_id <- function(series, resolution = NULL) {
  series_choices <- c(
    "hcd", "historical-climate-data", "historical climate data",
    "hmwd", "historical-monthly-weather-data",
    "historical monthly weather data",
    "fcd", "future-climate-data", "future climate data"
  )

  resolution_choices <- c("all", "10m", "5m", "2.5m", "30s")

  checkmate::assert_choice(series, series_choices)
  checkmate::assert_choice(resolution, resolution_choices, null.ok = TRUE)

  if (series %in% c(
    "hcd", "historical-climate-data", "historical climate data"
  )) {
    "t2jfz"
  } else if (series %in% c(
    "hmwd", "historical-monthly-weather-data",
    "historical monthly weather data"
  )) {
    "rd3q5"
  } else if (series %in% c(
    "fcd", "future-climate-data", "future climate data"
  )) {
    if (is.null(resolution) || resolution == "all") {
      c(
        "10m" = "fz7gv",
        "5m_part_1" = "fbgjh",
        "5m_part_2" = "76atf",
        "2.5m_part_1" = "2fq8m",
        "2.5m_part_2" = "8cqgp",
        "2.5m_part_3" = "xgcve",
        "2.5m_part_4" = "j4rvb",
        "2.5m_part_5" = "q8azg",
        "2.5m_part_6" = "g98z6",
        "30s" = as.character(NA)
      )
    } else {
      if (resolution == "10m") {
        "fz7gv"
      } else if (resolution == "5m") {
        c("5m_part_1" = "fbgjh", "5m_part_2" = "76atf")
      } else if (resolution == "2.5m") {
        c(
          "2.5m_part_1" = "2fq8m",
          "2.5m_part_2" = "8cqgp",
          "2.5m_part_3" = "xgcve",
          "2.5m_part_4" = "j4rvb",
          "2.5m_part_5" = "q8azg",
          "2.5m_part_6" = "g98z6"
        )
      } else if (resolution == "30s") {
        as.character(NA)
      }
    }
  }
}

# library(checkmate)

get_wc_2_1_url <- function(series, resolution = NULL) {
  series_choices <- c(
    "hcd", "historical-climate-data", "historical climate data",
    "hmwd", "historical-monthly-weather-data",
    "historical monthly weather data",
    "fcd", "future-climate-data", "future climate data"
  )

  resolution_choices <- c("all", "10m", "5m", "2.5m", "30s")

  checkmate::assert_choice(series, series_choices)
  checkmate::assert_choice(resolution, resolution_choices, null.ok = TRUE)

  if (series %in% c(
    "hcd", "historical-climate-data", "historical climate data"
  )) {
    "https://worldclim.org/data/worldclim21.html"
  } else if (series %in% c(
    "hmwd", "historical-monthly-weather-data",
    "historical monthly weather data"
  )) {
    "https://worldclim.org/data/monthlywth.html"
  } else if (series %in% c(
    "fcd", "future-climate-data", "future climate data"
  )) {
    if (is.null(resolution) || resolution == "all") {
      c(
        "10m" = "https://worldclim.org/data/cmip6/cmip6_clim10m.html",
        "5m" = "https://worldclim.org/data/cmip6/cmip6_clim5m.html",
        "2.5m" = "https://worldclim.org/data/cmip6/cmip6_clim2.5m.html",
        "30s" = "https://worldclim.org/data/cmip6/cmip6_clim30s.html"
      )
    } else {
      if (resolution == "10m") {
        "https://worldclim.org/data/cmip6/cmip6_clim10m.html"
      } else if (resolution == "5m") {
        "https://worldclim.org/data/cmip6/cmip6_clim5m.html"
      } else if (resolution == "2.5m") {
        "https://worldclim.org/data/cmip6/cmip6_clim2.5m.html"
      } else if (resolution == "30s") {
        "https://worldclim.org/data/cmip6/cmip6_clim30s.html"
      }
    }
  }
}
