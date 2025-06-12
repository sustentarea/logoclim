# library(rutils) # github.com/danielvartan/rutils

wc_license <- function() {
  paste0(
    "# WorldClim 2.1",
    "\n\n",
    rutils:::long_string(
      "
      The data are freely available for academic use and other non-commercial
      use. Redistribution or commercial use is not allowed without prior
      permission. Using the data to create maps for publishing of academic
      research articles is allowed. Thus you can use the maps you made with
      WorldClim data for figures in articles published by PLoS, Springer
      Nature, Elsevier, MDPI, etc. You are allowed (but not required) to
      publish these articles (and the maps they contain) under an open
      license such as CC-BY as is the case with PLoS journals and may be the
      case with other open access articles.
      "
    ),
    "\n\n",
    "Please send your questions to <info@worldclim.org>.",
    "\n\n",
    "> Extracted from <https://worldclim.org/about.html> on ",
    "2025-06-06."
  )
}
