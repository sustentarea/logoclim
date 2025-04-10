# library(checkmate)
# library(httr)

get_content_length <- function(url) {
  url_pattern <- paste0(
    "(http[s]?|ftp)://(?:[a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|",
    "(?:%[0-9a-fA-F][0-9a-fA-F]))+"
  )

  checkmate::assert_string(url, pattern = url_pattern)

  request <- try({url |> httr::HEAD()}, silent = TRUE)

  if (class(request) == "try-error") {
    as.numeric(NA)
  } else if (!is.null(request$headers$`Content-Length`)) {
    as.numeric(request$headers$`content-length`)
  } else {
    as.numeric(NA)
  }
}
