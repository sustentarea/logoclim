library(checkmate)
library(dplyr)
library(purrr)
library(stringr)
library(tidyr)

tidy_logoclim_data <- function(output) {
  col_names <- c(
    "pxcor_of_patches", "pycor_of_patches", "value_of_patches",
    "mean_latitude_of_patches", "mean_longitude_of_patches"
  )

  assert_tibble(output)
  assert_subset(col_names, names(output))

  output |>
    select(all_of(col_names)) |>
    rename_with(\(x) str_remove(x, "_of_patches")) |>
    rename_with(\(x) str_remove(x, "mean_")) |>
    unnest(cols = everything()) |>
    mutate(
      value =
        value |>
          list_flatten() |>
          map(\(x) na_if(x, FALSE)) |>
          unlist()
    )
}
