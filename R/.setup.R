# Load Packages -----

library(brandr)
library(downlit)
library(ggplot2)
library(here)
library(knitr)
library(magrittr)
library(ragg)
library(systemfonts)
library(xml2)

# Set General Options -----

options(
  dplyr.print_min = 6,
  dplyr.print_max = 6,
  pillar.max_footer_lines = 2,
  pillar.min_chars = 15,
  scipen = 10,
  digits = 10,
  stringr.view_n = 6,
  pillar.bold = TRUE,
  width = 77 # 80 - 3 for #> comment
)

# Set `knitr`` -----

clean_cache() |> suppressWarnings()

opts_chunk$set(
  comment = "#>",
  collapse = TRUE,
  root.dir = here(),
  dev = "ragg_png"
)

# Set `brandr` -----

options(BRANDR_BRAND_YML = here("_brand.yml"))

brandr_options <- list(
  "BRANDR_COLOR_SEQUENTIAL" = get_brand_color(
    c("primary", "secondary")
  ),
  "BRANDR_COLOR_DIVERGING" = get_brand_color(c(
    "blue",
    "blue-l50",
    "white",
    "orange-l50",
    "orange"
  )),
  "BRANDR_COLOR_QUALITATIVE" = c(
    get_brand_color("primary"),
    get_brand_color("secondary"),
    get_brand_color("tertiary")
  )
)

for (i in seq_along(brandr_options)) {
  options(brandr_options[i])
}

# Set `systemfonts` -----

clear_registry()

register_font(
  name = "inter",
  plain = here("fonts", "inter-24pt-regular.ttf"),
  bold = here("fonts", "inter-24pt-bold.ttf"),
  italic = here("fonts", "inter-24pt-italic.ttf"),
  bolditalic = here("fonts", "inter-24pt-bolditalic.ttf")
)

registry_fonts()

# Set `ggplot2` -----

theme_set(
  theme_bw() +
    theme(
      text = element_text(
        color = get_brand_color("black"),
        size = 10,
        family = "inter",
        face = "plain"
      ),
      panel.grid.major = element_blank(),
      panel.grid.minor = element_blank(),
      legend.frame = element_blank(),
      legend.ticks = element_line(color = "white")
    )
)
