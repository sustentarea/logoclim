## Load Packages -----

library(checkmate)
library(fs)
library(here)
library(quartor) # github.com/danielvartan/quartor
library(readr)
library(rbbt)
library(stringr)

# Copy Images Folder to `qmd` Directory -----

## *Solve issues related to relative paths

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

# Update `NEWS.md` File in `developer-notes.qmd` -----

start_pattern <- "%:::% NEWS.md begin %:::%"
end_pattern <- "%:::% NEWS.md end %:::%"

lines <- here("qmd", "developer-notes.qmd") |> read_lines()

start_pattern_index <- str_which(lines, start_pattern)
end_pattern_index <- str_which(lines, end_pattern)

c(
  lines |> extract(seq(1, start_pattern_index)),
  '``` {.txt filename="NEWS.md"}',
  here("NEWS.md") |> read_lines(),
  '```',
  lines |> extract(seq(end_pattern_index, length(lines)))
) |>
  write_lines(here("qmd", "developer-notes.qmd"))

# Run `rbbt` -----

#' **IMPORTANT**
#'
#' Leave this code commented out unless you need to regenerate the bibliography
#' for Quarto documents from Zotero using Better BibTeX. This code cannot be run
#' in the CI/CD pipeline because it depends on having Zotero installed locally
#' with Better BibTeX configured.
#'
#' Uncheck the option "Apply title-casing to titles" in Zotero Better BibTeX
#' preferences (Edit > Settings > Better BibTeX > Miscellaneous).
#'
#' (2024-08-25)
#' This function should work with any version of BetterBibTeX (BBT) for Zotero.
#' Verify if @wmoldham PR was merged in the `rbbt` package (see issue #47
#' <https://github.com/paleolimbot/rbbt/issues/47>). If not, install `rbbt` from
#' @wmoldham fork `remotes::install_github("wmoldham/rbbt", force = TRUE)`.

# bbt_write_quarto_bib(
#   bib_file = here("references.bib"),
#   dir = c(".", "qmd"),
#   pattern = "\\.qmd$",
#   wd = here()
# )
