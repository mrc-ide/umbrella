#' Create vector of URLs for CHIRPS daily rainfall download
#'
#' @param year A year
#'
#' @return Vector of URLs
urls <- function(year){
  leap <- year %in% c(2004, 2008, 2012, 2016, 2020, 2024,
                      2028, 2032, 2036, 2040, 2044, 2048,
                      2052, 2056, 2060, 2064, 2068, 2072,
                      2076, 2080, 2084, 2088, 2092, 2096)
  months_length <- c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
  months_length[2] <- months_length[2] + leap

  years <- rep(year, sum(months_length))
  months <- rep(1:12, months_length)
  months[months < 10] <- paste0("0", months[months < 10])
  days <- unlist(sapply(months_length, function(x){1:x}))
  days[days < 10] <- paste0("0", days[days < 10])

  links(core = "ftp://ftp.chg.ucsb.edu/pub/org/chg/products/CHIRP/daily/", years, months, days)
}

#' Create links
#'
#' @param core Core link
#' @param years Years
#' @param months Months
#' @param days Days
#'
#' @return Formtted URL
links <- function(core, years, months, days){
  paste0(core, years, "/chirp.", years, ".", months, ".", days, ".tif")
}

#' Download CHIRPs rasters
#'
#' @param years Vector of years
#' @param days Vector of days of year
#' @param output_address Save location
#' @param quiet If \code{TRUE}, suppress status messages (if any), and the progress bar.
#'
#' @return NULL
#' @export
#'
#' @examples
#' \dontrun{
#' download(2017:2019, 1:366, "E:/CHIRPS")
#' }
download <- function(years, days, output_address, quiet = TRUE){
  stopifnot(all(days > 0))
  stopifnot(all(days < 367))
  if(min(years) < 1981){
    stop("CHIRPs data only available from 1980")
  }
  if(max(years) > format(Sys.Date(), "%Y")){
    stop("Years extends beyond present")
  }

  address <- unlist(lapply(years, function(x){
    u <- urls(x)
    u[days[days <= length(u)]]
  }))
  filenames <- paste0(output_address, "/", sub(".*/", "", address))
  purrr::map2(address, filenames, utils::download.file, mode = "wb", quiet = quiet)
}
