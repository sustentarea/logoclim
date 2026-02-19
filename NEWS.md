# v2.1.0.9000 (development version)

- A first draft of `LogoClim` User Manual is now available in the `docs/` folder and online at [https://sustentarea.github.io/logoclim/](https://sustentarea.github.io/logoclim/). The manual is a work in progress and will be continuously updated.
- Automated unit tests on near-equality comparisons between WorldClim original files and `LogoClim` patch values, as well as procedure behavior tests, are now included in the user manual and rendered at each commit.
- A `color-bar-bins` slider was added to control the number of bins in the color bar.
- The interface now has a new color bar widget for better visualization of patch values.
- The *Bioclimatic Variable* monitor was removed. Now it is displayed directly on the *Climate Variable* monitor.
- Automated unit tests now cover most supported configurations using the [`check-netlogo`](https://github.com/danielvartan/netlogo-actions) action from the `LogoActions` project. Tests run on Windows, macOS, and Linux with the latest NetLogo release. Due to computational constraints, only 10m resolution settings are tested. For future climate data, only SSP-126 is included because other SSPs are not consistently available across GCMs. [GCM variations](https://www.worldclim.org/data/cmip6/cmip6_clim10m.html#:~:text=GCMs%20there%20are-,variations,-available%20here.) are not tested.
- A new global variable `cell-size` was added to store the size of each patch in degrees.
- Slider limits were adjusted and value validation for blank/empty settings was added.
- The issue with `bioclimatic variables` 13–18 not working when future climate data was selected was fixed.
- `latitude`/`longitude` inversion issue was fixed.
- Code of Conduct updated to [Contributor Covenant 3.0](https://www.contributor-covenant.org/version/3/0/code_of_conduct/).
- The documentation was updated to reflect all changes.

# v2.1.0 (2025-09-16)

- A `#headless?` parameter was added to the `setup` procedure for improved headless execution.
- The `#tick` and `#wait` parameters were removed from the `go` procedure; it now has no parameters, simplifying execution.
- The `go-back` procedure now resets ticks and clears all plots.
- `NaN` values produced by the [GIS extension](https://docs.netlogo.org/gis.html) are now converted to `false`, following [Seth Tisue's suggestion](https://github.com/NetLogo/NetLogo/issues/2554). This fixes problems with primitives such as `export-world` and `import-world` (see [GIS Known Issues](https://docs.netlogo.org/gis.html#known-issues)).
- String parameters and interface text were converted to title case.
- The `show-value` procedure was improved to provide better contrast for patch labels.
- Patches now have two additional attributes: `value-12` (last 12 months of values) and `value-12ma` (12-month moving average).
- The plot behaviors were updated. A 12-month moving average pen was added, indicators for the start of each 12-month cycle were added, and the y-axis now dynamically adjusts based on the minimum, maximum, and interquartile range of the 12-month data window.
- The `halt` procedure was removed; error messages now provide more descriptive text.
- The [`Logônia`](https://github.com/sustentarea/logonia) model was added as a reference for `LogoClim` integration.
- [Quarto](https://quarto.org/) notebooks were updated.
- The documentation was updated to reflect all changes.

# v2.0.0 (2025-07-29)

### Breaking Changes

- The model now requires **NetLogo 7.0.1*- or later.

### New Features and Improvements

- Interface widgets were resized to match the new NetLogo standard dimensions.
- The model's license was changed from [MIT](https://opensource.org/license/mit) to [GPLv3](https://opensource.org/license/gpl-3-0).
- The `transition-seconds` slider was removed, as it is no longer necessary.
- The `adjust-world-size?` slider was removed; world size adjustment is now always enabled by default.
- A global variable named `plot-max-y-range` was introduced to optimize computations.

# v1.0.0 (2025-07-03)

First stable release! 🎉

# v0.0.0.9015 (2025-07-02) (Pre-Release)

- Variations (e.g., ACCESS-ESM1-5) and additional (e.g., CanESM5) Global Climate Models (GCMs) were added as selectable options in `global-climate-model`. WorldClim provides a dedicated webpage for this data, available [here](https://www.worldclim.org/data/cmip6_all/cmip6_clim2.5m.html).
- The year interval issue when using the *Future Climate Data- series was fixed.

# v0.0.0.9013 (2025-06-24) (Pre-Release)

- All dependencies on the [R](https://www.r-project.org/) programming language and its packages were removed.
- `setup-world` was improved to address bleeding issues.
- Persistent world bleeding is now converted to `NaN` values.
- Quarto notebooks were enhanced to fix dateline issues.
- Generation of README and LICENSE files in Quarto notebooks was automated.
- `patch-px-size` slider was removed and `adjust-world-size?` slider was added for automatic world size adjustment.
- The automatic adjustment of `start-year` was removed. An error is now raised if `start-year` is not set to a valid value.
- Unnecessary dependencies were removed and code structure was refactored for improved maintainability.
- The documentation was updated to reflect all changes.

# v0.0.0.9010 (2025-06-09) (Pre-Release)

- The windows file path issue was fixed for improved cross-platform compatibility.

# v0.0.0.9009 (2025-06-09) (Pre-Release)

- Quarto notebooks were enhanced for improved readability and clarity.
- The codebase was refactored to increase modularity and maintainability.
- World bleeding issues at higher resolutions were fixed.
- Charts were updated to display whole numbers.
- The documentation was updated to reflect all changes.

# v 0.0.0.9006 (2025-04-15) (Pre-Release)

- Internal mechanisms were improved for better performance and reliability.

# v 0.0.0.9004 (2024-09-14) (Pre-Release)

First pre-release! 🎉

# v0.0.0.9000 (2024-09-14)

- Added a `NEWS.md` file to track changes to the model.
