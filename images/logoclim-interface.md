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

- Climate variable: Water Vapor Pressure (kPa)
- Period: 1970 to the end of the series

### Historical Monthly Weather Data (HMWD)

- Climate variable: Average Maximum Temperature (°C)
- Period: 1951 + 10 years

### Future Climate Data (FCD)

- Climate Total Precipitation (mm)
- Period: 2021 to the end of the series

## GIF Settings

### Sequence (12 months, HCD | 10 years + 1, HMWD | whole series, FCD)

> Disable *View updates* to speed up the process. Don´t forget to enable it again afterwards.
> Use the *Go Forward* button to advance one tick at a time.

- BRA: HMWD, 10m, Average maximum temperature, 1951
- CHN: FCD, 10m, Total precipitation, 2021-2040
- GBR: HCD, 30s, Water vapor pressure, 1970-2000
- AUS: HMWD, 10m, Average maximum temperature, 2010
- IND: FCD, 2.5m, Total precipitation, 2021-2040
- FRA: HCD, 30s, Water vapor pressure, 1970-2000

### Render

1. Install `ImageMagick` (if not already installed).
2. Run:

```bash
magick -delay 60 -loop 0 *.png output.gif
```
