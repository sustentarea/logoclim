# library(cli)
# library(fs)
# library(here)
# library(stringr)

#' @description
#'
#' This script automates the rendering of `data-munging.qmd` and
#' `data-upload.qmd` Quarto notebooks in a loop, enabling batch processing of
#' multiple data series and countries.

# Setting Initial Parameters -----

series <- c(
  # "historical-climate-data",
  "historical-monthly-weather-data"
  # "future-climate-data"
)

resolution <- "2.5m" # "10m" "5m" "2.5m" "30s" "all"

# "CMCC-ESM2", "EC-Earth3-Veg", "FIO-ESM-2-0"
model <- NULL # NULL
# model <- c(
#   "ACCESS-CM2", "BCC-CSM2-MR", "CMCC-ESM2", "EC-Earth3-Veg", "FIO-ESM-2-0",
#   "GFDL-ESM4", "GISS-E2-1-G", "HadGEM3-GC31-LL", "INM-CM5-0", "IPSL-CM6A-LR",
#   "MIROC6", "MPI-ESM1-2-HR", "MRI-ESM2-0", "UKESM1-0-LL"
# )

country_codes <- "nor" # "europe" "usa"
# country_codes <- c("bra", "ind", "gbr", "nor", "zaf") # 2.5m
# country_codes <- c("bra", "gbr", "nor") # 30s
# country_codes <- c(
#   "arg", "aus", "bra", "can", "chl", "chn", "deu", "esp", "fra", "gbr",
#   "ind", "ita", "nor", "prt", "rus", "ury", "usa", "zaf"
# )

country_suffix <- NULL # "box" "mainland"

## Cleaning the Data Directory -----

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

  ## Deleting Processed Files -----

  zip_file <-
    here::here("data") |>
    fs::dir_ls(
      type = "file",
      regexp = paste0(i, ".*\\-", resolution, ".*\\.zip$")
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
    regexp = "\\.qmd$|\\.gitignore|\\.log$$",
    invert = TRUE
  ) |>
  fs::file_delete()

here::here("qmd") |>
  fs::dir_ls(
    type = "dir",
    regexp = "\\.qmd$|\\.gitignore$|\\.log$",
    invert = TRUE
  ) |>
  fs::dir_delete()

cli::cli_progress_done()

beepr::beep(2)
