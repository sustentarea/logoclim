# library(beepr)
# library(groomr) # github.com/danielvartan/groomr
# library(readr)
# library(stringr)

# Remove empty lines from `README.md` -----

groomr::remove_blank_line_dups(here::here("README.md"))

# Replace special characters -----

files <- c(
  here::here("README.qmd"),
  here::here("README.md"),
  here::here("nlogox", "logoclim.nlogox")
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
