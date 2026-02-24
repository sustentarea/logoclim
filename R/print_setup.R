library(checkmate)
library(cli)

#' Print the setup information of a WorldClim dataset
#'
#' @description
#'
#' `print_setup()` displays the setup information of a WorldClim dataset in a
#' formatted, human-readable way. It is intended for use within the context of
#' comparing WorldClim and LogoClim data.
#'
#' @param setup A [`list`][base::list()] containing the setup information of
#'   the comparison, as provided by
#'   [`worldclim_random()`][orbis::worldclim_random()].
#' @param title (optional) A [`character`][base::character()] string specifying
#'   the title to display for the setup information
#'   (default: `"Selected WorldClim dataset"`).
#'
#' @return An [invisible][base::invisible()] `NULL`. This function is called for
#'   its side effects.
#'
#' @family print functions
#' @noRd
print_setup <- function(setup, title = "Selected WorldClim dataset") {
  assert_list(setup, min.len = 1)
  assert_string(title)

  message <- paste0(title, ":\n\n")

  cli::cli_alert_info(message)

  for (i in names(setup)) {
    value <- setup[[i]]
    label <- names(value)
    value <- unname(value)

    cli_alert(
      paste0("{.field {i}}: {.val {value}} ({label})")
    )
  }

  invisible()
}
