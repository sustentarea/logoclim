# LogoClim

Interface snapshot settings.

## General Settings

- Resize the window (see GIF Settings)
- No scrollbars (horizontal or vertical)
- `transition-seconds`: `0.5s`.
- Command center: clear, minimal height
- No `nls` script visible
- “View updates” checkbox checked
- Maintain default settings

## Historical Climate Data (HCD)

- Climate variable: Water vapor pressure (kPa)
- Period: 1970 to the end of the series

## Historical Monthly Weather Data (HMWD)

- Climate variable: Average maximum temperature (°C)
- Period: 1951 to 1961

## Future Climate Data (FCD)

- Climate Total precipitation (mm)
- Period: 2021 to the end of the series

## GIF Settings

### Window Size

Install `wmctrl` to manage windows (if not already installed) with:

```bash
sudo apt-get install wmctrl
```

List and identify the window to be included in the GIF with:

```bash
# wmctrl -l
wmctrl -lG
```

Resize the window to 1485x815 pixels using with:

> If there are two windows with the same name, use the `-i` option to specify the window ID.

```bash
#gravity,x,y,width,height
wmctrl -r NetLogo -e 0,278,182,1485,815
```

### Sequence (12 months)

- Brazil: HMWD, 10m, 1951, Average maximum temperature
- EUA-Mainland: FCD, 10m, 2021, Total precipitation
- Europe-Box: HCD, 10m, 1970, Water vapor pressure
- China: FCD, 10m, 2081, Total precipitation
- Australia: HMWD, 10m, 2010, Water vapor pressure

```nlogo
go true true
# Clear the command center after
```

### Render

```bash
# sudo apt-get install imagemagick
convert -delay 60 -loop 0 *.png output.gif
```
