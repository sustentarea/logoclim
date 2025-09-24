## v2.1.0.9000 (Development Version)

- **Hotfix**: Fix inversion of latitude/longitude values.

- Adjusted slider limits and added value validation for black/white settings.
- Removed the *Bioclimatic Variable* monitor. Now it is displayed directly on the *Climate Variable* monitor.
- Added a color bar to the interface for better visualization of patch values.
- Added the slider `color-bar-bins` to control the number of bins in the color bar.

## v2.1.0 (2025-09-16)

- Added a `#headless?` parameter to the `setup` procedure for improved headless execution.
- Removed the `#tick` and `#wait` parameters from the `go` procedure; it now has no parameters, simplifying execution.
- Updated the `go-back` procedure to reset ticks and clear all plots.
- Converted `NaN` values produced by the [GIS extension](https://docs.netlogo.org/gis.html) (used to represent missing data) into `false`, following [Seth Tisue's suggestion](https://github.com/NetLogo/NetLogo/issues/2554). This fixes problems with primitives such as `export-world` and `import-world` (see [GIS Known Issues](https://docs.netlogo.org/gis.html#known-issues)).
- Converted string parameters and interface text to title case.
- Improved the `show-value` procedure to provide better contrast for patch labels.
- Added a 12-month moving average for patches. Patches now have two additional attributes: `value-12` (last 12 months of values) and `value-12ma` (12-month moving average).
- Updated plot behaviors: added a 12-month moving average pen, added indicators for the start of each 12-month cycle, and y-axis now dynamically adjusts based on the minimum, maximum, and interquartile range of the 12-month data window.
- Removed the `halt` procedure; error messages now provide more descriptive text.
- Added the [`Logônia`](https://github.com/sustentarea/logonia) model as a reference for `LogoClim` integration.
- Updated [Quarto](https://quarto.org/) notebooks.
- Updated documentation to reflect all changes.

## v2.0.0 (2025-07-29)

- **Breaking change**: Updated the model for compatibility with **NetLogo 7.0.0**.

- Resized interface widgets to match the new NetLogo standard dimensions.
- Changed the `LogoClim` license from MIT to GPLv3.
- Removed the `transition-seconds` slider, as it is no longer necessary.
- Removed the `adjust-world-size?` slider; world size adjustment is now always enabled by default.
- Introduced the global variable `plot-max-y-range` to optimize computations.
- Revised documentation to reflect updates.

## v1.0.0 (2025-07-03)

First stable release. 🎉

## v0.0.0.9015 (2025-07-02) (Pre-Release)

- Added variations (e.g., ACCESS-ESM1-5) and additional (e.g., CanESM5) Global Climate Models (GCMs) as selectable options in `global-climate-model`. WorldClim provides a dedicated webpage for this data, available [here](https://www.worldclim.org/data/cmip6_all/cmip6_clim2.5m.html).
- Fixed an issue with year intervals when using the *Future Climate Data* series

## v0.0.0.9013 (2025-06-24) (Pre-Release)

- Improved the documentation.
- Removed all dependencies on the `R` programming language and its packages.
- Improved `setup-world` to address bleeding issues.
- Persistent world bleeding is now converted to `NaN` values.
- Enhanced Quarto notebooks to fix dateline issues.
- Automated the generation of README and LICENSE files in the
  Quarto notebooks.
- Removed `patch-px-size` slider and added `adjust-world-size?` slider for
  automatic world size adjustment.
- Removed automatic adjustment of `start-year`. An error is now raised if
  `start-year` is not set to a valid value.
- Removed unnecessary dependencies and refactored code structure for improved
  maintainability.

## v0.0.0.9010 (2025-06-09) (Pre-Release)

- Fixed an issue with Windows file paths for improved cross-platform
compatibility.

## v0.0.0.9009 (2025-06-09) (Pre-Release)

- Enhanced Quarto notebooks for improved readability and clarity.
- Refactored codebase to increase modularity and maintainability.
- Fixed world bleeding issues at higher resolutions.
- Updated charts to display whole numbers.
- Expanded documentation.

## v 0.0.0.9006 (2025-04-15) (Pre-Release)

- Improved internal mechanisms for better performance and reliability.

## v 0.0.0.9004 (2024-09-14) (Pre-Release)

First pre-release. 🎉

## v0.0.0.9000 (2024-09-14)

- Added a `NEWS.md` file to track changes to the model.
