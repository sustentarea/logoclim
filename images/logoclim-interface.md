# LogoClim

Interface snapshot settings.

## General Settings

- Theme: Light
- Screen resolution: 1920x1080

- **Turn off Night Light mode**!
- Resize the window (see *Window Size* settings)
- No scrollbars (horizontal or vertical)
- Command center: closed
- No `nls` script visible
- *View updates* enabled
- Maintain default settings

## Window Size

1. Install `wmctrl` to manage windows (if not already installed).
2. Run:

```bash
#gravity,x,y,width,height
wmctrl -r NetLogo -e 0,112,75,1696,807
```

## Screenshots

### Historical Climate Data (HCD)

- Climate variable: Water vapor pressure (kPa)
- Period: 1970 to the end of the series

### Historical Monthly Weather Data (HMWD)

- Climate variable: Average maximum temperature (°C)
- Period: 1951 to the end of the series

### Future Climate Data (FCD)

- Climate Total precipitation (mm)
- Period: 2021 to the end of the series

## GIF Settings

### Sequence (12 months)

- Brazil: HMWD, 10m, 1951, Average maximum temperature
- China: FCD, 10m, 2021-2040, Total precipitation
- UK: HCD, 30s, 1970-2000, Water vapor pressure
- Australia: HMWD, 10m, 2010, Average maximum temperature
- India: FCD, 2.5m, 2081-2100, Total precipitation
- France: HCD, 30s, 1970-2000, Water vapor pressure

```netlogo
go true true
# Clear the command center after
```

### Render

1. Install `ImageMagick` (if not already installed).
2. Run:

```bash
magick -delay 60 -loop 0 *.png output.gif
```
