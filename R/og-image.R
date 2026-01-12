library(brandr)
library(colorspace)
library(ggplot2)
library(here)

set.seed(2025)

file <- here("images", "og-image.png")

plot <-
  data.frame(
    x = rbeta(10000, 2, 1),
    y = rbeta(10000, 1, 2)
  ) |>
  ggplot(aes(x, y)) +
  geom_bin_2d(
    bins = 150,
    binwidth = c((2 / 3) * 0.1, (2 / 3) * 0.1)
  ) +
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
  scale_x_continuous(limits = c(0, 1), expand = c(0, 0)) +
  scale_y_continuous(limits = c(0, 1 / 1.5), expand = c(0, 0)) +
  theme_void() +
  theme(legend.position = "none")

print(plot) |> suppressWarnings()

file |>
  ggsave(
    plot = plot,
    width = 2400,
    height = 1600,
    units = "px",
    dpi = 150,
    bg = "white"
  )
