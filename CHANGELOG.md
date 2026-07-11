# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## v2.1.0.9000 (development version)

### Added

- A first draft of `LogoClim` User Manual, now available at [https://sustentarea.github.io/logoclim/](https://sustentarea.github.io/logoclim/). The manual is a work in progress and will be continuously updated.
- A new color bar widget for better visualization of patch values.
- A new global variable `cell-size` to store the size of each patch in degrees.
- Automated unit tests covering most supported configurations using the [`check-netlogo`](https://github.com/danielvartan/netlogo-actions) action from the [`LogoActions`](https://github.com/danielvartan/logoactions) project. Tests run on Windows, macOS, and Linux with the latest NetLogo release at each commit. Due to computational constraints, only `10m` resolution settings are tested. For future climate data, only SSP-126 is included because other SSPs are not consistently available across the Global Climate Models (GCMs). [GCM variations](https://www.worldclim.org/data/cmip6/cmip6_clim10m.html#:~:text=GCMs%20there%20are-,variations,-available%20here.) are not tested.
- Automated unit tests on near-equality comparisons between WorldClim original files and `LogoClim` patch values, as well as procedure behavior tests, now included in the user manual and rendered at each commit. Tests run on Windows, macOS, and Linux with the latest NetLogo release.

### Changed

- The *Bioclimatic Variable* monitor was removed and is now displayed directly on the *Climate Variable* monitor.
- Slider limits were adjusted and value validation for blank/empty settings was added.
- Code of Conduct updated to [Contributor Covenant 3.0](https://www.contributor-covenant.org/version/3/0/code_of_conduct/).
- All dependencies were updated to their latest versions.
- Documentation updated to reflect all changes.

### Fixed

- `latitude`/`longitude` inversion issue.
- `bioclimatic variables` 13-18 not working when future climate data was selected.

## v2.1.0 (2025-09-16)

### Added

- A `#headless?` parameter to the `setup` procedure for improved headless execution.
- Two additional patch attributes: `value-12` (last 12 months of values) and `value-12ma` (12-month moving average).
- A 12-month moving average pen to plots, along with indicators for the start of each 12-month cycle. The y-axis now dynamically adjusts based on the minimum, maximum, and interquartile range of the 12-month data window.
- The [`Logônia`](https://github.com/sustentarea/logonia) model as a reference for `LogoClim` integration.

### Changed

- The `#tick` and `#wait` parameters were removed from the `go` procedure; it now has no parameters, simplifying execution.
- The `go-back` procedure now resets ticks and clears all plots.
- String parameters and interface text were converted to title case.
- The `show-value` procedure was improved to provide better contrast for patch labels.
- The `halt` procedure was removed; error messages now provide more descriptive text.
- Quarto notebooks were updated.
- Documentation updated to reflect all changes.

### Fixed

- `NaN` values produced by the [GIS extension](https://docs.netlogo.org/gis.html) are now converted to `false`, following [Seth Tisue's suggestion](https://github.com/NetLogo/NetLogo/issues/2554). This fixes problems with primitives such as `export-world` and `import-world` (see [GIS Known Issues](https://docs.netlogo.org/gis.html#known-issues)).

## [2.0.0] - 2025-07-29

### Added

- A global variable named `plot-max-y-range` to optimize computations.

### Changed

- Interface widgets were resized to match the new NetLogo standard dimensions.
- The model's license was changed from [MIT](https://opensource.org/license/mit) to [GPLv3](https://opensource.org/license/gpl-3-0).

### Removed

- The `transition-seconds` slider, as it is no longer necessary.
- The `adjust-world-size?` slider; world size adjustment is now always enabled by default.

### Breaking

- The model now requires **NetLogo 7.0.1** or later.

## [1.0.0] - 2025-07-03

First stable release! 🎉

## [0.0.0.9015] - 2025-07-02 (Pre-Release)

### Added

- Variations (e.g., ACCESS-ESM1-5) and additional (e.g., CanESM5) Global Climate Models (GCMs) as selectable options in `global-climate-model`. WorldClim provides a dedicated webpage for this data, available [here](https://www.worldclim.org/data/cmip6_all/cmip6_clim2.5m.html).

### Fixed

- The year interval issue when using the *Future Climate Data* series.

## [0.0.0.9013] - 2025-06-24 (Pre-Release)

### Added

- `adjust-world-size?` slider for automatic world size adjustment.
- Automated generation of README and LICENSE files in Quarto notebooks.

### Changed

- `setup-world` was improved to address bleeding issues.
- Quarto notebooks were enhanced to fix dateline issues.
- Unnecessary dependencies were removed and code structure was refactored for improved maintainability.
- Documentation updated to reflect all changes.

### Removed

- All dependencies on the [R](https://www.r-project.org/) programming language and its packages.
- `patch-px-size` slider.
- The automatic adjustment of `start-year`. An error is now raised if `start-year` is not set to a valid value.

### Fixed

- Persistent world bleeding is now converted to `NaN` values.

## [0.0.0.9010] - 2025-06-09 (Pre-Release)

### Fixed

- The Windows file path issue, for improved cross-platform compatibility.

## [0.0.0.9009] - 2025-06-09 (Pre-Release)

### Changed

- Quarto notebooks were enhanced for improved readability and clarity.
- The codebase was refactored to increase modularity and maintainability.
- Charts were updated to display whole numbers.
- Documentation updated to reflect all