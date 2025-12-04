# Load Packages -----

library(brandr)
library(downlit)
library(ggplot2)
library(here)
library(knitr)
library(magrittr)
library(ragg)
library(showtext)
library(sysfonts)
library(xml2)

# Set General Options -----

options(
  dplyr.print_min = 6,
  dplyr.print_max = 6,
  pillar.max_footer_lines = 2,
  pillar.min_chars = 15,
  pillar.sigfig = 5,
  scipen = 10,
  digits = 10,
  stringr.view_n = 6,
  pillar.bold = TRUE,
  width = 77 # 80 - 3 for #> comment
)

# Set Variables -----

set.seed(2025)

# Set `knitr`` -----

clean_cache() |> suppressWarnings()

opts_chunk$set(
  comment = "#>",
  collapse = TRUE,
  root.dir = here(),
  dev = "ragg_png",
  dev.args = list(bg = "transparent"),
  fig.showtext = TRUE
)

# Set `brandr` -----

options(BRANDR_BRAND_YML = here("_brand.yml"))

brandr_options <- list(
  "BRANDR_COLOR_SEQUENTIAL" = get_brand_color(c("primary", "secondary")),
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

# Set `showtext` -----

font_paths(here("ttf"))

font_add(
  family = "inter",
  regular = here("ttf", "inter-24pt-regular.ttf"),
  bold = here("ttf", "inter-24pt-bold.ttf"),
  italic = here("ttf", "inter-24pt-italic.ttf"),
  bolditalic = here("ttf", "inter-24pt-bolditalic.ttf"),
  symbol = NULL
)

showtext_auto()

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
