#' Process rainfall data
#'
#' @param gee_output Output from gee call using \code{\link{pull_daily_rainfall}}
#' @param ... Grouping variables
#'
#' @return Model, coefficients, representative seasonalilty profile and rainfall data per group
#' @export
process <- function(gee_output, ...){
  rain <- gee_output %>%
    tidyr::pivot_longer(-c(...), names_to = "date", values_to = "rainfall") %>%
    dplyr::mutate(date = as.Date(as.character(readr::parse_number(date)), format = "%Y%m%d"),
                  year = lubridate::year(date),
                  day_of_year = lubridate::yday(date),
                  t = day_of_year / 365) %>%
    dplyr::filter(day_of_year < 366) %>%
    dplyr::group_by(...) %>%
    dplyr::summarise(
      model = list(
        fourier_model(rainfall, t)
      ),
      coefficients = list(
        fourier_ceofficient(model[[1]])
      ),
      profile = list(
        fourier_predict(model[[1]], t = 1:365 / 365)
      ),
      rainfall_data = list(
        data.frame(
          date = date, rainfall = rainfall
        )
      )) %>%
    dplyr::ungroup() %>%
    dplyr::select(..., rainfall_data, model, coefficients, profile)

  return(rain)
}
