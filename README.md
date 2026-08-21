# LogoClim <img src="images/logo.svg" align="right" width="120" />

<!-- badges: start -->
[![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![DOI](https://joss.theoj.org/papers/10.21105/joss.08845/status.svg)](https://doi.org/10.21105/joss.08845)
[![CoMSES Network badge](https://img.shields.io/badge/CoMSES%20Network-2.2.1-1284C5.svg)](https://www.comses.net/codebases/bccd451f-76a4-408a-85fd-c5024359ba9a/)
[![Check NetLogo workflow badge](https://github.com/sustentarea/logoclim/workflows/check-netlogo.yaml/badge.svg)](https://github.com/sustentarea/logoclim/actions)
[![Render manual workflow badge](https://github.com/sustentarea/logoclim/workflows/render-manual.yaml/badge.svg)](https://github.com/sustentarea/logoclim/actions)
[![FAIR checklist badge](https://img.shields.io/badge/fairsoftwarechecklist.net--00a7d9)](https://fairsoftwarechecklist.net/v0.2?f=31&a=30112&i=32301&r=123)
[![fair-software.eu](https://img.shields.io/badge/fair--software.eu-%E2%97%8F%20%20%E2%97%8F%20%20%E2%97%8F%20%20%E2%97%8F%20%20%E2%97%8F-green)](https://fair-software.eu)
[![GNU GPLv3 license](https://img.shields.io/badge/license-GPLv3-bd0000.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Contributor Covenant 3.0 code of conduct badge](https://img.shields.io/badge/Contributor%20Covenant-3.0-4baaaa.svg)](https://www.contributor-covenant.org/version/3/0/code_of_conduct/)
<!-- badges: end -->

## Overview

`LogoClim` is a [NetLogo](https://www.netlogo.org) model designed to be integrated into other simulations through the [LevelSpace](https://docs.netlogo.org/ls) extension ([Hjorth et al., 2020](https://doi.org/10.18564/jasss.4130)), providing high resolution climate data from sources validated and used by the Intergovernmental Panel on Climate Change ([IPCC](https://www.ipcc.ch/)).

The model simplifies and standardizes the integration of climate data into NetLogo, allowing researchers to focus their efforts on the model itself with the assurance of using reliable and widely recognized data. Although its main use is as a component of larger simulations, `LogoClim` also has its own graphical interface for monitoring and checking the datasets.

For a deep look into the model's structure and implementation, see the [user manual](https://sustentarea.github.io/logoclim/).

> If you find this project useful, please consider giving it a star! &nbsp; [![GitHub repo stars](https://img.shields.io/github/stars/sustentarea/logoclim)](https://github.com/sustentarea/logoclim/)

<p align="center">
  <img src="images/logoclim-interface.gif" />
</p>

> [!NOTE]
> `LogoClim` is an independent project with no affiliation to [WorldClim](https://worldclim.org/) or its developers. Users should be aware that WorldClim datasets are freely available for academic and other non-commercial use only. Any use of WorldClim data within `LogoClim` must comply with [WorldClim's licensing terms](https://worldclim.org/about.html).

## How It Works

`LogoClim` uses raster data to represent climate variables such as temperature and precipitation over time. It incorporates historical data (1951-2024) and future climate projections (2021-2100) derived from [global climate models](https://www.climatehubs.usda.gov/hubs/northwest/topic/basics-global-climate-models) under various Shared Socioeconomic Pathways ([SSPs](https://climatedata.ca/resource/understanding-shared-socio-economic-pathways-ssps/), [O'Neill et al., 2017](https://doi.org/10.1016/j.gloenvcha.2015.01.004)).

The model operates on a grid of patches, where each patch represents a geographical area and stores values for latitude, longitude, and selected climate variables. During the simulation, patches update their colors based on the data values. The results can be visualized on a map, accompanied by plots that display the mean, minimum, maximum, and standard deviation of the selected variable over time.

All climate inputs come from [WorldClim 2.1](https://worldclim.org/), a widely used source of high-resolution climate datasets ([Fick & Hijmans, 2017](https://doi.org/10.1002/joc.5086)). These data series are offered at various spatial resolutions, ranging from 10 minutes (about 340 km² at the equator) to 30 seconds (about 1 km² at the equator).

### Historical Climate Data

This [series](https://www.worldclim.org/data/worldclim21.html) includes only 12 monthly data points representing long-term average climate conditions for the period 1970-2000. It provides averages on minimum, mean, and maximum temperature, precipitation, solar radiation, wind speed, vapor pressure, elevation, and on [bioclimatic variables](https://www.worldclim.org/data/bioclim.html).

### Historical Monthly Weather Data

This [series](https://www.worldclim.org/data/monthlywth.html) includes 12 monthly data points for each year from 1951 to 2024, based on [downscaled](https://worldclim.org/data/downscaling.html) data from [CRU-TS-4.09](https://crudata.uea.ac.uk/cru/data/hrg/cru_ts_4.09/), developed by the [Climatic Research Unit](https://www.uea.ac.uk/groups-and-centres/climatic-research-unit) at the [University of East Anglia](https://www.uea.ac.uk/) ([Harris et al., 2020](https://doi.org/10.1038/s41597-020-0453-3)). It provides monthly averages for minimum temperature, maximum temperature, and total precipitation.

### Future Climate Data

This [series](https://www.worldclim.org/data/cmip6/cmip6climate.html) includes 12 monthly data points from [downscaled](https://worldclim.org/data/downscaling.html) climate projections derived from the Coupled Model Intercomparison Project Phase 6 ([CMIP6](https://www.wcrp-climate.org/wgcm-cmip/wgcm-cmip6)) ([Eyring et al., 2016](https://doi.org/10.5194/gmd-9-1937-2016)) for four future periods: 2021-2040, 2041-2060, 2061-2080, and 2081-2100. The projections cover four Shared Socioeconomic Pathways ([SSPs](https://climatedata.ca/resource/understanding-shared-socio-economic-pathways-ssps/)): 126, 245, 370, and 585, with data available for average minimum temperature, average maximum temperature, total precipitation, and [bioclimatic variables](https://www.worldclim.org/data/bioclim.html).

Learn more about the data series in the [WorldClim](https://www.worldclim.org) website.

## Usage

To get started using `LogoClim`, you must have [NetLogo](https://www.netlogo.org) installed. The model was developed with NetLogo 7.0.4. Use this version or newer for best compatibility. The NetLogo [website](https://www.netlogo.org) provides easy installers for Windows, macOS, and Linux, along with detailed instructions for installation.

The model also depends on the NetLogo extensions: [`GIS`](https://docs.netlogo.org/gis.html), [`Pathdir`](https://github.com/cstaelin/Pathdir-Extension), [`String`](https://github.com/NetLogo/String-Extension), and [`Time`](https://docs.netlogo.org/time.html). These extensions are installed automatically when the model is run for the first time.

With NetLogo ready, follow these steps to get `LogoClim` up and running.

### A. Download the Model

You can download the latest release of the model from the [CoMSES Network](https://www.comses.net/codebases/bccd451f-76a4-408a-85fd-c5024359ba9a/). This is the recommended option for most users, as it provides a stable version of the model that has been tested and documented.

For the development version, you can clone or download the model [GitHub code repository](https://github.com/sustentarea/logoclim/) directly.

### B. Prepare the Data

The [CoMSES Network release](https://www.comses.net/codebases/bccd451f-76a4-408a-85fd-c5024359ba9a/) includes an example dataset that is ready to use with `LogoClim`. You can use it as a starting point. But, ideally you should prepare your own data to suit your research needs. The [user manual](https://sustentarea.github.io/logoclim/) will guide you through the process of downloading and preparing [WorldClim](https://www.worldclim.org/) data for use with `LogoClim`.

We also provide other example datasets for testing and demonstration. These files are available in the model's [OSF repository](https://doi.org/10.17605/OSF.IO/RE95Z) and are ready to use with `LogoClim`. Please note that these datasets are for demonstration purposes only and are not suitable for research applications. Always verify the suitability of the data for your specific research questions and objectives.

### C. Run the Model

With the files at hand, open the `logoclim.nlogox` file in NetLogo. You can find this file in the `code` directory when using the [CoMSES Network](https://www.comses.net/codebases/bccd451f-76a4-408a-85fd-c5024359ba9a/) release or in the `nlogox` folder when using the development version.

Use the **Select Data Directory** button in the model interface to specify their location. This will set the `data-path` global variable to the correct path, allowing the model to access the data. After that, you can configure the other parameters as needed.

Once everything is set, click on the `Setup` and then `Go` buttons to start the simulation. Learn more about the model interface and parameters in the model's *Info Tab* and the [user manual](https://sustentarea.github.io/logoclim/qmd/how-to-use-it.html#interface-controls).

## Integration with Other Models

`LogoClim` was created to be integrated with other models using NetLogo's [LevelSpace](https://docs.netlogo.org/ls) extension. This extension enables parallel execution and data exchange between models.

To facilitate this integration, we created the [`Logônia`](https://github.com/sustentarea/logonia) model ([Vartanian et al., 2026](https://github.com/sustentarea/logonia)), a fictional plant-growth model providing a practical example of how to integrate `LogoClim`. It is also available on the [CoMSES Network](https://www.comses.net/codebases/4f2be13a-3957-4537-bf64-3fad96ba271f/) and its code repository is available on [GitHub](https://github.com/sustentarea/logonia). See the [user manual](https://sustentarea.github.io/logoclim/qmd/levelspace.html) for integration instructions.

<p align="center">
  <img src="images/logonia-interface.gif" />
</p>

## User Manual

> [!NOTE]
> This section describes the technical setup required to render the user manual locally. You do not need any of this to use `LogoClim`.

`LogoClim`'s [user manual](https://sustentarea.github.io/logoclim/) is developed using the latest versions of the [Quarto](https://quarto.org/) publishing system, the [NetLogo](https://www.netlogo.org/) environment, and the [R](https://www.r-project.org/) programming language. To ensure consistent results, the [`renv`](https://rstudio.github.io/renv/) R package is used to manage and restore the R environment.

To render the manual or reproduce its analyses locally, install the dependencies listed above and follow the steps below.

1. **Clone** this repository to your local machine.
2. **Open** the project in the terminal or in your preferred [IDE](https://en.wikipedia.org/wiki/Integrated_development_environment).
3. **Install package dependencies** by running `Rscript -e "renv::restore()"` in the terminal or [`renv::restore()`](https://rstudio.github.io/renv/reference/restore.html) in an R console. Make sure R is installed and available in your system's [PATH](https://en.wikipedia.org/wiki/PATH_(variable)) before running this command.
4. **Open** the Quarto notebook files (`.qmd`) and run the code as described.

To render the entire manual, run the following command in the terminal:

```bash
quarto render
```

The rendering process may take some time depending on your machine. Once complete, the [Quarto](https://quarto.org/) book will be available in the [`docs`](docs) folder.

### Notes

- When running [`renv::restore()`](https://rstudio.github.io/renv/reference/restore.html), check the output for any missing system dependencies like [GDAL](https://gdal.org/). These are usually installed automatically via your OS package manager, but if something fails, you may need to handle them manually. See [`render-manual.yaml`](.github/workflows/render-manual.yaml) for a list of system dependencies required for your operating system.
- We do not recommend using external environments such as [Anaconda](https://www.anaconda.com/), as these can cause issues with R package installation and management. This project relies on several system dependencies, all of which are automatically installed via the Comprehensive R Archive Network ([CRAN](https://cran.r-project.org/)).
- We recommend using the installers provided by the [R Project](https://www.r-project.org/) or the [`rig`](https://github.com/r-lib/rig) installation manager from [`r-lib`](https://github.com/r-lib) when installing R. If your [IDE](https://en.wikipedia.org/wiki/Integrated_development_environment) lacks a built-in R console, consider installing [`arf`](https://github.com/eitsupi/arf) for a better experience.
- Avoid using [VPNs](https://en.wikipedia.org/wiki/Virtual_private_network), corporate proxies, or other network-routing tools while processing the data, as these can interfere with the downloads.
- If you run into issues with [`renv`](https://rstudio.github.io/renv/) (it can be [a bit of a pain](https://youtu.be/l01u7Ue9pIQ?si=S44LlHVSufGJ4zdq) sometimes), you can use [`renv::deactivate(clean = TRUE)`](https://rstudio.github.io/renv/reference/activate.html) to remove the environment completely. In that case, you will need to install all required packages manually.

## Contributing

[![](https://img.shields.io/badge/Contributor%20Covenant-3.0-4baaaa.svg)](https://www.contributor-covenant.org/version/3/0/code_of_conduct/)

Contributions are always welcome, whether that's reporting bugs, suggesting features, or improving the code or documentation.

Before opening a new issue, please check the [issues tab](https://github.com/sustentarea/logoclim/issues) to see if your topic has already been reported.

[![](https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=%23fe8e86)](https://github.com/sponsors/danielvartan)

You can also support the development of `LogoClim` by becoming a sponsor.

Click [here](https://github.com/sponsors/danielvartan) to make a donation. Please mention `LogoClim` in your donation message.

## Citation

> [!NOTE]
> When using WorldClim data, you must also cite the original data sources.
>
> The appropriate citation depends on the specific dataset utilized. Please refer to the [WorldClim website](https://www.worldclim.org/data/index.html#citation) for up-to-date citation guidelines and dataset references.

[![DOI](https://joss.theoj.org/papers/10.21105/joss.08845/status.svg)](https://doi.org/10.21105/joss.08845)

If you use this model in your research, please cite it to acknowledge the effort invested in its development and maintenance. Your citation helps support the ongoing improvement of the model.

To cite `LogoClim` in publications please use the following format:

Vartanian, D., Garcia, L., & Carvalho, A. M. (2026). LogoClim: WorldClim in NetLogo. *Journal of Open Source Software*, *11*(124), 8845. <https://doi.org/10.21105/joss.08845>

A BibLaTeX entry for LaTeX users is:

```latex
@article{vartanian2026h,
  title = {LogoClim: WorldClim in NetLogo},
  author = {{Daniel Vartanian} and {Leandro Garcia} and {Aline Martins de Carvalho}},
  year = {2026},
  journaltitle = {Journal of Open Source Software},
  volume = {11},
  number = {124},
  pages = {8845},
  issn = {2475-9066},
  doi = {10.21105/joss.08845}
}
```

## License

[![](https://img.shields.io/badge/license-GPLv3-bd0000.svg)](https://www.gnu.org/licenses/gpl-3.0)

``` text
Copyright (C) 2026 Sustentarea Research and Extension Center

LogoClim is free software: you can redistribute it and/or modify it under the
terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program. If not, see <https://www.gnu.org/licenses/>.
```

## Acknowledgments

We gratefully acknowledge [Robert J. Hijmans](https://orcid.org/0000-0001-5872-2872), [Stephen E. Fick](https://orcid.org/0000-0002-3548-6966), and the entire [WorldClim](https://worldclim.org/) team for their outstanding work in creating and maintaining the WorldClim datasets.

We thank the [Climatic Research Unit](https://www.uea.ac.uk/groups-and-centres/climatic-research-unit) at the [University of East Anglia](https://www.uea.ac.uk/) and the United Kingdom's [Met Office](https://www.metoffice.gov.uk/) for developing and providing access to the [CRU-TS-4.09](https://crudata.uea.ac.uk/cru/data/hrg/cru_ts_4.09/) dataset, a vital source of historical climate data.

We also acknowledge the World Climate Research Programme ([WCRP](https://www.wcrp-climate.org/)), its Working Group on Coupled Modelling, and the Coupled Model Intercomparison Project Phase 6 ([CMIP6](https://pcmdi.llnl.gov/CMIP6/)) for coordinating and advancing global climate model development.

We are grateful to the climate modeling groups for producing and sharing their model outputs, the Earth System Grid Federation ([ESGF](https://esgf.llnl.gov/)) for archiving and providing access to the data, and the many funding agencies that support [CMIP6](https://pcmdi.llnl.gov/CMIP6/) and [ESGF](https://esgf.llnl.gov/).

<table>
  <tr>
    <td width="30%" valign="center">
      <p align="center">
        <a href="https://www.fsp.usp.br/sustentarea/">
          <img src="images/sustentarea-logo.svg" width="115" alt="Sustentarea Logo"/>
        </a>
      </p>
    </td>
    <td width="70%" valign="center">
      <p>
        This work was supported by the
        <a href="https://www.fsp.usp.br/sustentarea/">Sustentarea</a>
         Research and Extension Center at the University of São Paulo (<a href="https://www5.usp.br/">USP</a>).
      </p>
    </td>
  </tr>
</table>

<table>
  <tr>
    <td width="30%" valign="center">
      <p align="center">
        <a href="https://resiclima.com.br/">
          <img src="images/resiclima-logo.svg" width="115" alt="RESICLIMA Network Logo"/>
        </a>
      </p>
    </td>
    <td width="70%" valign="center">
      <p>
        This work was supported by the <a href="https://resiclima.com.br/">Resiclima Network</a>, an international collaboration for the multidimensional and
        interdisciplinary study of global climate change.
      </p>
    </td>
  </tr>
</table>

<table>
  <tr>
    <td width="30%" valign="center">
      <p align="center">
        <a href="https://www.gov.br/cnpq/">
          <img src="images/cnpq-logo.svg" width="150" alt="CNPq Logo"/>
        </a>
      </p>
    </td>
    <td width="70%" valign="middle">
      <p>
        This work was supported by the National Council for Scientific and Technological Development (<a href="https://www.gov.br/cnpq/">CNPq</a>) of the Ministry of Science, Technology and Innovation (<a href="https://www.gov.br/mcti/">MCTI</a>) of Brazil and by the Department of Science and Technology (<a href="https://www.gov.br/saude/pt-br/composicao/sectics/decit/">DECIT</a>) of the Secretariat of Science, Technology, Innovation and Strategic Health Inputs (<a href="https://www.gov.br/saude/pt-br/composicao/sectics/">SECTICS</a>) of the Ministry of Health (<a href="https://www.gov.br/saude/">MS</a>) of Brazil, through Call <a href="https://www.gov.br/cnpq/pt-br/chamadas/todas-as-chamadas/chamadas-2023/chamada-ndeg-18-2023/chamada-publica-cnpq-decit-sectics-ms-ndeg-18-2023-ciencia-de-dados-mudancas-climaticas-e-impactos-para-a-saude">CNPq/DECIT/SECTICS/MS No. 18/2023</a> (No. 444588/2023-0).
      </p>
    </td>
  </tr>
</table>
