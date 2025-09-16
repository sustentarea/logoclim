library(beepr)
library(cli)
library(fs)
library(glue)
library(here)
library(stringr)

#' @description
#'
#' This script automates the rendering of `data-munging.qmd` and
#' `data-upload.qmd` Quarto notebooks in a loop, enabling batch processing of
#' multiple data series and countries.

# Set Initial Parameters -----

series <- c(
  "historical-climate-data",
  "historical-monthly-weather-data",
  "future-climate-data"
)

resolution <- "10m" # "10m" "5m" "2.5m" "30s"
model <- NULL
country_codes <- "nor" # "europe" "usa"
country_suffix <- NULL # "box" "mainland"

## Clean the Data Directory -----

here("data") |>
  dir_ls(
    recurse = TRUE,
    type = "file",
    regexp = "\\.zip$|\\.gitignore$",
    invert = TRUE
  ) |>
  file_delete()

here("data") |>
  dir_ls(
    type = "dir",
    regexp = "\\.zip$|\\.gitignore$",
    invert = TRUE
  ) |>
  dir_delete()

for (i in country_codes) {
  ## Rendering the Data Series -----

  for (j in series) {
    cli_progress_step(
      paste0(
        "Rendering {.strong {col_red('",
        j |>
          str_replace_all("-", " ") |>
          str_to_title(),
        "')}} series"
      )
    )

    system(
      glue(
        "quarto render qmd/data-munging.qmd", " ",
        "-P series:'{j}'", " ",
        "-P resolution:'{resolution}'", " ",
        "-P model:",
        ifelse(
          is.null(model),
          "NULL",
          paste0("'", model, "'")
        ), " ",
        "-P country_code:'{i}'"
      )
    )
  }

  ## Store the Data in OSF -----

  data_dirs <-
    here("data") |>
    dir_ls(type = "dir") |>
    basename()

  if (all(series %in% data_dirs, na.rm = TRUE)) {
    cli_progress_step("Storing the data in OSF")

    system(
      glue(
        "quarto render qmd/data-upload.qmd", " ",
        "-P series:'{j}'", " ",
        "-P resolution:'{resolution}'", " ",
        "-P model:",
        ifelse(
          is.null(model),
          "NULL",
          paste0("'", model, "'")
        ), " ",
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

  ## Delete Processed Files -----

  zip_file <-
    here("data") |>
    dir_ls(
      type = "file",
      regexp = paste0(i, ".*\\-", resolution, ".*\\.zip$")
    )

  if (!length(zip_file) == 0) {
    here("data") |>
      dir_ls(
        recurse = TRUE,
        type = "file",
        regexp = "\\.zip$|\\.gitignore$",
        invert = TRUE
      ) |>
      file_delete()

    here("data") |>
      dir_ls(
        type = "dir",
        regexp = "\\.zip$|\\.gitignore$",
        invert = TRUE
      ) |>
      dir_delete()
  } else {
    cli_abort(
      paste0(
        "No zip file was found for the ",
        "{.strong {col_red(str_to_upper(i))}} ",
        " country code."
      )
    )
  }

  beep(11)
}

## Clean Quarto Output Files -----

cli_progress_step("Cleaning Quarto output files")

here("qmd") |>
  dir_ls(
    recurse = TRUE,
    type = "file",
    regexp = "\\.qmd$|\\.gitignore|\\.log$$",
    invert = TRUE
  ) |>
  file_delete()

here("qmd") |>
  dir_ls(
    type = "dir",
    regexp = "\\.qmd$|\\.gitignore$|\\.log$",
    invert = TRUE
  ) |>
  dir_delete()

cli_progress_done()

beep(8)
