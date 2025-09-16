library(brandr)
library(colorspace)
library(ggplot2)
library(here)
library(svglite)

# set.seed(2025)

plot <-
  data.frame(x = rbeta(10000, 2, 1), y = rbeta(10000, 1, 2)) |>
    ggplot(aes(x, y)) +
    geom_bin_2d(bins = 15) +
    coord_fixed() +
    scale_fill_gradientn(
      colors = c(
        get_brand_color("blue"), # |> lighten(0.1),
        get_brand_color("orange") |> lighten(0.2),
        get_brand_color("orange") |> lighten(0.5),
        get_brand_color("red") |> lighten(0.25)
        # get_brand_color("white")
      ),
    ) +
    xlim(0, 1) +
    ylim(0, 1) +
    theme_void() +
    theme(legend.position = "none")

print(plot) |> suppressWarnings()

ggsave(
  filename = here("images", "gradient.svg"),
  plot = plot
) |>
  suppressWarnings()