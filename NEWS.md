# LogoClim (development version)

# LogoClim 1.0.0

First stable release. 🎉

# LogoClim 0.0.0.9015 (Pre-Release)

- Added variations (e.g., ACCESS-ESM1-5) and additional (e.g., CanESM5) Global Climate Models (GCMs) as selectable options in `global-climate-model`. WorldClim provides a dedicated webpage for this data, available [here](https://www.worldclim.org/data/cmip6_all/cmip6_clim2.5m.html).
- Fixed an issue with year intervals when using the *Future climate data* series.

# LogoClim 0.0.0.9013 (Pre-Release)

- Improved the documentation
- Removed all dependencies on the `R` programming language and its packages
- Improved `setup-world` to address bleeding issues
- Persistent world bleeding is now converted to `NaN` values
- Enhanced Quarto notebooks to fix dateline issues
- Automated the generation of README and LICENSE files in the
  Quarto notebooks
- Removed `patch-px-size` slider and added `adjust-world-size?` slider for
  automatic world size adjustment
- Removed automatic adjustment of `start-year`. An error is now raised if
  `start-year` is not set to a valid value.
- Removed unnecessary dependencies and refactored code structure for improved
  maintainability.

# LogoClim 0.0.0.9010 (Pre-Release)

- Fixed an issue with Windows file paths for improved cross-platform
compatibility

# LogoClim 0.0.0.9009 (Pre-Release)

- Enhanced Quarto notebooks for improved readability and clarity
- Refactored codebase to increase modularity and maintainability
- Resolved world bleeding issues at higher resolutions
- Updated charts to display whole numbers
- Expanded documentation

# LogoClim 0.0.0.9004 (Pre-Release)

First pre-release. 🎉

# LogoClim 0.0.0.9000

- Added a `NEWS.md` file to track changes to the model
