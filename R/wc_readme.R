library(checkmate)
library(stringr)
library(orbis) # github.com/danielvartan/orbis

# # Helpers -----
#
# wc_readme() |> cat()

wc_readme <- function(series = NULL, resolution = NULL) {
  series_choices <- c(
    "historical-climate-data",
    "historical-monthly-weather-data",
    "future-climate-data"
  )

  resolution_choices <- c("10m", "5m", "2.5m", "30s", "all")

  assert_string(series, null.ok = TRUE)
  assert_choice(series, series_choices, null.ok = TRUE)
  assert_string(resolution, null.ok = TRUE)
  assert_choice(resolution, resolution_choices, null.ok = TRUE)

  if (!is.null(series) && !is.null(resolution) && !resolution == "all") {
    source <- get_wc_url(series, resolution)
  } else {
    source <- "https://www.worldclim.org"
  }

  if (!is.null(series)) {
    series <-
      series |>
      str_replace_all("-", " ") |>
      str_to_title()
  }

  if (!is.null(resolution)) {
    if (resolution == "all") resolution <- "10m, 5m, 2.5m, and 30s"

    resolution <-
      resolution |>
      str_replace_all("m$", " minutes") |>
      str_replace("^30s$", "30 seconds")
  }

  paste0(
    "# WorldClim 2.1",
    "\n\n",
    ifelse(!is.null(series), paste0("- Series: ", series, ".", "\n"), ""),
    ifelse(
      !is.null(resolution), paste0("- Resolution: ", resolution, ".", "\n"), ""
    ),
    ifelse(!is.null(source), paste0("- Source: <", source, ">", ".", "\n"), ""),
    "- Note: Downloaded on ", Sys.Date(), ".",
    "\n\n",
    "> This dataset is licensed under the WorldClim 2.1 Terms of Use, ",
    "available at: <https://worldclim.org/about.html>."
  )
}
