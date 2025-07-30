# LogoClim

Interface snapshot settings.

## General Settings

- Theme: Light
- Screen resolution: 1920x1080
- Resize the window (see GIF Settings)
- No scrollbars (horizontal or vertical)
- Command center: closed
- No `nls` script visible
- “View updates” checkbox checked
- Default widget settings
- Maintain default settings

## Historical Climate Data (HCD)

- Climate variable: Water vapor pressure (kPa)
- Period: 1970 to the end of the series

## Historical Monthly Weather Data (HMWD)

- Climate variable: Average maximum temperature (°C)
- Period: 2024 to the end of the series
`
## Future Climate Data (FCD)

- Climate Total precipitation (mm)
- Period: 2021 to the end of the series

## GIF Settings

### Window Size

Install `wmctrl` to manage windows (if not already installed).

Use the following for *Ubuntu* Linux:

```bash
sudo apt-get install wmctrl
```

For *Arch* Linux or *Manjaro*:

```bash
sudo pacman -S wmctrl
```

List and identify the window to be included in the GIF with:

```bash
# wmctrl -l
wmctrl -lG
```

Resize the window to `1696`x`807` pixels using with:

> If there are two windows with the same name, use the `-i` option to specify the window ID.

```bash
#gravity,x,y,width,height
wmctrl -r NetLogo -e 0,112,75,1696,807
```

### Sequence (12 months)

- Brazil: HMWD, 10m, 1951, Average maximum temperature
- China: FCD, 10m, 2021-2040, Total precipitation
- UK: HCD, 30s, 1970-2000, Water vapor pressure
- Australia: HMWD, 10m, 2010, Average maximum temperature
- India: FCD, 2.5m, 2081-2100, Total precipitation
- France: HCD, 30s, 1970-2000, Water vapor pressure

```nlogo
go true true
# Clear the command center after
```

### Render

Install `ImageMagick` (if not already installed) to convert the PNG files to a GIF.

Use the following for *Ubuntu* Linux:

```bash
sudo apt-get install imagemagick
```

For *Arch* Linux or *Manjaro*:

```bash
sudo pacman -S imagemagick
```

Use the following for the conversion:

```bash
# sudo apt-get install imagemagick
magick -delay 60 -loop 0 *.png output.gif
```
