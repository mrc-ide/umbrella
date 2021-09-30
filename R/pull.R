#' Extract mean daily precipitation
#'
#' @param sf A simple features object. See \link[sf] for more details.
#' @param start_date First extraction time point. A string with format: "yyyy-mm-dd".
#' @param end_date Last extraction time point. A string with format: "yyyy-mm-dd".
#'
#' @return Matrix
#' @export
pull_daily_rainfall <- function(sf, start_date, end_date){
  rgee::ee_Initialize()
  # Specify interfacing with Google Earth Engine model - CHIRPS daily
  chirps <- rgee::ee$ImageCollection("UCSB-CHG/CHIRPS/DAILY") %>%
    rgee::ee$ImageCollection$filterDate(start_date, end_date) %>%
    rgee::ee$ImageCollection$map(function(x){
      x$select("precipitation")
    })  %>%
    rgee::ee$ImageCollection$toBands()
  # Extract the data - default mean summary implemented
  chirps_extract <- rgee::ee_extract(x = chirps, y = sf, sf = FALSE)
}
