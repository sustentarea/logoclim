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
    max_batch_size = NULL,
    rows = NULL
  ) {
  checkmate::assert_data_frame(metadata)
  checkmate::assert_subset(c("url", "size_cum_sum"), colnames(metadata))
  checkmate::assert_directory_exists(dir, access = "w")
  checkmate::assert_integerish(max_batch_size, lower = 1, null.ok = TRUE)
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

  if (!is.null(max_batch_size)) {
    metadata <-
      metadata |>
      dplyr::filter(size_cum_sum <= max_batch_size) # nolint
  }

  if (!is.null(rows)) metadata <- metadata |> dplyr::slice(rows)
  if (nrow(metadata) == 0) cli::cli_abort("No files to download.")

  cli::cli_alert_info(
    paste0(
      "Downloading ",
      "{.strong {cli::col_red(nrow(metadata))}} ",
      "{cli::qty(nrow(metadata))} ",
      "file{?s} to {.strong {dir}}."
    )
  )

  if (nrow(metadata) > 1) cli::cat_line()

  cli::cli_progress_bar(
    name = "Downloading",
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
