# library(beepr)
# library(groomr) # github.com/danielvartan/groomr
# library(lubridate)
# library(readr)
# library(stringr)

# Remove empty lines from `README.md` -----

groomr::remove_blank_line_dups(here::here("README.md"))

# Update `LICENSE.md` year -----

file <- here::here("LICENSE.md")

data <-
  file |>
  readr::read_lines() |>
  stringr::str_replace_all(
    pattern = "20\\d{2}",
    replacement = as.character(Sys.Date() |> lubridate::year())
  )

data |> readr::write_lines(file)

# Replace special characters -----

files <- c(
  here::here("README.qmd"),
  here::here("README.md"),
  here::here("nlogo", "logoclim.nlogo")
)

special_characters <- list(
  em_dash = c("–", "-"),
  apostrophe = c("’", "'")
)

for (i in files) {
  for (j in special_characters) {
    data <-
      i |>
      readr::read_lines() |>
      stringr::str_replace_all(
        pattern = j[1],
        replacement = j[2]
      )

    data |> readr::write_lines(i)
  }
}

# Check if the script ran successfully -----

beepr::beep(1)

Sys.sleep(3)
