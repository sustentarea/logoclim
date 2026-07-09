# Load packages -----

library(beepr)
library(fs)
library(groomr) # github.com/danielvartan/groomr
library(here)
library(quartor) # github.com/danielvartan/quartor

# Remove empty lines from `README.md` -----

here("README.md") |> remove_blank_line_dups()

# Delete unnecessary files and folders -----

clean_quarto_render(
  file = c(".luarc.json"),
  dir = c(
    ".temp",
    "index_cache",
    "index_files",
    "site_libs",
    dir_ls("qmd", type = "dir")
  ),
  # fmt: skip
  ext = c(
    "aux", "bbx", "bcf-SAVE-ERROR", "cbx", "dbx", "fdb_latexmk", "lbx", "loa",
    "log", "otf", "pdf", "scss", "tex", "xdv"
  ),
  ignore = NULL,
  wd = here()
)

# Check if the script ran successfully -----

beep(1)

Sys.sleep(3)
