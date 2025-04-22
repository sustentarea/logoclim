# library(checkmate)
# library(cli)
# library(dplyr)
# library(magrittr)
# library(stringr)
# library(utils)
# library(zip)

zip_wc_files <- function(
    metadata, #nolint
    model,
    dir,
    broken_links = NULL,
    engine = "utils"
  ) {
  checkmate::assert_tibble(metadata)
  checkmate::assert_subset(c("file", "size"), colnames(metadata))
  checkmate::assert_directory_exists(dir, access = "w")
  checkmate::assert_character(broken_links, null.ok = TRUE)
  checkmate::assert_choice(engine, c("utils", "zip"))

  models <-
    metadata |>
    magrittr::extract2("file") |>
    stringr::str_extract("(?<=(bioc_|tmin_|tmax_|prec_)).*(?=_ssp)") |>
    unique()

  checkmate::assert_subset(model, models)

  zip_dir <- file.path(dir, "zip")
  if (!checkmate::test_directory_exists(zip_dir)) dir.create(zip_dir)

  suffix <-
    metadata |>
    magrittr::extract2("file") |>
    stringr::str_extract("(?<=wc2.1_).*(?=(_bioc|_tmin|_tmax|_prec))") |>
    unique()

  cli::cli_alert_info(
    paste0(
      "Compressing files for ",
      "{.strong {cli::col_red(length(model))}}",
      "{cli::qty(length(model))} ",
      "model{?s}: ",
      "{.strong {model}}."
    )
  )

  for (i in model) {
    files <-
      metadata |>
      magrittr::extract2("file") |>
      stringr::str_subset(i)

    files <- files |> magrittr::extract(!files %in% broken_links)
    files <- files |> magrittr::extract(!is.na(files))

    if (length(files) == 0) {
      cli::cli_alert_info(
        "The model {.strong {cli::col_red(i)}} do not have any files."
      )

      next
    }

    total_size <-
      metadata |>
      dplyr::filter(file %in% files) |>
      magrittr::extract2("size") |>
      sum()

    if (total_size > 5e9) {
      file_chunks <-
        files |>
        split(cut(seq_along(files), ceiling(total_size  / 5e9)))
    } else {
      file_chunks <- list(files)
    }

    cli::cli_alert_info(
      paste0(
        "Compressing files for the ",
        "{.strong {cli::col_red(i)}} model in ",
        "{.strong {length(file_chunks)}}",
        "{cli::qty(length(file_chunks))} ",
        "chunk{?s}."
      )
    )

    cli::cli_progress_bar(
      name = "Compressing chunks",
      total = length(file_chunks),
      type = "tasks",
      clear = FALSE
    )

    for (j in seq_along(file_chunks)) {
      zip_file_name <-
        ifelse(
          length(file_chunks) == 1,
          file.path(zip_dir, paste0(i, "_", suffix, ".zip")),
          file.path(zip_dir, paste0(i, "_", suffix, "_", j, ".zip"))
        )

      if (engine == "zip") {
        zip::zip(
          zipfile = zip_file_name,
          files = file.path(dir, file_chunks[[j]]),
          include_directories = FALSE,
          mode = "cherry-pick"
        )
      } else {
        # Use `zip -h` on Window's command prompt to see the flags.
        utils::zip(
          zipfile = zip_file_name,
          files = file.path(dir, file_chunks[[j]]),
          flags = "-jq"
        )
      }

      cli::cli_progress_update()
    }

    cli::cli_progress_done()
  }

  invisible()
}
