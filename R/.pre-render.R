## Load packages -----

library(checkmate)
library(dplyr)
library(fs)
library(here)
library(quartor) # github.com/danielvartan/quartor
library(magrittr)
library(readr)
library(rbbt)
library(stringr)

# Copy images folder to `qmd` directory -----

## This solve issues related to relative paths

qmd_dir <- here("qmd", "images")

if (!test_directory_exists(qmd_dir)) {
  dir.create(qmd_dir) |> invisible()
}

for (i in dir_ls(here("images"), type = "file")) {
  file_copy(
    path = i,
    new_path = path(qmd_dir, basename(i)),
    overwrite = TRUE
  )
}

# Update `CHANGELOG.md` file in `release-notes.qmd` -----

start_pattern <- "%:::% CHANGELOG.md begin %:::%"
end_pattern <- "%:::% CHANGELOG.md end %:::%"

lines <- here("qmd", "release-notes.qmd") |> read_lines()

start_pattern_index <- lines |> str_which(start_pattern)
end_pattern_index <- lines |> str_which(end_pattern)

c(
  lines |>
    magrittr::extract(
      seq(1, start_pattern_index)
    ),
  here("CHANGELOG.md") |>
    read_lines() %>%
    magrittr::extract(
      seq(5, length(.))
      # seq(str_which(., "^## ") |> first(), length(.))
    ) |>
    str_replace_all("^### ", "#### ") |>
    str_replace_all("^## ", "### "),
  lines |>
    magrittr::extract(
      seq(end_pattern_index, length(lines))
    )
) |>
  write_lines(here("qmd", "release-notes.qmd"))
