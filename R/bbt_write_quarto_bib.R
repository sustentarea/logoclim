# Load packages -----

library(here)
library(quartor) # github.com/danielvartan/quartor

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

bbt_write_quarto_bib(
  bib_file = here("references.bib"),
  dir = c(".", "qmd"),
  pattern = "\\.qmd$",
  wd = here()
)

bbt_write_quarto_bib(
  bib_file = here("paper", "paper.bib"),
  dir = "paper",
  pattern = "\\.md$",
  wd = here()
)
