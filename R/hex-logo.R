library(brandr)
library(colorspace)
library(cropcircles)
library(ggplot2)
library(here)
library(hexSticker)

set.seed(2025)

file <- here("images", "logo.png")

plot <-
  data.frame(x = rbeta(10000, 2, 1), y = rbeta(10000, 1, 2)) |>
    ggplot(aes(x, y)) +
    geom_bin_2d(bins = 10) +
    coord_fixed() +
    scale_fill_gradientn(
      colors = c(
        get_brand_color("blue"),
        get_brand_color("orange") |> lighten(0.2),
        get_brand_color("orange") |> lighten(0.75),
        get_brand_color("orange") |> lighten(1)
        # get_brand_color("red")  |> lighten(0.25)
      ),
    ) +
    xlim(0, 1) +
    ylim(0, 1) +
    theme_void() +
    theme(legend.position = "none")

print(plot) |> suppressWarnings()

sticker(
  subplot = plot,
  s_x = 1,
  s_y = 1,
  s_width = 2.8,
  s_height = 2.8,
  package = NULL,
  h_size = 0,
  h_fill = "white",
  h_color = "white",
  white_around_sticker = TRUE,
  filename = file,
  dpi = 300
)

hex_crop(
  images = file,
  to = file
)
