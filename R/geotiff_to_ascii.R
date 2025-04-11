# library(checkmate)
# library(cli)
# library(fs)
# library(magrittr)
# library(stringr)
# library(terra)

geotiff_to_ascii <- function(
    file, #nolint
    shape = NULL,
    aggregate = NULL,
    dir = dirname(file[1]),
    overwrite = TRUE,
    NAflag = -99999, #nolint
    ...
  ) {
  checkmate::assert_character(file)
  checkmate::assert_file_exists(file, access = "r", extension = "tif")
  checkmate::assert_class(shape, "SpatVector", null.ok = TRUE)
  checkmate::assert_int(aggregate, null.ok = TRUE)
  checkmate::assert_directory_exists(dir, access = "rw")
  checkmate::assert_flag(overwrite)
  checkmate::assert_int(NAflag)

  . <- NULL

  if (!terra::is.polygons(shape)) {
    cli::cli_abort(
      paste0(
        "{.strong {cli::col_red('shape')}} must be a polygon ",
        "of class {.strong SpatVector}. ",
        "See the {.strong terra} R package for more details."
      )
    )
  }

  cli::cli_progress_bar(
    name = "Converting data",
    total = length(file),
    clear = FALSE
  )

  for (i in file) {
    asc_file <-
      stringr::str_replace(i, "(?i)tif$", "asc") |>
      basename() %>%
      fs::path(dir, .)

    # To adjust `historical-climate-data bioclimatic` files.
    if (!stringr::str_detect(asc_file, "[0-9]{4}")) {
      if (stringr::str_detect(asc_file, "(?i)_bio_")) {
        asc_file <- asc_file |> stringr::str_replace("(?i)_bio_", "_bioc_")

        if (!stringr::str_detect(asc_file, "[0-9]{2}\\.asc$")) {
          asc_file <- paste0(
            stringr::str_extract(asc_file, ".*(?=[0-9]{1}\\.asc)"),
            "0",
            stringr::str_extract(asc_file, "[0-9]{1}\\.asc$")
          )
        }

        asc_file <- paste0(
          stringr::str_extract(asc_file, ".*(?=[0-9]{2}\\.asc)"),
          "1970-2000_",
          stringr::str_extract(asc_file, "[0-9]{2}\\.asc$")
        )
      } else if (stringr::str_detect(asc_file, "_[0-9]{2}\\.asc$")) {
        asc_file <- paste0(
          stringr::str_extract(asc_file, ".*(?=[0-9]{2}\\.asc)"),
          "1970-2000-",
          stringr::str_extract(asc_file, "[0-9]{2}\\.asc$")
        )
      } else {
        asc_file <- paste0(
          stringr::str_extract(asc_file, ".*(?=\\.asc)"),
          "_1970-2000.asc"
        )
      }
    }

    data_i <- i |> terra::rast()

    if (!is.null(shape)) {
      data_i <-
        data_i |>
        terra::crop(
          shape,
          snap = "near",
          mask = TRUE,
          touches = TRUE,
          extend = TRUE
        )
    }

    if (!is.null(aggregate)) {
      data_i <- data_i |> terra::aggregate(fact = aggregate)
    }

    # To adjust `future-climate-data` files.
    if (!length(names(data_i)) == 1) {
      if (stringr::str_detect(names(data_i)[1], "^bio")) {
        suffix <- "_"
      } else {
        suffix <- "-"
      }

      asc_file <- paste0(
        stringr::str_extract(asc_file, ".*(?=.asc)"),
        suffix,
        stringr::str_extract(names(data_i), "[0-9]{2}$"),
        ".asc"
      )
    }

    data_i |>
      terra::writeRaster(
        filename = asc_file,
        overwrite = overwrite,
        NAflag = NAflag,
        ...
      )

    cli::cli_progress_update()
  }

  invisible()
}
