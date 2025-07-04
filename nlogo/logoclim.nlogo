; LogoClim: WorldClim in NetLogo
;
; Version: 2025-07-03 1.0.0.9000
; Authors: Daniel Vartanian, Leandro Garcia, & Aline M. de Carvalho
; Maintainer: Daniel Vartanian <https://github.com/danielvartan>
; License: MIT
; Repository: https://github.com/sustentarea/logoclim
;
; Require: NetLogo >= 6.4
; Required NetLogo extensions: `gis`, `pathdir`, `string`, and `time`

__includes [
  "nls/as-list.nls"
  "nls/as-string.nls"
  "nls/adjust-patch-size.nls"
  "nls/adjust-world-size.nls"
  "nls/check-abs.nls"
  "nls/check-all.nls"
  "nls/check-any.nls"
  "nls/check-atomic.nls"
  "nls/check-between.nls"
  "nls/check-choice.nls"
  "nls/check-climate-variable.nls"
  "nls/check-data-resolution.nls"
  "nls/check-data.nls"
  "nls/check-empty.nls"
  "nls/check-gis.nls"
  "nls/check-integer.nls"
  "nls/check-list.nls"
  "nls/check-logical.nls"
  "nls/check-nan.nls"
  "nls/check-number.nls"
  "nls/check-start-year.nls"
  "nls/check-string.nls"
  "nls/check-windows.nls"
  "nls/check-world-bleed.nls"
  "nls/collapse.nls"
  "nls/file-path.nls"
  "nls/go-back.nls"
  "nls/halt.nls"
  "nls/list-files-by-pattern.nls"
  "nls/lookup-bioclimatic-variable.nls"
  "nls/lookup-climate-variable.nls"
  "nls/lookup-data-resolution.nls"
  "nls/lookup-fcd-interval.nls"
  "nls/lookup-series-color.nls"
  "nls/lookup-series-data-path.nls"
  "nls/lookup-shared-socioeconomic-pathway.nls"
  "nls/nan-value.nls"
  "nls/normalize-path.nls"
  "nls/num-to-str-month.nls"
  "nls/pattern-data-file.nls"
  "nls/pattern-fcd-file.nls"
  "nls/pattern-hcd-file.nls"
  "nls/pattern-hmwd-file.nls"
  "nls/quartile.nls"
  "nls/remove-world-bleed.nls"
  "nls/rep-collapse.nls"
  "nls/setup-hcd-variables.nls"
  "nls/setup-hmwd-variables.nls"
  "nls/setup-fcd-variables.nls"
  "nls/setup-map.nls"
  "nls/setup-stats.nls"
  "nls/setup-variables.nls"
  "nls/setup-world.nls"
  "nls/setup-world-bleed.nls"
  "nls/show-values.nls"
  "nls/single-quote.nls"
  "nls/str-extract.nls"
  "nls/str-to-num-month.nls"
  "nls/unique-outliers.nls"
  "nls/walk.nls"
]

extensions [
  gis
  pathdir
  string
  time
]

globals [
  dataset
  files
  index
  max-pcolor-value
  max-plot-y
  max-value
  min-pcolor-value
  min-plot-y
  min-value
  month
  months
  nan
  series-data-path
  settings
  world-bleed
  year
  years
]

patches-own [
  latitude
  longitude
  value
]

to setup
  clear-all

  assert-climate-variable
  assert-data-resolution
  assert-start-year
  assert-data

  setup-variables
  setup-world
  setup-map
  setup-stats

  reset-ticks
end

