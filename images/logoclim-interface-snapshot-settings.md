# LogoClim

Interface snapshot settings.

## General Settings

- Fit to width and height, maintaining interface proportions
- No scrollbars (horizontal or vertical)
- Command center: clear, with a height of one line
- No `nls` script visible
- “View updates” checkbox checked
- Maintain default settings

## Historical Climate Data (HCD)

- Climate variable: Wind speed (m s^-1)
- Period: 1970 to the end of the series

## Historical Monthly Weather Data (HMWD)

- Climate variable: Average maximum temperature (°C)
- Period: 1951 to 1961

## Future Climate Data (FCD)

- Climate Total precipitation (mm)
- Period: 2021 to the end of the series

## GIF Settings

```bash
# sudo apt-get install imagemagick
convert -delay 60 -loop 0 *.png output.gif
```
