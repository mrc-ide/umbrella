#' Get number of days by month
#'
#' @param year Year
get_days <- function(year){
  start <- paste0(year, "-01-01")
  end <- paste0(year + 1, "-01-01")
  as.vector(diff(seq(as.Date(start), as.Date(end), by = "month")))
}

#' Get download urls for CHIRPS daily rainfall
#'
#' @param year Year
#' @param url_base Base URL
#'
#' @return Daily global rainfall raster urls
get_urls <- function(year, url_base = "https://data.chc.ucsb.edu/products/CHIRPS-2.0/global_daily/tifs/p25/"){
  if(year >= format(Sys.Date(), "%Y")){
    stop("Year must be in the past")
  }
  url_base_year <- paste0(url_base, year, "/chirps-v2.0.")
  n_days <- get_days(year)
  days <- unlist(sapply(n_days, function(x) 1:x))
  indexes <- data.frame(year = year,
                        month = stringr::str_pad(rep(1:12, n_days), 2, pad = "0"),
                        day = stringr::str_pad(days, 2, pad = "0"))
  urls <- apply(indexes, 1, function(x){
    paste0(url_base_year, x[1], ".", x[2], ".", x[3], ".tif.gz")
  })
  return(urls)
}

#' Download and unzip the raster
#'
#' @param url Raster URL
#' @param destination_file File address and name, file suffix must by .tif.gz,
#' the final unzipped file will be with suffix .tif.
download_raster <- function(url, destination_file){
  df <- utils::download.file(url = url, destfile = destination_file, mode = "wb", quiet = TRUE)
  R.utils::gunzip(destination_file)
}