to go [#tick? #wait?]
  assert-logical #tick?
  assert-logical #wait?

  (ifelse
    (not is-gis? dataset) [
      stop
    ] (
      (
        (year = last years) and
        (month = "December")
      ) or
      (climate-variable = "Elevation") or
      (
        (data-series = "Historical climate data") and
        (climate-variable = "Bioclimatic variables")
      ) or
      (
        (data-series = "Future climate data") and
        (climate-variable = "Bioclimatic variables") and
        (year = last years)
      )
    ) [
      stop
    ] [
      set index index + 1
    ]
  )

  walk index

  if (#tick? = true) [tick]
  if (#wait? = true) [wait transition-seconds]
end
@#$#@#$#@
GRAPHICS-WINDOW
455
10
1005
489
-1
-1
2.0
1
10
1
1
1
0
0
0
1
-135
135
-117
117
0
0
1
Months
30.0

CHOOSER
10
10
220
55
data-series
data-series
"Historical climate data" "Historical monthly weather data" "Future climate data"
1

CHOOSER
10
60
220
105
data-resolution
data-resolution
"30 seconds (~1 km2  at the equator)" "2.5 minutes (~21 km2 at the equator)" "5 minutes (~85 km2 at the equator)" "10 minutes (~340 km2 at the equator)"
3

CHOOSER
10
110
220
155
climate-variable
climate-variable
"Average minimum temperature (°C)" "Average maximum temperature (°C)" "Average temperature (°C)" "Total precipitation (mm)" "Solar radiation (kJ m^-2 day^-1)" "Wind speed (m s^-1)" "Water vapor pressure (kPa)" "Bioclimatic variables" "Elevation"
1

CHOOSER
10
160
220
205
global-climate-model
global-climate-model
"ACCESS-CM2" "ACCESS-ESM1-5" "BCC-CSM2-MR" "CanESM5" "CanESM5-CanOE" "CMCC-ESM2" "CNRM-CM6-1" "CNRM-CM6-1-HR" "CNRM-ESM2-1" "EC-Earth3-Veg" "EC-Earth3-Veg-LR" "FIO-ESM-2-0" "GFDL-ESM4" "GISS-E2-1-G" "GISS-E2-1-H" "HadGEM3-GC31-LL" "INM-CM4-8" "INM-CM5-0" "IPSL-CM6A-LR" "MIROC-ES2L" "MIROC6" "MPI-ESM1-2-HR" "MPI-ESM1-2-LR" "MRI-ESM2-0" "UKESM1-0-LL"
5

CHOOSER
10
210
220
255
shared-socioeconomic-pathway
shared-socioeconomic-pathway
"SSP-126" "SSP-245" "SSP-370" "SSP-585"
3

CHOOSER
10
260
220
305
bioclimatic-variable
bioclimatic-variable
"BIO1 - Annual mean temperature" "BIO2 - Mean diurnal range (mean of monthly (max temp - min temp))" "BIO3 - Isothermality (BIO2/BIO7) (×100)" "BIO4 - Temperature seasonality (standard deviation ×100)" "BIO5 - Max temperature of warmest month" "BIO6 - Min temperature of coldest month" "BIO7 - Temperature annual range (BIO5-BIO6)" "BIO8 - Mean temperature of wettest quarter" "BIO9 - Mean temperature of driest quarter" "BIO10 - Mean temperature of warmest quarter" "BIO11 - Mean temperature of coldest quarter" "BIO12 - Annual precipitation" "BIO13 - Precipitation of wettest month" "BIO14 - Precipitation of driest month" "BIO15 - Precipitation seasonality (coefficient of variation)" "BIO16 - Precipitation of wettest quarter" "BIO17 - Precipitation of driest quarter" "BIO18 - Precipitation of warmest quarter" "BIO19 - Precipitation of coldest quarter"
0

CHOOSER
10
310
220
355
start-month
start-month
"January" "February" "March" "April" "May" "June" "July" "August" "September" "October" "November" "December"
0

INPUTBOX
10
360
220
420
start-year
1951.0
1
0
Number

BUTTON
10
425
220
460
Select data directory
set data-path user-directory
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

INPUTBOX
10
465
220
525
data-path
../data
1
0
String

BUTTON
10
530
220
565
Show values
show-values
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
230
10
330
45
Setup
setup
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

BUTTON
340
10
440
45
Go
go true true
T
1
T
OBSERVER
NIL
G
NIL
NIL
1

BUTTON
230
50
330
85
Go back
go-back
NIL
1
T
OBSERVER
NIL
A
NIL
NIL
1

BUTTON
340
50
440
85
Go forward
go false false
NIL
1
T
OBSERVER
NIL
D
NIL
NIL
1

SLIDER
230
90
440
123
transition-seconds
transition-seconds
0
3
0.0
0.1
1
s
HORIZONTAL

SWITCH
230
128
440
161
adjust-world-size?
adjust-world-size?
0
1
-1000

INPUTBOX
230
166
440
226
historical-climate-data-color
105.0
1
0
Color

INPUTBOX
230
231
440
291
historical-monthly-weather-data-color
25.0
1
0
Color

INPUTBOX
230
296
440
356
future-climate-data-color
15.0
1
0
Color

INPUTBOX
230
361
440
421
background-color
9.0
1
0
Color

SLIDER
230
426
440
459
black-value
black-value
-500
500
0.0
1
1
NIL
HORIZONTAL

SWITCH
230
464
440
497
black-min
black-min
1
1
-1000

SLIDER
230
502
440
535
white-value
white-value
-500
500
50.0
1
1
NIL
HORIZONTAL

SWITCH
230
540
440
573
white-max
white-max
0
1
-1000

MONITOR
1020
10
1230
55
Climate variable
ifelse-value\n  (settings = 0)\n  [\"NA\"]\n  [item 2 settings]
0
1
11

MONITOR
1240
10
1340
55
Year
ifelse-value \n  (settings = 0)\n  [\"NA\"]\n  [year]
0
1
11

MONITOR
1350
10
1450
55
Month
ifelse-value \n  ((settings = 0))\n  [\"NA\"]\n  [month]
0
1
11

MONITOR
1020
60
1450
105
Bioclimatic variable
ifelse-value\n  (lookup-climate-variable = \"bioc\") and (settings != 0)\n  [item 5 settings]\n  [\"NA\"]
0
1
11

PLOT
1020
110
1230
290
Mean
Months
Value
0.0
0.0
0.0
0.0
true
false
"set-plot-y-range min-plot-y max-plot-y" "set-plot-x-range 0 (ifelse-value (ticks = 0) [1] [ceiling (ticks * 1.25)])"
PENS
"default" 1.0 0 -16777216 true "" "plot mean [value] of patches with [not is-nan? value]"

MONITOR
1020
295
1230
340
Mean
mean [value] of patches with [not is-nan? value]
5
1
11

PLOT
1020
345
1230
525
Minimum
Months
Value
0.0
0.0
0.0
0.0
true
false
"set-plot-y-range min-plot-y max-plot-y" "set-plot-x-range 0 (ifelse-value (ticks = 0) [1] [ceiling (ticks * 1.25)])"
PENS
"default" 1.0 0 -16777216 true "" "plot min [value] of patches with [not is-nan? value]"

MONITOR
1020
530
1230
575
Minimum
min [value] of patches with [not is-nan? value]
5
1
11

PLOT
1240
110
1450
290
Standard Deviation
Months
Value
0.0
0.0
0.0
0.0
true
false
"set-plot-y-range min-plot-y max-plot-y" "set-plot-x-range 0 (ifelse-value (ticks = 0) [1] [ceiling (ticks * 1.25)])"
PENS
"default" 1.0 0 -16777216 true "" "plot standard-deviation [value] of patches with [not is-nan? value]"

MONITOR
1240
295
1450
340
Standard deviation
standard-deviation [value] of patches with [not is-nan? value]
5
1
11

PLOT
1240
345
1450
525
Maximum
Months
Value
0.0
0.0
0.0
0.0
true
false
"set-plot-y-range min-plot-y max-plot-y" "set-plot-x-range 0 (ifelse-value (ticks = 0) [1] [ceiling (ticks * 1.25)])"
PENS
"default" 1.0 0 -16777216 true "" "plot max [value] of patches with [not is-nan? value]"

MONITOR
1240
530
1450
575
Maximum
max [value] of patches with [not is-nan? value]
5
1
11

@#$#@#$#@
# LOGOCLIM: WORLDCLIM 2.1 IN NETLOGO

## WHAT IS IT?

`LogoClim` is a [NetLogo](https://ccl.northwestern.edu/netlogo/) model for simulating and visualizing global climate conditions. It allows researchers to integrate high-resolution climate data into agent-based models, supporting reproducible research in ecology, agriculture, environmental science, and other fields that rely on climate data integration.

The model utilizes raster data to represent climate variables such as temperature and precipitation over time. It incorporates historical data (1951-2024) and future climate projections (2021-2100) derived from global climate models under various Shared Socioeconomic Pathways ([SSPs](https://climatedata.ca/resource/understanding-shared-socio-economic-pathways-ssps/), O'Neill et al. ([2017](https://doi.org/10.1016/j.gloenvcha.2015.01.004))). All climate inputs come from [WorldClim 2.1](https://worldclim.org/), a widely used source of high-resolution, interpolated climate datasets based on weather station observations worldwide ([Fick & Hijmans, 2017](https://doi.org/10.1002/joc.5086)).

> `LogoClim` is an independent project with no affiliation to [WorldClim](https://worldclim.org/) or its developers. Users should be aware that WorldClim datasets are freely available for academic and other non-commercial use only. Any use of WorldClim data within `LogoClim` must comply with [WorldClim's licensing terms](https://worldclim.org/about.html).

## HOW IT WORKS

`LogoClim` operates on a grid of patches, where each patch represents a geographical area and stores values for latitude, longitude, and selected climate variables. During the simulation, patches update their colors based on the data values. The results can be visualized on a map, accompanied by plots that display the mean, minimum, maximum, and standard deviation of the selected variable over time.

### COLOR SCALE

The model uses a color scale ranging from black (representing the lowest value) to white (representing the highest value). Users can adjust the thresholds for these colors using the **`black-value`** and **`white-value`** sliders. Alternatively, users can set the black or white color to automatically represent the minimum or maximum value of the current data by toggling the **`black-min`** and **`white-max`** switches. By default, the black threshold is set to 0, and the white threshold corresponds to the maximum value of the current data.

### DATA SERIES

In addition to latitude and longitude data points, `LogoClim` supports simulation with all three climate data series provided by [WorldClim 2.1](https://worldclim.org/): long-term historical climate averages, historical monthly weather, and future climate projections. Each series is available at multiple spatial resolutions (from 10 minutes (~340 km² at the equator) to 30 seconds (~1 km² at the equator)) and can be selected within the model interface to fit your research needs. More information about each series can be found in the WorldClim website.

#### HISTORICAL CLIMATE DATA

This series includes only 12 monthly data points representing long-term average climate conditions for the period 1970-2000. It provides averages on minimum, mean, and maximum temperature, precipitation, solar radiation, wind speed, vapor pressure, elevation, and on bioclimatic variables.

#### HISTORICAL MONTHLY WEATHER DATA

This series includes 12 monthly data points for each year from 1951 to 2024, based on [downscaled](https://worldclim.org/data/downscaling.html) data from [CRU-TS-4.09](https://crudata.uea.ac.uk/cru/data/hrg/cru_ts_4.09/), developed by the [Climatic Research Unit](https://www.uea.ac.uk/groups-and-centres/climatic-research-unit) at the [University of East Anglia](https://www.uea.ac.uk/). It provides monthly averages for minimum temperature, maximum temperature, and total precipitation.

#### FUTURE CLIMATE DATA

This series includes 12 monthly data points from [downscaled](https://worldclim.org/data/downscaling.html) climate projections derived from [CMIP6](https://www.wcrp-climate.org/wgcm-cmip/wgcm-cmip6) models for four future periods: 2021-2040, 2041-2060, 2061-2080, and 2081-2100. The projections cover four [SSPs](https://climatedata.ca/resource/understanding-shared-socio-economic-pathways-ssps/): 126, 245, 370, and 585, with data available for average minimum temperature, average maximum temperature, total precipitation, and bioclimatic variables.

## HOW TO USE IT

### SETUP

`LogoClim` was developed using NetLogo 6.4, so it is recommended to use this version or later.

The model relies on the GIS ([`gis`](https://github.com/NetLogo/GIS-Extension)), Pathdir ([`pathdir`](https://github.com/cstaelin/Pathdir-Extension)), String ([`string`](https://github.com/NetLogo/String-Extension)), and Time ([`time`](https://github.com/NetLogo/Time-Extension/)) NetLogo extensions. These are automatically installed when the model is run for the first time.

To run the model, make sure to download all files in the repository `nlogo` folder. Note that climate data from WorldClim is required but not included in this repository; see the next section for instructions on obtaining and preparing the data.

#### DOWNLOADING THE DATA

`LogoClim` relies on raster data to represent climate variables. The datasets are available for download from [WorldClim 2.1](https://worldclim.org/), but must be converted to ASCII format for compatibility with NetLogo. To simplify this workflow, we provide [Quarto](https://quarto.org/) notebooks in the repository `qmd` folder with reproducible pipelines for downloading and processing the data. These notebooks can be customized to meet specific research needs.

We also provide example datasets for testing and demonstration. These files are available in the model's [OSF repository](https://doi.org/10.17605/OSF.IO/RE95Z) and are ready to use with `LogoClim`.

After downloading and processing the files, place them in the `data` folder within the model's directory. Alternatively, you can use the *Select data directory* button in the model interface to specify the location of your data files.

We suggest starting with the 10-minute resolution to verify that the model runs smoothly on your system before trying higher resolutions.

#### RUNNING THE MODEL

Once everything is set up, click the `Setup` and `Go` buttons to start exploring!

### INTEGRATING WITH OTHER MODELS

`LogoClim` can be integrated with other models using NetLogo's LevelSpace ([`ls`](https://ccl.northwestern.edu/netlogo/docs/ls.html)) extension. This extension enables parallel execution and data exchange between models. For an example of integrating `LogoClim` with another model, see the [FoodClim](https://github.com/sustentarea/foodclim) project.

### INTERFACE CONTROLS

#### CHOOSERS, INPUT BOXES, AND SLIDERS

- **`data-series`**: Chooser for selecting a data series (default: `Historical monthly weather data`).
- **`data-resolution`**: Chooser for selecting the spatial resolution of the data, expressed in minutes of a degree of latitude/longitude (default: `10 minutes (~340 km2 at the equator)`).
- **`climate-variable`**: Chooser for selecting the climate variable (default: `Average maximum temperature (°C)`).
- **`global-climate-model`**: Chooser for selecting a global climate model. Only useful when *`Future climate data`* is selected (default: `CMCC-ESM2`).
- **`shared-socioeconomic-pathway`**: Chooser for selecting a Shared Socioeconomic Pathway ([SSP](https://climatedata.ca/resource/understanding-shared-socio-economic-pathways-ssps/)) scenario. Only useful when *`Future climate data`* is selected (default: `SSP-585`).
- **`bioclimatic-variable`**: Chooser for selecting a [bioclimatic variable](https://worldclim.org/data/bioclim.html). Only useful when *`climate-variable`* is set to *`bioclimatic-variables`* (default: `BIO1 - Annual mean temperature`).
- **`start-month`**: Chooser for selecting the simulation's starting month (default: `January`).
- **`start-year`**: Input box for setting the simulation's start year in `YYYY` format (default: `1951`).
- **`data-path`**: Input box for setting the path to the data folder. Usually, this does not need to be changed. Use the *`Select data directory`* button to navigate via a dialog window (default: `../data/`).
- **`transition-seconds`**: Slider for controlling the speed of time progression in the simulation (in seconds per step/month) (default: `0.0`).
- **`adjust-world-size?`**: Switch for automatically adjusting the world size. If it is set to *`On`*, the model will resize the world to fit the available interface space. If it is set to *`Off`*, the world size remains fixed, and each patch has a size of `1` (default: `On`).
- **`historical-climate-color`**: Input box for setting the color used to represent the *historical climate data* series (default: `105 (blue)`).
- **`historical-monthly-weather-color`**: Input box for setting the color used to represent the *historical monthly weather data* series (default: `25 (orange)`).
- **`future-climate-color`**: Input box for setting the color used to represent the *future climate data* series (default: `15 red)`).
- **`black-value`**: Slider for setting the lower threshold for the black color on the map (default: `0`).
- **`black-min`**: Switch for setting the black color threshold to the minimum value of the current dataset. If it is set to *`On`*, *`black-value`* will be ignored (default: `Off`).
- **`white-value`**: Slider for setting the upper threshold for the white color on the map (default: `50`).
- **`white-max`**: Switch for setting the white color threshold to the maximum value of the current dataset. If it is set to *`On`*, *`white-value`* will be ignored (default: `On`).

#### BUTTONS

- **`Setup`**: Initializes the simulation with the selected parameters.
- **`Go`**: Starts or resumes the simulation.
- **`Go back`**: Steps the simulation backward in time.
- **`Go forward`**: Steps the simulation forward in time.
- **`Select data directory`**: Opens a dialog window, allowing the user to indicate the data directory.
- **`Show values`**: Displays patch values when hovering the mouse over them.

### MONITORS AND PLOTS

- **`Climate variable`**: Displays the climate variable being used.
- **`Bioclimatic variable`**: Displays the bioclimatic variable being used. Works only when *`climate-variable`* is set to *`bioclimatic-variables`*.
- **`Year`**, **`Month`**: Displays the current year and month being simulated.
- **`Min`**, **`Max`**, **`Mean`**, **`SD`**: Monitors showing the minimum, maximum, mean, and standard deviation values for the climate variable across the patches.
- **`Plots`**: Graphs for mean, minimum, maximum, and standard deviation against time.

### PATCH ATTRIBUTES

- **`value`**: A number representing the series value at the patch point.
- **`latitude`**: A `list` of two numbers indicating the minimum and maximum latitude of the patch point.
- **`longitude`**: A `list` of two numbers indicating the minimum and maximum longitude of the patch point.

## THINGS TO NOTICE

- Observe the changes in the map as the simulation progresses, particularly how the colors (values) vary over time and space.
- Pay attention to the plots and monitors to see trends and variation in the climate variable across different time periods.
- Notice the differences when switching between historical data and future projections, especially for different SSP scenarios.

## THINGS TO TRY

- Change the starting year and month to observe different historical periods or future projections.
- Switch between different climate variables to see how each variable evolves over time.
- Experiment with various global climate models and SSPs to explore a range of future scenarios.
- Adjust the transition speed to slow down or speed up the simulation for detailed observation or quicker results.

## HOW TO CITE

> When using WorldClim data, you must also cite the original data sources. The appropriate citation depends on the specific dataset utilized. Please refer to the [WorldClim website](https://www.worldclim.org/data/index.html#citation) for up-to-date citation guidelines and dataset references.

If you use this model in your research, please cite it to acknowledge the effort invested in its development and maintenance. Your citation helps support the ongoing improvement of the model.

To cite `LogoClim` in publications please use the following format:

Vartanian, D., Garcia, L., & Carvalho, A. M. (2025). *LogoClim: WorldClim in NetLogo* [Computer software, NetLogo model]. [https://doi.org/10.17605/OSF.IO/EAPZU](https://doi.org/10.17605/OSF.IO/EAPZU)

A BibTeX entry for LaTeX users is:

```latex
@Misc{vartanian2025,
  title = {LogoClim: WorldClim in NetLogo},
  author = {{Daniel Vartanian} and {Leandro Garcia} and {Aline Martins de Carvalho}},
  year = {2025},
  doi = {10.17605/OSF.IO/EAPZU},
  note = {NetLogo model}
}
```

## HOW TO CONTRIBUTE

![Contributor Covenant 2.1 badge](images/contributor-covenant-2-1-badge.png)

Contributions are welcome! Whether it's reporting bugs, suggesting features, or improving documentation, your input is valuable.

![GitHub Sponsor badge](images/github-sponsor-badge.png)

You can also support the development of `LogoClim` by becoming a sponsor. Click [here](https://github.com/sponsors/danielvartan) to make a donation. Please mention `LogoClim` in your donation message.

## IMPORTANT LINKS

- OSF repository: https://doi.org/10.17605/OSF.IO/EAPZU
- Code repository: https://github.com/sustentarea/logoclim
- Latest release: https://github.com/sustentarea/logoclim/releases/latest
- Data repository: https://doi.org/10.17605/OSF.IO/RE95Z
- Support development: https://github.com/sponsors/danielvartan

## LICENSE

![MIT license badge](images/mit-license-badge.png)

The `LogoClim` code is licensed under the [MIT License](https://opensource.org/license/mit). This means you can use, modify, and distribute the code freely, as long as you include the original license and copyright notice in any copies or substantial portions of the software.

## ACKNOWLEDGMENTS

We gratefully acknowledge [Stephen E. Fick](https://orcid.org/0000-0002-3548-6966), [Robert J. Hijmans](https://orcid.org/0000-0001-5872-2872), and the entire [WorldClim](https://worldclim.org/) team for their outstanding work in creating and maintaining the WorldClim datasets, which form the foundation of this project.

We thank the [Climatic Research Unit](https://www.uea.ac.uk/groups-and-centres/climatic-research-unit) at the [University of East Anglia](https://www.uea.ac.uk/) and the United Kingdom's [Met Office](https://www.metoffice.gov.uk/) for developing and providing access to the [CRU-TS-4.09](https://crudata.uea.ac.uk/cru/data/hrg/cru_ts_4.09/) dataset, a vital source of historical climate data.

We also acknowledge the World Climate Research Programme ([WCRP](https://www.wcrp-climate.org/)), its Working Group on Coupled Modelling, and the Coupled Model Intercomparison Project Phase 6 ([CMIP6](https://pcmdi.llnl.gov/CMIP6/)) for coordinating and advancing global climate model development.

We are grateful to the climate modeling groups for producing and sharing their model outputs, the Earth System Grid Federation ([ESGF](https://esgf.llnl.gov/)) for archiving and providing access to the data, and the many funding agencies that support CMIP6 and ESGF.

![Sustentarea logo](images/sustentarea-logo.png)

`LogoClim` was developed with support from the [Sustentarea](https://github.com/sustentarea/) Research and Extension Center at the University of São Paulo ([USP](https://www.usp.br/)).

![CNPq logo](images/cnpq-logo.png)

This work was supported by the Department of Science and Technology of the Secretariat of Science, Technology, and Innovation and of the Health Economic-Industrial Complex ([SECTICS](https://www.gov.br/saude/pt-br/composicao/sectics)) of the [Ministry of Health](https://www.gov.br/saude/en) of Brazil, and the National Council for Scientific and Technological Development ([CNPq](https://www.gov.br/cnpq/)) (grant no. 444588/2023-0).

## REFERENCES

Eyring, V., Bony, S., Meehl, G. A., Senior, C. A., Stevens, B., Stouffer, R. J., & Taylor, K. E. (2016). Overview of the Coupled Model Intercomparison Project Phase 6 (CMIP6) experimental design and organization. *Geoscientific Model Development*, *9*(5), 1937-1958. https://doi.org/10.5194/gmd-9-1937-2016

Fick, S. E., & Hijmans, R. J. (2017). WorldClim 2: New 1-km spatial resolution climate surfaces for global land areas. *International Journal of Climatology*, *37*(12), 4302-4315. [https://doi.org/10.1002/joc.5086](https://doi.org/10.1002/joc.5086)

Harris, I., Osborn, T. J., Jones, P., & Lister, D. (2020). Version 4 of the CRU TS monthly high-resolution gridded multivariate climate dataset. *Scientific Data*, *7*(1), 109. [https://doi.org/10.1038/s41597-020-0453-3](https://doi.org/10.1038/s41597-020-0453-3)

O'Neill, B. C., Kriegler, E., Ebi, K. L., Kemp-Benedict, E., Riahi, K., Rothman, D. S., van Ruijven, B. J., van Vuuren, D. P., Birkmann, J., Kok, K., Levy, M., & Solecki, W. (2017). The roads ahead: Narratives for shared socioeconomic pathways describing world futures in the 21st century. *Global Environmental Change*, *42*, 169-180. [https://doi.org/10.1016/j.gloenvcha.2015.01.004](https://doi.org/10.1016/j.gloenvcha.2015.01.004)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
1
@#$#@#$#@
