# library(cli)
# library(fs)
# library(here)
# library(stringr)

#' @description
#'
#' This script is used to render the data munging and upload scripts in a loop
#' to process multiple data series and countries.

# Setting Initial Parameters -----

series <- c(
  "historical-climate-data"
  # "historical-monthly-weather-data",
  # "future-climate-data"
)

resolution <- "30s" # "10m"

# country_codes <- "gbr"
country_codes <- c(
  "arg", "aus", "bra", "can", "chl", "cnh", "deu", "esp", "fra", "ind",
  "ita", "nor", "prt", "ury", "zaf"
)

country_suffix <- "hcd" # "box" # "mainland"

for (i in country_codes) {
  ## Rendering the Data Series -----

  for (j in series) {
    cli::cli_progress_step(
      paste0(
        "Rendering {.strong {cli::col_red('",
        j |>
          stringr::str_replace_all("-", " ") |>
          stringr::str_to_title(),
        "')}} series"
      )
    )

    system(
      glue::glue(
        "quarto render qmd/data-munging.qmd", " ",
        "-P series:'{j}'", " ",
        "-P resolution:'{resolution}'", " ",
        "-P country_code:'{i}'"
      )
    )
  }

  ## Storing the Data in OSF -----

  data_dirs <-
    here::here("data") |>
    fs::dir_ls(type = "dir") |>
    basename()

  if (all(series %in% data_dirs, na.rm = TRUE)) {
    cli::cli_progress_step("Storing the data in OSF")

    system(
      glue::glue(
        "quarto render qmd/data-upload.qmd", " ",
        "-P series:'{j}'", " ",
        "-P resolution:'{resolution}'", " ",
        "-P country_code:'{i}'", " ",
        "-P country_suffix:",
        ifelse(
          is.null(country_suffix),
          "NULL",
          paste0("'", country_suffix, "'")
        )
      )
    )
  }

  ## Deleting Processed Files -----

  zip_file <-
    here::here("data") |>
    fs::dir_ls(
      type = "file",
      regexp = paste0(i, "\\-", resolution, "\\.zip$")
    )

  if (!length(zip_file) == 0) {
    here::here("data") |>
      fs::dir_ls(
        recurse = TRUE,
        type = "file",
        regexp = "\\.zip$|\\.gitignore$",
        invert = TRUE
      ) |>
      fs::file_delete()

    here::here("data") |>
      fs::dir_ls(
        type = "dir",
        regexp = "\\.zip$|\\.gitignore$",
        invert = TRUE
      ) |>
      fs::dir_delete()
  } else {
    cli::cli_abort(
      paste0(
        "No zip file was found for the ",
        "{.strong {cli::col_red(stringr::str_to_upper(i))}} ",
        " country code."
      )
    )
  }
}

## Cleaning Quarto Output Files -----

cli::cli_progress_step("Cleaning Quarto output files")

here::here("qmd") |>
  fs::dir_ls(
    recurse = TRUE,
    type = "file",
    regexp = "\\.qmd$|\\.gitignore$",
    invert = TRUE
  ) |>
  fs::file_delete()

here::here("qmd") |>
  fs::dir_ls(
    type = "dir",
    regexp = "\\.qmd$|\\.gitignore$",
    invert = TRUE
  ) |>
  fs::dir_delete()

cli::cli_progress_done()
