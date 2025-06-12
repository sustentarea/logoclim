# library(cli)
# library(fs)
# library(here)
# library(stringr)

## Setting Initial Parameters -----

series <- c(
  "historical-climate-data",
  "historical-monthly-weather-data",
  "future-climate-data"
)

resolution <- "10m"

## Rendering the Data Series -----

for (i in series) {
  cli::cli_progress_step(
    paste0(
      "Rendering {.strong {cli::col_red('",
      i |>
        stringr::str_replace_all("-", " ") |>
        stringr::str_to_title(),
      "')}} series"
    )
  )

  system(
    glue::glue(
      "quarto render qmd/data-munging.qmd ",
      "-P series:'{i}' ",
      "-P resolution:'{resolution}'",
    )
  )
}

cli::cli_progress_done()

## Storing the Data in OSF -----

data_dirs <-
  here::here("data") |>
  fs::dir_ls(type = "dir") |>
  basename()

if (all(series %in% data_dirs, na.rm = TRUE)) {
  cli::cli_progress_step("Storing the data in OSF")

  system(
    glue::glue(
      "quarto render qmd/data-upload.qmd ",
      "-P series:'{i}' ",
      "-P resolution:'{resolution}'",
    )
  )
}

cli::cli_progress_done()

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
