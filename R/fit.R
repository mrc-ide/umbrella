#' Fourier fitting function
#'
#' @param target Vector of rainfall
#' @param t Vector of times. A year runs between 0 and 1, so if we have 365 daily
#' rainfall data points then \code{t = seq(0, 1, length.out = 365)}.
#' If we had 3 years of daily rainfall points then \code{t = seq(0, 3, length.out = 365 * 3)}.
#'
#' @return Optim output
#' @export
fit_season <- function(target, t){
  stats::optim(par = rep(0, 7),
        target = target, t = t,
        fn = season_optim,
        method = "L-BFGS-B",
        lower = rep(-1, 7), upper = rep(1, 7))
}

#' Fourier fitting function internal
#'
#' @inheritParams fit_season
#' @param par Vector of parameters
#' @param ss Return sum of squares or prediction
#'
#' @return if \code{ss = TRUE} Sum of squared differences else prediction
#' @export
season_optim <- function(par, target, t, ss = TRUE){
  stopifnot(length(target) == length(t))
  season_pred <- seasonality(par, t)
  if(!ss){
    return(season_pred)
  } else {
    return(sum(abs(season_pred - target)))
  }
}
