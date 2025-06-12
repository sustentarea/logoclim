# library(checkmate)
# library(stringr)
# library(orbis) # github.com/danielvartan/orbis

logoclim_readme <- function(
  series = NULL,
  resolution = NULL,
  download_date = NULL
) {
  series_choices <- c(
    "historical-climate-data",
    "historical-monthly-weather-data",
    "future-climate-data"
  )

  resolution_choices <- c("10m", "5m", "2.5m", "30s", "all")

  checkmate::assert_string(series, null.ok = TRUE)
  checkmate::assert_choice(series, series_choices, null.ok = TRUE)
  checkmate::assert_string(resolution, null.ok = TRUE)
  checkmate::assert_choice(resolution, resolution_choices, null.ok = TRUE)
  checkmate::assert_string(
    download_date,
    pattern = "^\\d{4}-\\d{2}-\\d{2}$",
    null.ok = TRUE
  )

  if (!is.null(series) && !is.null(resolution) && !resolution == "all") {
    url <- orbis::get_wc_url(series, resolution)
  } else {
    url <- "https://www.worldclim.org"
  }

  source <- paste0(
    "Based on data from [WorldClim 2.1](", url, ")",
    ifelse(
      !is.null(download_date),
      paste0(", downloaded on ", download_date),
      ""
    )
  )

  if (!is.null(series)) {
    series <-
      series |>
      stringr::str_replace_all("-", " ") |>
      stringr::str_to_title()
  }

  if (!is.null(resolution)) {
    if (resolution == "all") resolution <- "10m, 5m, 2.5m, and 30s"

    resolution <-
      resolution |>
      stringr::str_replace_all("m$", " minutes") |>
      stringr::str_replace("^30s$", "30 seconds")
  }

  paste0(
    "# LogoClim",
    "\n\n",
    ifelse(!is.null(series), paste0("- Series: ", series, "\n"), ""),
    ifelse(
      !is.null(resolution), paste0("- Resolution: ", resolution, "\n"), ""
    ),
    ifelse(!is.null(source), paste0("- Source: ", source, "\n"), ""),
    "- Note: For details on data processing, see: ",
    "<https://github.com/sustentarea/logoclim>",
    "\n\n",
    "> This dataset is licensed under the WorldClim 2.1 Terms of Use, ",
    "available at: <https://worldclim.org/about.html>."
  )
}
