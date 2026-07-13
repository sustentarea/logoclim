---
title: "LogoClim: WorldClim in NetLogo"
tags:
  - Agent-Based Models
  - WorldClim
  - Climate Change
  - Reproducible Research
  - Raster Data
  - CMIP6
  - Historical Climate Data
  - Future Climate Scenarios
  - Shared Socioeconomic Pathways
  - NetLogo
  - LevelSpace
  - Complex Systems
  - Complexity Science
  - Simulations
  - Climate Simulations
  - Environmental Sciences
authors:
  - given-names: Daniel
    surname: Vartanian
    orcid: 0000-0001-7782-759X
    affiliation: 1
  - given-names: Leandro
    surname: Garcia
    orcid: 0000-0001-5947-2617
    affiliation: 2
  - given-names: Aline Martins
    dropping-particle: de
    surname: Carvalho
    orcid: 0000-0002-4900-5609
    affiliation: 3
    corresponding: true
affiliations:
- name: School of Arts, Sciences, and Humanities, University of São Paulo, São Paulo, Brazil
  index: 1
- name: School of Medicine, Queen's University Belfast, Belfast, United Kingdom
  index: 2
- name: School of Public Health, University of São Paulo, São Paulo, Brazil
  index: 3
date: 9 July 2026
bibliography: paper.bib
---

# Summary

`LogoClim` is a [NetLogo](https://www.netlogo.org) model for simulating and visualizing global climate conditions. It allows researchers to integrate high-resolution climate data into agent-based models, supporting reproducible research in ecology, agriculture, environmental sciences, and other fields that rely on climate data.

The model utilizes raster data to represent climate variables such as temperature and precipitation over time. It incorporates historical data (1951-2024) and future climate projections (2021-2100) derived from global climate models under various Shared Socioeconomic Pathways ([SSPs](https://climatedata.ca/resource/understanding-shared-socio-economic-pathways-ssps/)) [@oneill2017]. All climate inputs come from the [WorldClim 2.1](https://worldclim.org/) project, a widely used source of high-resolution climate datasets [@fick2017], available for academic and other non-commercial use.

`LogoClim` follows the FAIR Principles for Research Software [@barker2022] and is openly available on the [CoMSES Network](https://www.comses.net/codebases/bccd451f-76a4-408a-85fd-c5024359ba9a/) and [GitHub](https://github.com/sustentarea/logoclim).\autoref{fig:logoclim-interface-1} and \autoref{fig:logoclim-interface-2} illustrate the model's interface and functionality. See the [`Logônia`](https://github.com/sustentarea/logonia) model [@vartanian2026g] for an example of its integration into a full NetLogo simulation.

![LogoClim Graphical User Interface — Brazil.\label{fig:logoclim-interface-1}](images/logoclim-interface-bra-10m-hmwd.png){width=100%}

\newpage

# Statement of need

The lack of reproducibility is a major concern in science [@baker2016], including in computational research [@peng2011]. This challenge is particularly relevant for agent-based models, which are used to simulate complex phenomena [@grimm2006a; @grimm2020]. One effective strategy to address this issue is the development of open, specialized tools that enhance transparency and promote standardization, and reusability among researchers [@ram2019; @berger2024]. This is why `LogoClim` was created.

The `LogoClim` model was developed for seamless integration with other models through NetLogo's [`LevelSpace`](https://ccl.northwestern.edu/netlogo/docs/ls.html)  extension [@hjorth2020], which enables parallel execution and data exchange between models. This integration capability makes it particularly valuable for agent-based simulations that incorporate climate data to study ecological, environmental, or social processes affected by climate conditions.

The model was originally developed as part of a project by the [Sustentarea](https://www.fsp.usp.br/sustentarea/) Research and Extension Center, aimed at evaluating the impact of climate change on the health and nutrition of Brazilian children under five years old [@carvalho2023a]. Over the course of its development, however, we realized that its applications extend well beyond the scope of the study.

While other programming languages, such as [R](https://www.r-project.org/), offer tools like the [`geodata`](https://CRAN.R-project.org/package=geodata) package [@hijmans2024], there are currently no equivalent tools providing this functionality for NetLogo.

# How it works

`LogoClim` operates on a grid of patches, with each patch representing a geographic area and storing values for latitude, longitude, and selected climate variables. During simulation, patches update their colors based on the underlying data, enabling users to visualize spatial and temporal changes. The model interface also provides plots showing the mean, minimum, maximum, and standard deviation of the selected variable over time.

The model supports all three climate data series from [WorldClim 2.1](https://worldclim.org/): long-term historical climate averages (1970–2000), historical monthly weather (1951–2024), and future climate projections (2021–2100). Each series is available at multiple spatial resolutions (from 10 minutes (~340 km² at the equator) to 30 seconds (~1 km² at the equator)), which can be selected within the model interface. Further details about each series are available on the WorldClim website.

The datasets are available for download from [WorldClim 2.1](https://worldclim.org/), but must be converted to [Esri ASCII](https://en.wikipedia.org/wiki/Esri_grid#ASCII) format for compatibility with NetLogo. We provide tools to automate and simplify the conversion process, which are described in the model's [user manual](https://sustentarea.github.io/logoclim/).

We also provide example datasets for testing and demonstration. These files are available in the model's [OSF repository](https://doi.org/10.17605/OSF.IO/RE95Z) and are ready to use with `LogoClim`. To illustrate how `LogoClim` can be used in practice, we also developed the [`Logônia`](https://github.com/sustentarea/logonia) model [@vartanian2026g], which showcases its integration into a full NetLogo simulation.

![LogoClim Graphical User Interface — United Kingdom.\label{fig:logoclim-interface-2}](images/logoclim-interface-gbr-30s-hcd.png){width=100%}

# Acknowledgements

We gratefully acknowledge [Stephen E. Fick](https://orcid.org/0000-0002-3548-6966), [Robert J. Hijmans](https://orcid.org/0000-0001-5872-2872), and the entire [WorldClim](https://worldclim.org/) team for their outstanding work in creating and maintaining the WorldClim datasets. `LogoClim` is an independent project with no affiliation to [WorldClim](https://www.worldclim.org) or its developers. Users should note that WorldClim datasets are freely available for academic and other non-commercial use only. Any use of WorldClim data within `LogoClim` must comply with [WorldClim's licensing terms](https://www.worldclim.org/about.html).

This work was supported by the [Sustentarea](https://www.fsp.usp.br/sustentarea/) Research and Extension Center at the University of São Paulo ([USP](https://www5.usp.br/)), the National Council for Scientific and Technological Development ([CNPq](https://www.gov.br/cnpq/)) of the Ministry of Science, Technology and Innovation ([MCTI](https://www.gov.br/mcti/)) of Brazil, and by the Department of Science and Technology ([DECIT](https://www.gov.br/saude/pt-br/composicao/sectics/decit/)) of the Secretariat of Science, Technology, Innovation and Strategic Health Inputs ([SECTICS](https://www.gov.br/saude/pt-br/composicao/sectics/)) of the Ministry of Health ([MS](https://www.gov.br/saude/)) of Brazil, through Call [CNPq/DECIT/SECTICS/MS No. 18/2023](https://www.gov.br/cnpq/pt-br/chamadas/todas-as-chamadas/chamadas-2023/chamada-ndeg-18-2023/chamada-publica-cnpq-decit-sectics-ms-ndeg-18-2023-ciencia-de-dados-mudancas-climaticas-e-impactos-para-a-saude) (No. 444588/2023-0).

# References
